import 'package:flutter/material.dart';
import 'people_list.dart';
import 'people.dart';

class PagesProvider with ChangeNotifier {
  PeopleList? provider;
  Getter get getter => provider!.getter;

  static const int minItemsForPage = 10;
  String filter = '';
  int nextPage = 2;
  int previousPage = 0;
  bool _isDisabled = false;

  void update(PeopleList newProv) {
    provider = newProv;
  }

  bool get isDisabled => _isDisabled;
  
  void setDisableState(bool state) {
    _isDisabled = state;
    notifyListeners();
  }

  int get pages {
    if (getter.count > minItemsForPage) {
      return (getter.count / minItemsForPage).ceil();
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