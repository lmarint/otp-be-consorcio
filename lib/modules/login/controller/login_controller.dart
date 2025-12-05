
import 'package:flutter/material.dart';
import '../../../config.dart';
import '../service/login_service.dart';
import '../service/login_models.dart';
import '../service/session_storage.dart';

class LoginController extends ChangeNotifier {
  final rutCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final LoginService _service = LoginService();

  bool loading = false;
  String? errorMessage;
  TokenDto? tokenDto;

  String get env => AppConfig.env;
  String get apiBase => AppConfig.apiBase;

  Future<bool> submit() async {
    loading = true;
    errorMessage = null;
    tokenDto = null;
    notifyListeners();

    try {
      final token = await _service.autenticar(
        rut: rutCtrl.text.trim(),
        password: passCtrl.text,
      );
      tokenDto = token;

      // Guarda token en almacenamiento seguro
      await SessionStorage.saveToken(tokenDto!);

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    rutCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }
}
