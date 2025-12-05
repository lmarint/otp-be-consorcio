
// lib/modules/login/service/login_models.dart

/// REQUEST de Autenticación
class LoginAuthRequest {
  final String rut;         // confírmame formato exacto (sin DV y sin puntos)
  final String contrasena;  // Base64 del cifrado en cliente
  final String estadoClave; // "1"

  LoginAuthRequest({
    required this.rut,
    required this.contrasena,
    this.estadoClave = '1',
  });

  Map<String, dynamic> toJson() => {
        "dtoRequestSetParametros": {
          "dtoCredenciales": {
            "rut": rut,
            "contrasena": contrasena,
            "estadoClave": estadoClave,
          }
        }
      };
}

/// RESPONSE (fuerte y null-safe)
class EstadoHttp {
  final String codigo;
  final String mensaje;
  final String descripcion;
  EstadoHttp({required this.codigo, required this.mensaje, required this.descripcion});
  factory EstadoHttp.fromJson(Map<String, dynamic> j) => EstadoHttp(
        codigo: j['codigo']?.toString() ?? '',
        mensaje: j['mensaje']?.toString() ?? '',
        descripcion: j['descripcion']?.toString() ?? '',
      );
  bool get isOk => codigo == '200';
}

class CodigosOperacion {
  final String codigoRespuesta;
  final String mensaje;
  CodigosOperacion({required this.codigoRespuesta, required this.mensaje});
  factory CodigosOperacion.fromJson(Map<String, dynamic> j) => CodigosOperacion(
        codigoRespuesta: j['codigoRespuesta']?.toString() ?? '',
        mensaje: j['mensaje']?.toString() ?? '',
      );
  bool get operacionOk => codigoRespuesta == '0';
}

class TokenDto {
  final String requestId;
  final String token;
  final int expiracion; // minutos
  TokenDto({required this.requestId, required this.token, required this.expiracion});
  factory TokenDto.fromJson(Map<String, dynamic> j) => TokenDto(
        requestId: j['requestId']?.toString() ?? '',
        token: j['token']?.toString() ?? '',
        expiracion: j['expiracion'] is int ? j['expiracion'] : int.tryParse('${j['expiracion']}') ?? 0,
      );
  bool get hasToken => token.isNotEmpty;
}

class AutorizacionDto {
  final String rol;
  final String perfil;
  final TokenDto dtoToken;
  AutorizacionDto({required this.rol, required this.perfil, required this.dtoToken});
  factory AutorizacionDto.fromJson(Map<String, dynamic> j) => AutorizacionDto(
        rol: j['rol']?.toString() ?? '',
        perfil: j['perfil']?.toString() ?? '',
        dtoToken: TokenDto.fromJson(Map<String, dynamic>.from(j['dtoToken'] ?? {})),
      );
}

class AutenticacionDto {
  final int codigo;
  final String estado;
  final String descripcion;
  final AutorizacionDto dtoAutorizacion;
  AutenticacionDto({
    required this.codigo,
    required this.estado,
    required this.descripcion,
    required this.dtoAutorizacion,
  });
  factory AutenticacionDto.fromJson(Map<String, dynamic> j) => AutenticacionDto(
        codigo: j['codigo'] is int ? j['codigo'] : int.tryParse('${j['codigo']}') ?? 0,
        estado: j['estado']?.toString() ?? '',
        descripcion: j['descripcion']?.toString() ?? '',
        dtoAutorizacion: AutorizacionDto.fromJson(Map<String, dynamic>.from(j['dtoAutorizacion'] ?? {})),
      );
  bool get credencialesValidas => codigo == 1 && estado == 'CREDENCIALES_VALIDAS';
}

class ClienteDto {
  final String rut;
  final AutenticacionDto dtoAutenticacion;
  ClienteDto({required this.rut, required this.dtoAutenticacion});
  factory ClienteDto.fromJson(Map<String, dynamic> j) => ClienteDto(
        rut: j['rut']?.toString() ?? '',
        dtoAutenticacion: AutenticacionDto.fromJson(Map<String, dynamic>.from(j['dtoAutenticacion'] ?? {})),
      );
}

class LoginAuthResponseParsed {
  final EstadoHttp estadoHttp;
  final CodigosOperacion codigosOperacion;
  final ClienteDto cliente;
  LoginAuthResponseParsed({required this.estadoHttp, required this.codigosOperacion, required this.cliente});
  bool get isCompletelyOk =>
      estadoHttp.isOk &&
      codigosOperacion.operacionOk &&
      cliente.dtoAutenticacion.credencialesValidas &&
      cliente.dtoAutenticacion.dtoAutorizacion.dtoToken.hasToken;
  factory LoginAuthResponseParsed.fromJson(Map<String, dynamic> j) {
    final httpJson = Map<String, dynamic>.from(j['dtoResponseCodigosEstadoHttp'] ?? {});
    final setResultados = Map<String, dynamic>.from(j['dtoResponseSetResultados'] ?? {});
    final opJson = Map<String, dynamic>.from(setResultados['dtoResponseCodigosOperacion'] ?? {});
    final clienteJson = Map<String, dynamic>.from(setResultados['dtoCliente'] ?? {});
    return LoginAuthResponseParsed(
      estadoHttp: EstadoHttp.fromJson(httpJson),
      codigosOperacion: CodigosOperacion.fromJson(opJson),
      cliente: ClienteDto.fromJson(clienteJson),
    );
  }
}

/// Respuesta cruda del http
class LoginResponseRaw {
  final int statusCode;
  final String rawBody;
  final Map<String, dynamic>? json;
  LoginResponseRaw(this.statusCode, this.rawBody, this.json);
}
