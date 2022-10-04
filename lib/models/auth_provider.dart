import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../exceptions/auth_exception.dart';

class AuthProvider with ChangeNotifier {
  final _apiKey = dotenv.env['API_KEY'] ?? 'API_KEY is null';
  String? _token;
  String? _email;
  String? _refreshToken;
  String? _uid;
  DateTime? _expiresIn;

  bool get isAuthenticated {
    final isNotExpired = _expiresIn?.isAfter(DateTime.now()) ?? false;
    return _token != null && isNotExpired;
  }

  Map<String, String>? get info {
    return isAuthenticated ? {
      'token': _token!,
      'email': _email!,
      'refreshToken': _refreshToken!,
      'uid': _uid!,
    } : null;
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

    debugPrint(body['error']);

    if (body['error'] != null) {
      final err = body['error']['message'];
      throw AuthException(err);
    }
  }
}