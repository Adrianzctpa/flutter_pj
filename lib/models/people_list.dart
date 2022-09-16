import 'package:flutter/material.dart';
import 'people.dart';

class PeopleList with ChangeNotifier {
  List<People> _ppl = [];
  Getter _getter = Getter(next: null, previous: null, count: 0, results: []);
  int _id = 0;

  void setInfo(List<People> people, Getter info, [int? id]) {
    _ppl = people;
    _getter = info;
    id != null ? _id = id : _id = _id;
    notifyListeners();
  }

  List<People> get people => [..._ppl];
  Getter get getter => _getter;
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

  // Pages
  static const int minItemsForPage = 10;
  String filter = '';
  int nextPage = 2;
  int previousPage = 0;

  int get pages {
    if (_getter.count > minItemsForPage) {
      return (_getter.count / minItemsForPage).ceil();
    } else {
      return 0;
    }
  }

  bool get shouldNextPageBeEnabled {
    final int currentPage = nextPage - 1;
    final bool canIncrement = (currentPage + 1) <= pages;
    final bool canIncrementPrevious = (previousPage + 1) < pages;

    if (canIncrement && canIncrementPrevious) {
      return true;
    } 

    return false;
  }

  bool get shouldPreviousPageBeEnabled {
    final bool canDecrement = (previousPage - 1) >= 0;

    if (canDecrement) {
      return true;
    } 

    return false;
  }

  void setPages(int prev, int next) {
    previousPage = prev;
    nextPage = next;
    notifyListeners();
  }

  void setFilter(String newFilter) {
    filter = newFilter;
    notifyListeners();
  }

  void handlePageLoad(String? prev, String? next) {
    if (next == null) {
      nextPage = getter.count + 1;
    }

    if (prev != null) {
      final uri = Uri.parse(prev);
      final int id = int.parse(uri.queryParameters['page'] as String) + 1;
      
      if ((id + 1) <= pages && pages != 0)  {
        setPages(id - 1, id + 1);
      }
    }
  }
}