import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  static const String apiKey = 'AIzaSyCgFcwhhVmvsiUOZ0ouqOq7nQ8dmt5TRtw';

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  String? get userId {
    if (_userId != null) {
      return _userId;
    } else {
      return null;
    }
  }

  Future<void> signUp(String email, String password) async {
    const urlSegment = 'accounts:signUp';
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/$urlSegment?key=$apiKey');

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    const urlSegment = 'accounts:signInWithPassword';
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/$urlSegment?key=$apiKey');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
    } catch (error) {
      throw error;
    }
  }
}
