import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salobe_app/helpers/show_alert.dart';
import 'package:salobe_app/services/System/auth_service.dart';
import 'package:salobe_app/widgets/boton_azul.dart';
import 'package:salobe_app/widgets/custom_input.dart';
import 'package:salobe_app/widgets/labels.dart';
import 'package:salobe_app/widgets/logo.dart';

class RegisterPage extends StatelessWidget {
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
                  titulo: 'Registro',
                ),
                _Form(),
                const Labels(
                  ruta: 'login',
                  footText: '¿Ya tienes cuenta?',
                  footText2: '¡Inicia sesión aquí!',
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
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(top: 38),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity_rounded,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
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
                  final registerOk = await authService.register(
                      nameCtrl.text.trim(),
                      emailCtrl.text.trim(),
                      passCtrl.text.trim());
                  if (registerOk == true) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(context, 'home');
                  } else {
                    // Mostrar alerta
                    // ignore: use_build_context_synchronously
                    mostrarAlerta(context, "Registro Incorrecto", registerOk);
                  }
                },
          )
        ],
      ),
    );
  }
}
