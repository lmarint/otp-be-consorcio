
// lib/otp_view.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart' as crypto;

class OTPView extends StatefulWidget {
  const OTPView({super.key});
  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  static const int periodSeconds = 30;
  static const int digits = 6;
  static const crypto.Hash hashAlgorithm = crypto.sha256;

  final bool useBase32Secret = false;
  final String secretUtf8 = 'MiSecretoDePrueba123';        // <-- reemplazar por Secure Storage
  final String secretBase32 = 'JBSWY3DPEHPK3PXP';

  String currentCode = '------';
  int secondsLeft = periodSeconds;
  double progress = 1.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _refresh();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _refresh() {
    final nowSec = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final step = nowSec ~/ periodSeconds;
    final code = _generateTOTP(step: step, digits: digits, hash: hashAlgorithm, useBase32: useBase32Secret);
    final remainder = nowSec % periodSeconds;
    setState(() {
      currentCode = code;
      secondsLeft = periodSeconds - remainder;
      progress = secondsLeft / periodSeconds;
    });
  }

  void _tick() {
    final nowSec = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final remainder = nowSec % periodSeconds;
    final left = periodSeconds - remainder;
    if (left == periodSeconds) _refresh();
    setState(() {
      secondsLeft = left;
      progress = left / periodSeconds;
    });
  }

  String _generateTOTP({
    required int step,
    required int digits,
    required crypto.Hash hash,
    required bool useBase32,
  }) {
    final keyBytes = useBase32 ? base32Decode(secretBase32) : utf8.encode(secretUtf8);
    final msg = _int64ToBytesBigEndian(step);
    final hmac = crypto.Hmac(hash, keyBytes);
    final digest = hmac.convert(msg).bytes;
    final offset = digest.last & 0x0F;
    final slice = digest.sublist(offset, offset + 4);
    final codeInt = ((slice[0] & 0x7F) << 24) |
        ((slice[1] & 0xFF) << 16) |
        ((slice[2] & 0xFF) << 8) |
        (slice[3] & 0xFF);
    final mod = _pow10(digits);
    return (codeInt % mod).toString().padLeft(digits, '0');
  }

  List<int> _int64ToBytesBigEndian(int v) {
    final bytes = List<int>.filled(8, 0);
    for (int i = 7; i >= 0; i--) {
      bytes[i] = v & 0xFF; v >>= 8;
    }
    return bytes;
  }

  int _pow10(int n) {
    var r = 1; for (var i = 0; i < n; i++) r *= 10; return r;
  }

  List<int> base32Decode(String input) {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final cleaned = input.replaceAll('=', '').toUpperCase();
    var buffer = 0, bitsLeft = 0;
    final result = <int>[];
    for (final c in cleaned.split('')) {
      final val = alphabet.indexOf(c);
      if (val < 0) throw const FormatException('Carácter Base32 inválido');
      buffer = (buffer << 5) | val;
      bitsLeft += 5;
      if (bitsLeft >= 8) {
        bitsLeft -= 8;
        result.add((buffer >> bitsLeft) & 0xFF);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Código dinámico'),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Image.asset(
            'assets/consorcio_logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentCode,
                    style: theme.textTheme.displayMedium?.copyWith(
                      letterSpacing: 4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text('Expira en: $secondsLeft s',
                      style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[700])),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress > 0.5 ? cs.primary : cs.secondary,
                      ),
                    ),
                  ),
                  // ✅ Botones eliminados
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(height: 4, color: cs.secondary),
    );
  }
}