
// lib/modules/login/service/http_auth.dart
import '../../../config.dart';
import 'session_storage.dart';
import 'package:OTP_v1/utils/public_ip_service.dart';

class HttpAuth {
  static Future<Map<String, String>> authHeaders({
    Map<String, String> extra = const {},
  }) async {
    final token = await SessionStorage.getToken();

    // 1) Obtener IP pública (IPv4) con cache y reintentos
    //final ipPublica = await PublicIpService.getPublicIpV4();

    final ipPublica = AppConfig.shouldFetchPublicIp
  ? await PublicIpService.getPublicIpV4()
  : null;

    // 2) Fallbacks:
    // - Si no hay IP pública disponible, usar la default de AppConfig (p.ej., 127.0.0.1)
    final ipCliente = ipPublica ?? AppConfig.ipCliente;

    final defaults = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',

      // Cabeceras de negocio requeridas:
      'codigoaplicacion': AppConfig.codigoAplicacion,   // 121
      'codigocanal': AppConfig.codigoCanal,             // 1
      'empresaaplicacion': AppConfig.empresaAplicacion, // Interno
      'ipcliente': ipCliente,                           // <-- IP pública
      'modalidad': AppConfig.modalidad,                 // generar
    };

    if (token != null && token.isNotEmpty) {
      defaults['Authorization'] = 'Bearer $token';
    }

    return {
      ...defaults,
      ...extra,
    };
  }
}
