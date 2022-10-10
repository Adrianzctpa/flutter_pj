import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'films.dart';
import 'people.dart';

class PeopleList with ChangeNotifier {
  // Environment variables will be defined in dart-define as it is more secure
  static const fbUrl = String.fromEnvironment('FB_URL');
  List<People> _ppl = [];
  Getter _getter = Getter(next: null, previous: null, count: 0, results: []);
  int _id = 0;
  final List<Map<String, Object>> _cachedPeople = [];

  final String _token;
  final String _uid;
  PeopleList(this._token, this._uid);

  void setInfo(List<People> people, Getter info, [int? id]) {
    _ppl = people;
    _getter = info;
    id != null ? _id = id : _id = _id;
    notifyListeners();
  }

  bool isCached(People person) {
    final cacheList = [];
    final getFuture = http.get(Uri.parse('$fbUrl/cached.json?auth=$_token'));
      getFuture.then((resp) {
        if (resp.statusCode == 200) {
          if (resp.body == 'null') return;
          final data = Map<String, dynamic>.from(jsonDecode(resp.body));

          data.forEach((key, value) {
            final pers = People.fromJson(value['info']);
            cacheList.add(pers.name);
          });
        }
      }
    );

    return cacheList.contains(person.name);
  }

  void setCachedPeople() { 
    final getFuture = http.get(Uri.parse('$fbUrl/cached.json?auth=$_token'));
      getFuture.then((resp) {
        if (resp.statusCode == 200) {
          if (resp.body == 'null') return;
          final data = Map<String, dynamic>.from(jsonDecode(resp.body));

          data.forEach((key, value) {
            final pers = People.fromJson(value['info']);
            final List films = value['films'].toList();
            final List<Films> filmsList = [];
            pers.setKey(key);
            for (var i = 0; i < films.length; i++) {
              filmsList.add(Films.fromJson(value['films'][i]));
            }
            _cachedPeople.add({'person': pers, 'films': filmsList});
          });
          notifyListeners();
        }
      }
    );
  }

  List<Map<String,Object>> postAndCache(People person, List<Films> films) {
     if (!isCached(person)) {
      http.post(
        Uri.parse('$fbUrl/cached.json?auth=$_token'),
        body: jsonEncode({
          'name': person.name,
          'films': films,
          'info': person
        })
      );
      
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

  void getAndRemoveFavorite(People person) {
    final delFuture = http.get(
      Uri.parse(
        '$fbUrl/userFavorites/$_uid.json?auth=$_token&orderBy="name"&equalTo="${person.name}"'
      )
    );

    delFuture.then((resp) {
      json.decode(resp.body).forEach((key, value) {
        http.delete(
          Uri.parse(
            '$fbUrl/userFavorites/$_uid/$key.json?auth=$_token'
          )
        );
        _favoritePeople.remove(person);
        notifyListeners();
      });
    });
  }

  void postFavorite(People person) {
    final postFuture = http.post(
      Uri.parse('$fbUrl/userFavorites/$_uid.json?auth=$_token'),
      body: jsonEncode({
        'name': person.name,
        'info': person
      })
    );

    postFuture.then((resp) {
      if (resp.statusCode == 200) {
        final key = json.decode(resp.body)['name'];
        person.setKey(key);
        _favoritePeople.add(person);
        notifyListeners();
      }
    });
  }

  void toggleFavorite(People person) {
    if (!_favoritePeople.contains(person)) {
      postFavorite(person);
      return;
    } 

    if (person.key == null) {
      getAndRemoveFavorite(person);
      return;
    }

    http.delete(
      Uri.parse(
        '$fbUrl/userFavorites/$_uid/${person.key}.json?auth=$_token'
      )
    );
    _favoritePeople.remove(person);
    notifyListeners();
  }

  void setFavorites() {
    final getFuture = http.get(Uri.parse('$fbUrl/userFavorites/$_uid.json?auth=$_token'));
    getFuture.then((resp) {  
      if (jsonDecode(resp.body) == null) return;  
      final jsonData = Map<String, dynamic>.from(jsonDecode(resp.body));
      jsonData.forEach((key, value) {
        final Map<String, dynamic> info = value['info'];
        final person = People.fromJson(info);
        person.setKey(key);

        _favoritePeople.add(person);
      });
      notifyListeners();
    });
  }

  bool isFavorite(People person) {
    for (var i = 0; i < _favoritePeople.length; i++) {
      if (_favoritePeople[i].name == person.name) {
        return true;
      }
    }
    return false;
  }

  List<People> get favPeople => _favoritePeople;
}