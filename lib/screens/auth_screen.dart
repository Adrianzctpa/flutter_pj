import 'package:flutter/material.dart';
import '../components/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1]
              )
            )
          ),
          Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 0),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 70),
                      transform: Matrix4.rotationZ(-8 * 3.1415927 / 180)..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.secondary,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2)
                          )
                        ]
                      ),
                      child: const Text(
                        'SWAPI Info',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.normal
                        )
                      )
                    ),
                    const AuthForm()
                  ],
                )
              ),
            ),
          )
        ]
      )
    );
  }
}