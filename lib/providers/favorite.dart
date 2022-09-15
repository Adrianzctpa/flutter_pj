import 'package:flutter/material.dart';
import '../models/people.dart';

class FavoriteState {
  final List<People> _favoritePeople = [];

  void toggleFavorite(People person) {
    _favoritePeople.contains(person)
    ? _favoritePeople.remove(person)
    : _favoritePeople.add(person);
  }

  bool isFavorite(People person) {
    return _favoritePeople.contains(person);
  }

  List<People> get favPeople => _favoritePeople;

  bool diff(FavoriteState old) {
    return old._favoritePeople != _favoritePeople;
  }
}

class FavoriteProvider extends InheritedWidget {
  final FavoriteState state = FavoriteState();

  FavoriteProvider({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  static FavoriteProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FavoriteProvider>();
  }

  @override
  bool updateShouldNotify(covariant FavoriteProvider oldWidget) {
    return oldWidget.state.diff(state);
  }
}