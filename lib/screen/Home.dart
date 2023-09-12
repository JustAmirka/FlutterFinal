import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:collection/collection.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:login/main.dart';
import 'package:login/model/cart.dart';
import 'package:login/model/goods.dart';
import 'package:login/model/user.dart';
import 'package:login/providers/login_provider.dart';
import 'package:login/screen/cart.dart';
import 'package:login/screen/profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? phone;

  HomePage({
    this.email,
    this.firstName,
    this.lastName,
    this.address,
    this.phone,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Good> goodsList = [];
  List<CartItem> cart = [];
  // Declare and initialize the cartItems list

  final List<String> images = [
    'https://target.scene7.com/is/image/Target/shoes-211215-1639605768116',
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=5',
    'https://picsum.photos/250?image=12',
    'https://picsum.photos/250?image=15',
    'https://picsum.photos/250?image=17',
  ];
  int _selectedIndex = 0;
  User? _loggedInUser;

  void toggleTheme() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    themeNotifier.toggleTheme();
  }
  void openItemDescription(Good item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Text('Price: \$${item.price.toStringAsFixed(2)}').tr(),
              SizedBox(height: 8.0),
              Text('Description: ${item.description}').tr(),
              SizedBox(height: 8.0),
              // Add additional fields as needed
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  Future<void> addItemToCart(String goodsId, int quantity) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        // Handle authentication error
        return;
      }

      final Map<String, dynamic> data = {
        'goodsId': goodsId,
        'quantity': quantity,
      };

      final http.Response response = await http.post(
        Uri.parse('http://10.0.2.2:3000/addToCart'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Handle success
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData['message']);
      } else {
        // Handle error
        final Map<String, dynamic> errorData = json.decode(response.body);
        print(errorData['error']);
      }
    } catch (error) {
      // Handle exception
      print('Failed to add goods to cart: $error');
    }
  }



  CartItem? removeItemFromCart(Good item) {
    final cartItem = cart.firstWhereOrNull((element) => element.goodsId == item.id);
    if (cartItem != null) {
      cart.remove(cartItem);
    }
    return cartItem;
  }





  void _navigateToProfilePage(BuildContext context) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    if (loginProvider.isGuestMode) {
      await Navigator.pushReplacementNamed(context, '/login');
      loginProvider.setGuestMode(false); // Logout of guest mode when returning from ProfilePage
    } else {
      final isLoggedIn = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ),
      );
      if (isLoggedIn != null && !isLoggedIn) {
        loginProvider.setGuestMode(false); // Set guest mode after logout
      }
    }
  }

  Future<List<Good>> fetchGoods() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/goods'));
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print('Response Data: $responseData');

        if (responseData != null && responseData['goods'] != null) {
          final List<dynamic> goodsData = responseData['goods'];
          goodsList = goodsData.map((data) => Good.fromJson(data)).toList(); // Set the fetched goods to goodsList
          return goodsList;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to fetch goods');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Error occurred while fetching data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('WonderKidz'),
            actions: [
              IconButton(
                icon: const Icon(Icons.brightness_4), // Icon to represent theme change
                onPressed: () {
                  toggleTheme();
                },
              )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: FutureBuilder<List<Good>>(
                  future: fetchGoods(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error occurred while fetching data: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final goods = snapshot.data!;
                      return ListView.builder(
                        itemCount: goods.length,
                        itemBuilder: (context, index) {
                          final good = goods[index];
                          return GestureDetector(
                            onTap: () {
                              openItemDescription(good);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      image: DecorationImage(
                                        image: NetworkImage(good.image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          good.name,
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ).tr(),
                                        const SizedBox(height: 8.0),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '\$${good.price.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ).tr(),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Theme.of(context).primaryColor, // Use primary color
                                                onPrimary: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                ),
                                              ),
                                              child: const Text('Add to cart').tr(),
                                              onPressed: () {
                                                addItemToCart(good.id, 1); // Pass the good.id instead of goodsId
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('No data available'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: getNavbar(context),
        );
      },
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
/*
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
*/

      } else if (index == 1) {
        // Navigate to CartPage
        Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
      } else if (index == 2) {
        // Navigate to ProfilePage
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
      }
    });
  }

}

