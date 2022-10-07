import 'dart:convert';
import 'dart:async';
import 'package:swapi_app/data/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:swapi_app/exceptions/auth_exception.dart';

class AuthProvider with ChangeNotifier {
  final _apiKey = dotenv.env['API_KEY'] ?? 'API_KEY is null';
  String? _token;
  String? _email;
  String? _refreshToken;
  String? _uid;
  DateTime? _expiresIn;
  Timer? _logoutTimer;

  bool get isAuthenticated {
    final isNotExpired = _expiresIn?.isAfter(DateTime.now()) ?? false;
    return _token != null && isNotExpired;
  }

  String? get token {
    return isAuthenticated 
    ? _token
    : null;
  } 

  String? get email {
    return isAuthenticated 
    ? _email
    : null;
  }

  String? get refreshToken {
    return isAuthenticated 
    ? _refreshToken
    : null;
  }

  String? get uid {
    return isAuthenticated 
    ? _uid
    : null;
  } 

  String get _signUpUrl {
    return 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_apiKey';
  }

  String get _loginUrl {
    return 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_apiKey';
  }

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(_loginUrl),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      })
    );

    final body = jsonDecode(response.body);
    
    if (body['error'] != null) {
      String err = body['error']['message'];

      if (err.length > 40) { 
        err = 'TOO_MANY_ATTEMPTS_TRY_LATER';
      }

      throw AuthException(err);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _refreshToken = body['refreshToken'];
      _uid = body['localId'];
      _expiresIn = DateTime.now().add(
        Duration(seconds: int.parse(body['expiresIn']))
      );

      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'refreshToken': _refreshToken,
        'uid': _uid,
        'expiresIn': _expiresIn!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    final response = await http.post(
      Uri.parse(_signUpUrl),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      })
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      final err = body['error']['message'];
      throw AuthException(err);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _refreshToken = body['refreshToken'];
      _uid = body['localId'];
      _expiresIn = DateTime.now().add(
        Duration(seconds: int.parse(body['expiresIn']))
      );

      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'refreshToken': _refreshToken,
        'uid': _uid,
        'expiresIn': _expiresIn!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
  }

  void logout() {
    _token = null;
    _email = null;
    _refreshToken = null;
    _uid = null;
    _expiresIn = null;
    _clearLogoutTimer();
    Store.remove('userData').then((_) => notifyListeners());
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  Future<void> autoLogin() async {
    if (isAuthenticated) return;

    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;

    final expiresIn = DateTime.parse(userData['expiresIn']);
    if (expiresIn.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _refreshToken = userData['refreshToken'];
    _uid = userData['uid'];
    _expiresIn = expiresIn;

    _autoLogout();
  }

  void _autoLogout() {
    _clearLogoutTimer();

    final timeToLogout = _expiresIn?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout ?? 0), logout);
  }
}