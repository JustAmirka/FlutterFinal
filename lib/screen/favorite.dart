import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/model/favorite.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Favorite> favorites = [];

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  Future<void> getFavorites() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      // Make the API request to get favorite goods
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/getFavorite'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          favorites = List<Favorite>.from(jsonData['favorites'].map((favorite) => Favorite.fromJson(favorite)));
        });
      } else {
        // Handle API error
        print('Failed to get favorites: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or server error
      print('Failed to get favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Page'),
      ),
      body: favorites.isEmpty
          ? Center(
        child: Text('No favorite goods found.'),
      )
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final favorite = favorites[index];
          return ListTile(
            title: Text(favorite.goods.name),
            subtitle: Text(favorite.goods.description),
            // Add more fields as needed
          );
        },
      ),
    );
  }
}
