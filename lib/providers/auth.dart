import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;

  String _userId;

  Future<void> signup(String email, String password) async {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA-sENJkobvrRQjmgrSEnqAmzPKbcL8Z4c';
    final data = json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });

    final response = await http.post(url, body: data);
    print(json.decode(response.body));
  }
}
