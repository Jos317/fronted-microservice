import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salobe_app/services/System/auth_service.dart';
import 'package:salobe_app/widgets/alertas.dart';
import 'package:salobe_app/widgets/boton_azul.dart';
import 'package:salobe_app/widgets/custom_input.dart';
import 'package:salobe_app/widgets/labels.dart';
import 'package:salobe_app/widgets/logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Logo(
                  titulo: 'SaloBe app',
                ),
                _Form(),
                const Labels(
                  ruta: 'register',
                  footText: '¿No tienes cuenta?',
                  footText2: '¡Registrate aquí!',
                ),
                GestureDetector(
                  child: const Text(
                    'Términos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  ),
                  onTap: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock,
            placeholder: 'Password',
            textController: passCtrl,
            isPassword: true,
          ),
          BotonAzul(
            buttonText: 'Ingrese',
            onPressed: authService.autenticando
              ? null
              : () async {
                FocusScope.of(context).unfocus();
                final loginOk = await authService.login(
                  emailCtrl.text.trim(), passCtrl.text.trim());
                  if (loginOk) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(context, 'home');

                  } else {
                    // ignore: use_build_context_synchronously
                    mostrarAlerta(context, "Login Incorrecto", "Estas credenciales no corresponden a nuestros registros.");
                  }
              },
          )
        ],
      ),
    );
  }
}
