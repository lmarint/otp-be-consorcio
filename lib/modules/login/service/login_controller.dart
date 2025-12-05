
// lib/modules/login/controller/login_controller.dart
import 'package:flutter/material.dart';
import '../../../config.dart';
import '../service/login_service.dart';
import '../service/login_models.dart';

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
        rut: rutCtrl.text.trim(),       // confirma si requiere DV o sólo números
        password: passCtrl.text,
      );
      tokenDto = token;
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
