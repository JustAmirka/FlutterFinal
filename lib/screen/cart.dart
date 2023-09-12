import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/model/goods.dart';
import 'package:login/screen/Home.dart';
import 'package:login/screen/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/cart.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];
  bool isLoading = false;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

// ...

  void checkout() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Checkout Confirmation'),
        content: Text('Are you sure you want to proceed with the checkout?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Checkout'),
            onPressed: () {
              Navigator.of(ctx).pop();
              performCheckout();
            },
          ),
        ],
      ),
    );
  }

  void performCheckout() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        // Handle authentication error
        return;
      }

      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/checkout'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        var totalPrice = responseData['totalPrice'];

        // Clear the cart items after successful checkout
        setState(() {
          cartItems = [];
          totalPrice = 0;
        });

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Checkout Successful'),
            content: Text(""),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  // Navigate to a success screen or perform any desired actions
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      } else {
        final errorMessage = jsonDecode(response.body)['error'];
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Checkout Failed'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
    } catch (error) {
      print('Failed to perform checkout: $error');
    }
  }

  Future<void> fetchCartItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/getCart'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final cartData = jsonDecode(response.body)['cart'];

        final List<CartItem> fetchedCartItems = [];
        double total = 0.0; // Initialize total price

        for (var item in cartData) {
          final goodsId = item['goods']['_id'];
          print('goodsId: $goodsId');

          final double price = item['goods']['price'].toDouble();
          final int quantity = item['quantity'];

          fetchedCartItems.add(
            CartItem(
              goodsId: goodsId,
              name: item['goods']['name'],
              price: price,
              quantity: quantity,
              image: item['goods']['image'],
              isChosen: false, // Initialize isChosen to false
            ),
          );

          total += price * quantity; // Add the price of each item to the total
        }

        setState(() {
          cartItems = fetchedCartItems;
        });
      } else {
        // Handle error response
        print('Failed to fetch cart items: ${response.statusCode}');
        final errorMessage = jsonDecode(response.body)['error'];
        print('Error message: $errorMessage');
      }
    } catch (error) {
      // Handle error
      print('Failed to fetch cart items: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> removeCartItem(String goodsId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        // Handle authentication error
        return;
      }

      final Map<String, dynamic> data = {
        'goodsId': goodsId,
      };
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/removeFromCart'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Fetch the updated cart items
        await fetchCartItems();

        // Handle success
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData['message']);
      } else if (response.statusCode == 404) {
        final Map<String, dynamic> errorData = json.decode(response.body);
        print(errorData['error']);

        // Handle item not found error
        // For example, you can display a message to the user
        // and remove the item from the cart locally
        setState(() {
          cartItems.removeWhere((item) => item.goodsId == goodsId);
        });
      } else {
        // Handle other error responses
        final Map<String, dynamic> errorData = json.decode(response.body);
        print(errorData['error']);
      }
    } catch (error) {
      // Handle exception
      print('Failed to remove cart item: $error');
    }
  }

  Future<void> updateQuantity(String goodsId, int quantity) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        // Handle authentication error
        return;
      }

      final Map<String, dynamic> data = {
        'goodsId': goodsId,
        'quantity': quantity.toString(), // Convert quantity to String
      };

      print('Updating quantity for goodsId: $goodsId'); // Print the goodsId

      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/updateCart'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Fetch the updated cart items
        await fetchCartItems();

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
      print('Failed to update quantity: $error');
    }
  }

  double calculateTotalPrice() {
    return cartItems.fold(0.0, (total, item) {
      if (item.isChosen) {
        total += item.price * item.quantity;
      }
      return total;
    });
  }


  void toggleItemChosen(int index) {
    setState(() {
      cartItems[index].isChosen = !cartItems[index].isChosen; // Negate the value
      totalPrice = calculateTotalPrice();
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : cartItems.isEmpty
          ? Center(
        child: Text('Cart is empty'),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, index) => ListTile(
                title: Text(cartItems[index].name),
                subtitle: Text(
                  'Price: \$${cartItems[index].price}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (cartItems[index].quantity > 1) {
                          updateQuantity(
                            cartItems[index].goodsId,
                            cartItems[index].quantity - 1,
                          );
                        }
                      },
                    ),
                    Text('${cartItems[index].quantity}'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        updateQuantity(
                          cartItems[index].goodsId,
                          cartItems[index].quantity + 1,
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        removeCartItem(cartItems[index].goodsId);
                      },
                    ),
                    IconButton(
                      icon: cartItems[index].isChosen == true
                          ? Icon(Icons.check_box)
                          : Icon(Icons.check_box_outline_blank),
                      onPressed: () {
                        toggleItemChosen(index);
                      },
                    ),

                  ],
                ),
                leading: Container(
                  width: 50,
                  height: 50,
                  child: Image.network(
                    cartItems[index].image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: checkout,
            child: Text('Checkout'),
          ),
        ],
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
/*
        Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
*/
      } else if (index == 2) {
        // Navigate to ProfilePage
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
      }
    });
  }


  int _selectedIndex = 0;


// ...
}