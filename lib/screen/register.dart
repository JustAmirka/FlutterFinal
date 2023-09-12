import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login/providers/register_provider.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _register(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context, listen: false);
    final email = _emailController.text;
    final password = _passwordController.text;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final address = _addressController.text;
    final phone = _phoneController.text;

    provider.register(
      context: context, // Pass the BuildContext here
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      address: address,
      phone: phone,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'.tr()), // Replace with tr function
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'.tr()), // Replace with tr function
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'.tr()), // Replace with tr function
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'.tr()), // Replace with tr function
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'.tr()), // Replace with tr function
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'.tr()), // Replace with tr function
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'.tr()), // Replace with tr function
            ),
            SizedBox(height: 16.0),
            Consumer<RegistrationProvider>(
              builder: (context, provider, _) {
                return ElevatedButton(
                  onPressed: provider.isLoading ? null : () => _register(context),
                  child: provider.isLoading
                      ? CircularProgressIndicator()
                      : Text('Register'.tr()), // Replace with tr function
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
