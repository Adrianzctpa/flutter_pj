import 'package:flutter/material.dart';
import 'films.dart';
import 'people.dart';

class PeopleList with ChangeNotifier {
  List<People> _ppl = [];
  Getter _getter = Getter(next: null, previous: null, count: 0, results: []);
  int _id = 0;
  final List<Map<String, Object>> _cachedPeople = [];

  void setInfo(List<People> people, Getter info, [int? id]) {
    _ppl = people;
    _getter = info;
    id != null ? _id = id : _id = _id;
    notifyListeners();
  }

  List<Map<String,Object>> setCachedPeople(People person, List<Films> films) {
    final cacheList = [];
    for (var i = 0; i < _cachedPeople.length; i++) {
      final mapPerson = _cachedPeople[i]['person'] as People;
      cacheList.add(mapPerson);  
    }

    if (!cacheList.contains(person.name) || cacheList.isEmpty) {
      _cachedPeople.add({'person': person, 'films': films});
      notifyListeners();
    }

    return _cachedPeople;
  }

  List<People> get people => [..._ppl];
  Getter get getter => _getter;
  List<Map<String, Object>> get cachedPeople => [..._cachedPeople];
  int get id => _id;

  // Favorites
  final List<People> _favoritePeople = [];

  void toggleFavorite(People person) {
    _favoritePeople.contains(person)
    ? _favoritePeople.remove(person)
    : _favoritePeople.add(person);
    notifyListeners();
  }

  bool isFavorite(People person) {
    return _favoritePeople.contains(person);
  }

  List<People> get favPeople => _favoritePeople;
}