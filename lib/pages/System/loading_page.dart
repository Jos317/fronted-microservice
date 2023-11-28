import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salobe_app/pages/Home/home_page.dart';
import 'package:salobe_app/pages/System/login_page.dart';
import 'package:salobe_app/services/System/auth_service.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(
            child: Text('Espere...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context);
    final autenticado = await authService.isLoggedIn();
    if (autenticado) {
       // ignore: use_build_context_synchronously
       Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (
                _,
                __,
                ___,
              ) =>
                  const HomePage(),
              transitionDuration: const Duration(milliseconds: 0)));
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (
                _,
                __,
                ___,
              ) =>
                  const LoginPage(),
              transitionDuration: const Duration(milliseconds: 0)));
    }
  }
}
