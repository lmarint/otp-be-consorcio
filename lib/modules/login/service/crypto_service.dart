
import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:OTP_v1/config.dart';

enum AesMode { ecb, cbc } // dejamos ecb por si alguna prueba lo requiere

class CryptoService {
  CryptoService();

  /// Cifra con AES-128 + CBC + PKCS7 y retorna Base64 (compatible con CryptoJS).
  String encryptAes128CbcPkcs7ToBase64({
    required String plaintext,
    Encoding codec = utf8, // CryptoJS usa UTF-8
    List<int>? keyBytes,
    List<int>? ivBytes,
  }) {
    final key = keyBytes ?? AppConfig.aesKeyBytes; // 16 bytes
    final iv  = ivBytes  ?? AppConfig.aesIvBytes;  // 16 bytes
    _assert16(key, 'key');
    _assert16(iv,  'iv');

    final input = Uint8List.fromList(codec.encode(plaintext));

    final cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESEngine()),
    );

    final params = PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(
      ParametersWithIV<KeyParameter>(
        KeyParameter(Uint8List.fromList(key)),
        Uint8List.fromList(iv),
      ),
      null,
    );

    cipher.init(true, params); // encrypt
    final out = cipher.process(input);
    return base64Encode(out);
  }

  /// Descifra Base64 con AES-128 + CBC + PKCS7 (compatible con CryptoJS).
  String decryptAes128CbcPkcs7FromBase64({
    required String base64Cipher,
    Encoding codec = utf8,
    List<int>? keyBytes,
    List<int>? ivBytes,
  }) {
    final key = keyBytes ?? AppConfig.aesKeyBytes;
    final iv  = ivBytes  ?? AppConfig.aesIvBytes;
    _assert16(key, 'key');
    _assert16(iv,  'iv');

    final cipherBytes = base64Decode(base64Cipher);

    final cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESEngine()),
    );

    final params = PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(
      ParametersWithIV<KeyParameter>(
        KeyParameter(Uint8List.fromList(key)),
        Uint8List.fromList(iv),
      ),
      null,
    );

    cipher.init(false, params); // decrypt
    final out = cipher.process(cipherBytes);
    return codec.decode(out);
  }

  // --- Helpers ---
  void _assert16(List<int> bytes, String name) {
    if (bytes.length != 16) {
      throw ArgumentError('$name debe ser exactamente 16 bytes (AES-128).');
    }
  }
}
