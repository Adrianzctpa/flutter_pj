import 'package:flutter/material.dart';
import 'models/people.dart';
import 'screens/people_screen.dart';
import 'screens/details_screen.dart';
import 'screens/tabs_screen.dart';
import 'utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<People> _favoritePeople = [];

  void _toggleFavorite(People person) {
    setState(() {
      _favoritePeople.contains(person)
      ? _favoritePeople.remove(person)
      : _favoritePeople.add(person);
    });
  }

  bool _isFavorite(People person) {
    return _favoritePeople.contains(person);
  }

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
            color: Colors.black
          )
        )
      ),
      routes: {
        AppRoutes.homePage: (ctx) => TabsScreen(favoritePeople: _favoritePeople),
        AppRoutes.peoplePage: (ctx) => const PeopleScreen(),
        AppRoutes.personDetails: (ctx) => DetailsScreen(onToggleFavorite: _toggleFavorite, isFavorite: _isFavorite),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => TabsScreen(favoritePeople: _favoritePeople),
        );
      },
    );
  }
}