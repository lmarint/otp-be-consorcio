
// lib/config.dart
import 'dart:convert';

class AppConfig {
  // Ambiente (dev/qa/prod)
  static const String env =
      String.fromEnvironment('ENV', defaultValue: 'dev');

  // Base URL (pasa por --dart-define=API_BASE=...)
  static const String apiBase =
      String.fromEnvironment('API_BASE', defaultValue: 'http://10.250.12.184:8080');

  /// Endpoint de autenticación (usuario + contraseña)
  static String get loginAuthEndpoint =>
      '$apiBase/BCNSWSR_BE_Login/BancaEmpresa/API/V1/Login/Cliente/Autenticacion';

  /// (Opcional) Endpoint de datos de usuario
  static String get loginDatosUsuarioEndpoint =>
      '$apiBase/BCNSWSR_BE_Login/BancaEmpresa/API/V1/RecuperarContrasena/DatosUsuario';

  /// Llave pública (PEM multilínea, via --dart-define)
  static const String publicKeyPem =
      String.fromEnvironment('PUBLIC_KEY_PEM', defaultValue: '');

  /// Llave pública en Base64 (alternativa)
  static const String publicKeyPemBase64 =
      String.fromEnvironment('PUBLIC_KEY_PEM_BASE64', defaultValue: '');

  
// Cabeceras de negocio (con defaults)
  static const String codigoAplicacion =
      String.fromEnvironment('CODIGO_APLICACION', defaultValue: '121');
  static const String codigoCanal =
      String.fromEnvironment('CODIGO_CANAL', defaultValue: '1');
  static const String empresaAplicacion =
      String.fromEnvironment('EMPRESA_APLICACION', defaultValue: 'Interno');
  static const String ipCliente =
      String.fromEnvironment('IP_CLIENTE', defaultValue: '127.0.0.1');
  static const String modalidad =
      String.fromEnvironment('MODALIDAD', defaultValue: 'generar');

  static const String aesKey = String.fromEnvironment('AES_KEY', defaultValue: 'KaNdRgUkXp2s5v8y');
  static const String aesIv  = String.fromEnvironment('AES_IV',  defaultValue: 'encryptionBcnsVe');

  static List<int> get aesKeyBytes => utf8.encode(aesKey); // 16 chars -> 16 bytes
  static List<int> get aesIvBytes  => utf8.encode(aesIv);

  
  static const String fetchPublicIp =
      String.fromEnvironment('FETCH_PUBLIC_IP', defaultValue: 'true');
  static bool get shouldFetchPublicIp => fetchPublicIp.toLowerCase() == 'true';



  /// Resuelve a PEM multilínea
  static String get publicKeyPemResolved {
    if (publicKeyPemBase64.isNotEmpty) {
      return utf8.decode(base64.decode(publicKeyPemBase64));
    }
    return publicKeyPem.replaceAll(r'\n', '\n');
  }
}
