
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config.dart';
import 'login_models.dart';
import 'http_auth.dart'; // <-- importa el helper de cabeceras

class LoginRepository {
  Uri get authEndpoint => Uri.parse(AppConfig.loginAuthEndpoint);

  Future<LoginResponseRaw> postAuth(LoginAuthRequest req) async {
    final headers = await HttpAuth.authHeaders(); // <-- cabeceras completas

    final res = await http
        .post(
          authEndpoint,
          headers: headers,
          body: jsonEncode(req.toJson()),
        )
        .timeout(const Duration(seconds: 20));

    Map<String, dynamic>? json;
    try {
      json = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {}
    return LoginResponseRaw(res.statusCode, res.body, json);
  }
}
