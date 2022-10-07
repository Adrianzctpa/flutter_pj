import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth_provider.dart';
import 'tabs_screen.dart';
import 'auth_screen.dart';

class ScreenSwapper extends StatelessWidget {
  const ScreenSwapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of(context);
    return FutureBuilder(
      future: auth.autoLogin(),
      builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : auth.isAuthenticated
          ? const TabsScreen()
          : const AuthScreen(),
    );
  }
}