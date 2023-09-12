import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationProvider with ChangeNotifier {
  String? _email;
  String? _firstName;
  String? _lastName;
  String? _address;
  String? _phone;
  bool _isLoading = false; // Added _isLoading variable

  String? get email => _email;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get address => _address;
  String? get phone => _phone;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setFirstName(String firstName) {
    _firstName = firstName;
    notifyListeners();
  }

  void setLastName(String lastName) {
    _lastName = lastName;
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  void setPhone(String phone) { // Changed from 'set setPhone'
    _phone = phone;
    notifyListeners();
  }

  bool get isLoading => _isLoading; // Added getter for _isLoading

  Future<void> register({
    required BuildContext context,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String address,
    required String phone,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/register'),
        body: jsonEncode({
          'email': email,
          'password': password,
          'firstname': firstName,
          'lastname': lastName,
          'address': address,
          'phone': phone,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        // Registration successful
        _email = email; // Use private variable instead of setter
        _firstName = firstName; // Use private variable instead of setter
        _lastName = lastName; // Use private variable instead of setter
        _address = address; // Use private variable instead of setter
        _phone = phone; // Use private variable instead of setter

        Navigator.pushReplacementNamed(context, '/login'); // Navigate to the login page
      } else {
        // Registration failed
        print('Registration failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle registration error
      print('Registration failed: $e');
    }

    _isLoading = false;
    notifyListeners();
  }


}
