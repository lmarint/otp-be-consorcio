
// lib/utils/public_ip_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Servicio para obtener la IP pública (IPv4).
/// - Usa ipify como fuente principal: https://api.ipify.org?format=json
/// - Tiene fallback a ifconfig.co.
/// - Cachea la IP por un tiempo (ej. 30 min) para evitar llamadas repetidas.
/// - Maneja timeouts y reintentos simples.
class PublicIpService {
  static const _storage = FlutterSecureStorage();
  static const _keyIpPub = 'public_ip_v4';
  static const _keyIpTimestamp = 'public_ip_timestamp_epoch'; // millisecondsSinceEpoch

  /// Minutos de cache antes de refrescar
  static const int _cacheMinutes = 30;

  /// Timeout por request de IP
  static const Duration _timeout = Duration(seconds: 6);

  /// Número máximo de reintentos (suma fuentes)
  static const int _maxTries = 2;

  /// Obtiene la IP pública. Intenta usar cache; si está vencido, consulta la red.
  static Future<String?> getPublicIpV4() async {
    // 1) Intentar cache
    final cachedIp = await _storage.read(key: _keyIpPub);
    final tsStr = await _storage.read(key: _keyIpTimestamp);
    final now = DateTime.now().millisecondsSinceEpoch;

    if (cachedIp != null && tsStr != null) {
      final ts = int.tryParse(tsStr) ?? 0;
      final ageMs = now - ts;
      final cacheMs = _cacheMinutes * 60 * 1000;
      if (ageMs >= 0 && ageMs < cacheMs) {
        return cachedIp; // Cache vigente
      }
    }

    // 2) Consultar fuentes (con reintentos)
    final candidates = <Future<String?>>[
      _fetchIpFromIpify(),
      _fetchIpFromIfconfig(), // fallback
    ];

    String? ip;
    for (var i = 0; i < _maxTries && i < candidates.length; i++) {
      ip = await candidates[i];
      if (ip != null && ip.isNotEmpty) break;
    }

    // 3) Guardar en cache si éxito
    if (ip != null && ip.isNotEmpty) {
      await _storage.write(key: _keyIpPub, value: ip);
      await _storage.write(key: _keyIpTimestamp, value: now.toString());
      return ip;
    }

    // 4) Si falla, retorno null (caller decidirá fallback)
    return null;
  }

  static Future<String?> _fetchIpFromIpify() async {
    try {
      final uri = Uri.parse('https://api.ipify.org?format=json');
      final res = await http.get(uri).timeout(_timeout);
      if (res.statusCode == 200) {
        final j = jsonDecode(res.body) as Map<String, dynamic>;
        final ip = j['ip']?.toString();
        return _isValidIpv4(ip) ? ip : null;
      }
    } catch (_) {}
    return null;
  }

  static Future<String?> _fetchIpFromIfconfig() async {
    try {
      final uri = Uri.parse('https://ifconfig.co/json');
      final res = await http.get(uri).timeout(_timeout);
      if (res.statusCode == 200) {
        final j = jsonDecode(res.body) as Map<String, dynamic>;
        final ip = j['ip']?.toString();
        return _isValidIpv4(ip) ? ip : null;
      }
    } catch (_) {}
    return null;
  }

  static bool _isValidIpv4(String? ip) {
    if (ip == null) return false;
    final parts = ip.split('.');
    if (parts.length != 4) return false;
    for (final p in parts) {
      final n = int.tryParse(p);
      if (n == null || n < 0 || n > 255) return false;
    }
    return true;
  }

  /// Permite forzar limpieza del cache (ej., al desloguearse).
  static Future<void> clearCache() async {
    await _storage.delete(key: _keyIpPub);
    await _storage.delete(key: _keyIpTimestamp);
  }
}
