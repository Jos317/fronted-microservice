import 'package:flutter/material.dart';
import 'package:salobe_app/pages/Home/home_page.dart';
import 'package:salobe_app/pages/System/loading_page.dart';
import 'package:salobe_app/pages/System/login_page.dart';
import 'package:salobe_app/pages/System/register_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'home': ( _ ) => const HomePage(),
  // 'productos': (_) => ProductsPage(),
  // 'usuarios': ( _ ) => UsuariosPage(),
  'loading': ( _ ) => const LoadingPage(),
  'login': ( _ ) => const LoginPage(),
  'register': ( _ ) => RegisterPage(),
};