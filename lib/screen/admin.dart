import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/goods.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Good> goodsList = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchGoods();
  }

  Future<void> fetchGoods() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/goods'));
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print('Response Data: $responseData'); // Add this line for debugging

        if (responseData != null && responseData['goods'] != null) {
          final List<dynamic> goodsData = responseData['goods'];
          setState(() {
            goodsList = goodsData.map((data) => Good.fromJson(data)).toList();
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to fetch goods');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> createGoods() async {
    final String name = nameController.text;
    final double price = double.tryParse(priceController.text) ?? 0.0;
    final String description = descriptionController.text;
    final String category = categoryController.text;
    final int quantity = int.tryParse(quantityController.text) ?? 0;
    final String image = imageController.text;

    try {
      // Retrieve the token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/addGoods'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
        body: json.encode({
          'name': name,
          'price': price,
          'description': description,
          'category': category,
          'quantity': quantity,
          'image': image,
        }),
      );

      if (response.statusCode == 201) {
        nameController.clear();
        priceController.clear();
        descriptionController.clear();
        categoryController.clear();
        quantityController.clear();
        imageController.clear();
        fetchGoods();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login to create goods.');
      } else {
        throw Exception('Failed to create goods');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> updateGoods(String id) async {
    print(id);
    final String name = nameController.text;
    final double price = double.tryParse(priceController.text) ?? 0.0;
    final String description = descriptionController.text;
    final String category = categoryController.text;
    final int quantity = int.tryParse(quantityController.text) ?? 0;
    final String image = imageController.text;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      print('ID: $id');

      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/putGoods/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
        body: json.encode({
          'name': name,
          'price': price,
          'description': description,
          'category': category,
          'quantity': quantity,
          'image': image,
        }),
      );

      if (response.statusCode == 200) {
        nameController.clear();
        priceController.clear();
        descriptionController.clear();
        categoryController.clear();
        quantityController.clear();
        imageController.clear();

        fetchGoods();
      } else {
        final errorMessage = json.decode(response.body)['error'] ?? 'Failed to update goods';
        print('Error response: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> deleteGoods(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('ID: $id');

    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:3000/deleteGoods/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
      );
      if (response.statusCode == 200) {
        fetchGoods();
      } else {
        final errorMessage = json.decode(response.body)['error'] ?? 'Failed to delete goods';
        print('Error response: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('token'); // Remove the token from shared preferences
      // You can also clear other relevant data or perform additional logout tasks

      // Navigate to the login page or any other desired page
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
            ),
            ElevatedButton(
              onPressed: createGoods,
              child: Text('Create Goods'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Goods List',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: goodsList.length,
              itemBuilder: (context, index) {
                final goods = goodsList[index];
                return ListTile(
                  title: Text(goods.name),
                  subtitle: Text('Price: ${goods.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteGoods(goods.id),
                  ),
                  onTap: () {
                    nameController.clear();
                    priceController.clear();
                    descriptionController.clear();
                    categoryController.clear();
                    quantityController.clear();
                    imageController.clear();

                    nameController.text = goods.name;
                    priceController.text = goods.price.toString();
                    descriptionController.text = goods.description;
                    categoryController.text = goods.category;
                    quantityController.text = goods.quantity.toString();
                    imageController.text = goods.image;

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Update Goods'),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(labelText: 'Name'),
                                ),
                                TextField(
                                  controller: priceController,
                                  decoration: InputDecoration(labelText: 'Price'),
                                  keyboardType: TextInputType.number,
                                ),
                                TextField(
                                  controller: descriptionController,
                                  decoration: InputDecoration(labelText: 'Description'),
                                ),
                                TextField(
                                  controller: categoryController,
                                  decoration: InputDecoration(labelText: 'Category'),
                                ),
                                TextField(
                                  controller: quantityController,
                                  decoration: InputDecoration(labelText: 'Quantity'),
                                  keyboardType: TextInputType.number,
                                ),
                                TextField(
                                  controller: imageController,
                                  decoration: InputDecoration(labelText: 'Image URL'),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                updateGoods(goods.id); // Pass goods.id as a string
                                Navigator.pop(context); // Close the dialog
                              },
                              child: Text('Update'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            ElevatedButton(
              onPressed: logout, // Call the logout function
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
