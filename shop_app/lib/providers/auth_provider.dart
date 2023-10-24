import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(
          DateTime.now(),
        ) &&
        _userId != null) {
      return _userId!;
    }
    return null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(
          DateTime.now(),
        ) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  final api_key = 'AIzaSyBJUxT2h3okFanL5KLR8LoKXD-Fy4qws-I';
  Future<void> authUser(
    String userEmail,
    String userPassword,
    String urlSegment,
  ) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$api_key');

    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': userEmail,
          'password': userPassword,
          'returnSecureToken': true,
        },
      ),
    );
    if (response.statusCode >= 400) {
      throw HttpException('An error occured sorry for the inconvinience :((');
    }

    final extractedResponse = json.decode(response.body);

    _token = extractedResponse['idToken'];
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(extractedResponse['expiresIn']),
      ),
    );

    _userId = extractedResponse['localId'];

    notifyListeners();
    autoLogOut();
    final prefs = await SharedPreferences.getInstance();

    final dataToSave = json.encode({
      'token': _token,
      'expiryDate': _expiryDate!.toIso8601String(),
      'userId': userId
    });
    prefs.setString('userData', dataToSave);
  }

  Future<void> registerUser(String userEmail, String userPassword) async {
    await authUser(userEmail, userPassword, 'signUp');
  }

  Future<void> signUserIn(String userEmail, String userPassword) async {
    await authUser(userEmail, userPassword, 'signInWithPassword');
  }

  void logOut() {
    _token = null;
    _expiryDate = null;
    _userId = null;
    notifyListeners();
  }

  void autoLogOut() {
    if (authTimer != null) {
      authTimer!.cancel();
    }

    authTimer = Timer(
      Duration(seconds: _expiryDate!.difference(DateTime.now()).inSeconds),
      () => logOut(),
    );
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

    var expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = userData['token'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogOut();
    return true;
  }
}
