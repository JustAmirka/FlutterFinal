import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:login/screen/cart.dart';
import 'package:login/screen/login.dart';
import 'package:provider/provider.dart';
import 'package:login/providers/register_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login/screen/Home.dart';

// ...

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _email = '';
  String _firstname = '';
  String _lastname = '';
  String _address = '';
  String _phone = '';

  @override
  void initState() {
    super.initState();
    fetchAccountData();
  }

  Future<void> fetchAccountData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token: $token'); // Add this line to print the token value

    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/getAccount'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final accountData = jsonDecode(response.body)['account'];
      setState(() {
        _email = accountData['email'];
        _firstname = accountData['firstname'];
        _lastname = accountData['lastname'];
        _address = accountData['address'];
        _phone = accountData['phone'];
      });
    } else {
      final errorMessage = jsonDecode(response.body)['error'];
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Error'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile').tr()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email').tr(),
              subtitle: Text(_email),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('First Name').tr(),
              subtitle: Text(_firstname),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Last Name').tr(),
              subtitle: Text(_lastname),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Address').tr(),
              subtitle: Text(_address),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone').tr(),
              subtitle: Text(_phone),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () => logout(context),
              child: Text('Logout').tr(),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: getNavbar(context),

    );
  }

  Widget getNavbar(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.hintColor;

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.transparent)),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          _buildNavItem(Icons.category, 'Home'.tr(), 0),
          _buildNavItem(Icons.shopping_cart, 'Cart'.tr(), 1),
          _buildNavItem(Icons.person, 'Profile'.tr(), 2 ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon,
      String label,
      int index,
      {Color? backgroundColor}
      ) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
      backgroundColor: backgroundColor ?? Colors.transparent,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        // Navigate to CataloguePage
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));

      } else if (index == 1) {
        // Navigate to CartPage
        Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
      } else if (index == 2) {
        // Navigate to ProfilePage
/*
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
*/
      }
    });
  }


  int _selectedIndex = 0;


// ...
}