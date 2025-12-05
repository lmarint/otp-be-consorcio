
// lib/modules/login/view/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controller/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = LoginController()..addListener(_onUpdate);
  }

  @override
  void dispose() {
    controller.removeListener(_onUpdate);
    controller.dispose();
    super.dispose();
  }

  void _onUpdate() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: null, // ✅ sin texto arriba
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Image.asset(
            'assets/consorcio_logo.png', // PNG pequeño en AppBar
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
                  // Logo SVG central debajo del encabezado
                  SvgPicture.asset(
                    'assets/LogoConsorcio.svg',
                    height: 60,
                  ),
                  const SizedBox(height: 24),

                  // Campo RUT (sin ícono)
                  TextField(
                    controller: controller.rutCtrl,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'RUT',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Campo Clave (sin ícono)
                  TextField(
                    controller: controller.passCtrl,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Clave',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botón Ingresar (sin icono)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.loading
                          ? null
                          : () async {
                              final ok = await controller.submit();
                              if (!mounted) return;
                              if (ok) {
                                Navigator.pushReplacementNamed(context, '/otp');
                              } else {
                                final msg = controller.errorMessage ?? 'Error al autenticar';
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(msg), backgroundColor: Colors.red),
                                );
                              }
                            },
                      child: controller.loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Ingresar'),
                    ),
                  ),

                  const SizedBox(height: 16),
                  if (controller.env != 'prod') ...[
                    Divider(color: Colors.grey.shade300),
                    Text(
                      'ENV=${controller.env} | BASE=${controller.apiBase}',
                      style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
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
