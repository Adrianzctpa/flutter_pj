import 'package:flutter/material.dart';
import 'screens/people_screen.dart';
import 'screens/details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWAPI Info',
      theme: ThemeData(
        primaryColor: Colors.black, 
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.amber,
          onSecondary: Colors.yellow,
          tertiary: Colors.black54
        ),
        canvasColor: Colors.black,
        fontFamily: 'Raleway',
        textTheme: ThemeData.dark().textTheme.copyWith(
          titleMedium: const TextStyle(
            fontSize: 20,
            fontFamily: 'RobotoCondensed',
          )
        )
      ),
      routes: {
        '/': (ctx) => const PeopleScreen(),
        '/person-details': (ctx) => const DetailsScreen(),
      },
    );
  }
}