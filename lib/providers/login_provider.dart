import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/model/user.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  String? _email;
  String? _password;
  String? _errorMessage;
  bool _isGuestMode = false;

  String? get email => _email;
  String? get password => _password;
  String? get errorMessage => _errorMessage;
  bool get isGuestMode => _isGuestMode;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setGuestMode(bool value) {
    _isGuestMode = value;
    notifyListeners();
  }
  Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        // User is not logged in
        return null;
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        final user = User.fromJson(userData);
        return user;
      } else {
        // Error retrieving user data
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error
      print('Failed to fetch user data: $e');
      return null;
    }
  }

  Future<void> login(BuildContext context, String email, String password) async {
    if (_isGuestMode) {
      // Perform guest mode logic here
      // For example, you can skip authentication and directly navigate to the home screen
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Login successful
        final userData = jsonDecode(response.body);
        final token = userData['token'];
        final redirectTo = userData['redirectTo'];

        // Save the token in shared preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        print(token);

        _errorMessage = null;
        notifyListeners();

        // Redirect based on the received redirectTo value
        if (redirectTo == '/admin') {
          Navigator.pushReplacementNamed(context, '/admin');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // Login failed
        final errorMessage = 'Invalid credentials. Please try again.'.tr();
        _errorMessage = errorMessage;
        notifyListeners();
      }
    } catch (e) {
      // Handle login error
      final errorMessage = 'An error occurred during login. Please try again.'.tr();
      _errorMessage = errorMessage;
      notifyListeners();
    }
  }
}
