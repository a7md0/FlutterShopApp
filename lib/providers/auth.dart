import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;

  String _userId;

  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }

    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(
      email,
      password,
      'signUp',
    );
  }

  Future<void> login(String email, String password) async {
    return _authenticate(
      email,
      password,
      'signInWithPassword',
    );
  }

  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyA-sENJkobvrRQjmgrSEnqAmzPKbcL8Z4c';
    final data = json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });

    final response = await http.post(url, body: data);
    final body = json.decode(response.body);

    if (body['error'] != null) {
      throw HttpException(body['error']['message']);
    }

    _token = body['idToken'];
    _expiryDate = DateTime.now().add(Duration(
      seconds: int.parse(body['expiresIn']),
    ));
    _userId = body['localId'];

    _autoLogout();

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate.toIso8601String(),
    });
    prefs.setString('userData', userData);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final userData = json.decode(prefs.getString('userData'));
    final expiryDate = DateTime.parse(userData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = userData['token'];
    _expiryDate = expiryDate;
    _userId = userData['userId'];

    notifyListeners();
    _autoLogout();

    return true;
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;

    SharedPreferences.getInstance().then((prefs) => prefs.remove('userData'));

    if (_authTimer != null) {
      _authTimer.cancel();
    }

    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
      Duration(
        seconds: timeToExpiry,
      ),
      logout,
    );
  }
}
