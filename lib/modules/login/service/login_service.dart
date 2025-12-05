
// lib/modules/login/service/login_service.dart
import 'crypto_service.dart';
import 'login_models.dart';
import 'login_repository.dart';

class LoginService {
  final LoginRepository _repo = LoginRepository();
  final CryptoService _crypto = CryptoService();

  // TODO: Cambia por la clave real provista por el backend (16 bytes exactamente).
  // Puedes inyectarla vía --dart-define o config.dart si corresponde.
  //final List<int> _aesKey = utf8.encode('1234567890ABCDEF'); // 16 bytes de ejemplo

  
Future<TokenDto> autenticar({required String rut, required String password}) async {
    final contrasenaB64 = _crypto.encryptAes128CbcPkcs7ToBase64(
      plaintext: password,
      // key/iv salen de AppConfig (dart-define) o defaults del AngularJS
    );

    final req = LoginAuthRequest(
      rut: rut,
      contrasena: contrasenaB64,
      estadoClave: '1',
    );


    final raw = await _repo.postAuth(req);
    if (raw.json == null) {
      throw Exception('Respuesta no válida (no es JSON). HTTP: ${raw.statusCode}');
    }
    final parsed = LoginAuthResponseParsed.fromJson(raw.json!);

    if (!parsed.estadoHttp.isOk) {
      throw Exception('HTTP ${parsed.estadoHttp.codigo}: ${parsed.estadoHttp.descripcion}');
    }
    if (!parsed.codigosOperacion.operacionOk) {
      throw Exception('Operación fallida: ${parsed.codigosOperacion.mensaje} (código ${parsed.codigosOperacion.codigoRespuesta})');
    }
    if (!parsed.cliente.dtoAutenticacion.credencialesValidas) {
      throw Exception('Credenciales inválidas: ${parsed.cliente.dtoAutenticacion.descripcion}');
    }

    final tokenDto = parsed.cliente.dtoAutenticacion.dtoAutorizacion.dtoToken;
    if (!tokenDto.hasToken) {
      throw Exception('Token no recibido.');
    }
    return tokenDto;
  }
}
