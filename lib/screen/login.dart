import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login/providers/login_provider.dart';
import 'package:login/screen/register.dart';
import 'package:login/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:login/controler/language_controller.dart';

void changeLanguage(BuildContext context, Locale locale) {
  context.setLocale(locale);
}

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void toggleTheme(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final languageController = Provider.of<LanguageController>(context, listen: false);

    themeNotifier.toggleTheme();

    // Example: Change to Russian language
    changeLanguage(context, const Locale('ru', 'RU'));
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final errorMessage = loginProvider.errorMessage;

    void login() {
      final String email = emailController.text;
      final String password = passwordController.text;

      loginProvider.login(context, email, password);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Login').tr(),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_4),
            onPressed: () {
              toggleTheme(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Select Language').tr(),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('English').tr(),
                          onTap: () {
                            changeLanguage(context, const Locale('en', 'US'));
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Russian').tr(),
                          onTap: () {
                            changeLanguage(context, const Locale('ru', 'RU'));
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Kazakh').tr(),
                          onTap: () {
                            changeLanguage(context, const Locale('kk', 'KZ'));
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /* Image.asset(
              'assets/images/login_logo.png',
              width: 150,
              height: 150,
            ),*/
            const SizedBox(height: 32.0),
            if (errorMessage != null)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email'.tr(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password'.tr(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: login,
              child: Text('Login').tr(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Create an account').tr(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                loginProvider.setGuestMode(true);
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text('Guest Mode').tr(),
            ),
          ],
        ),
      ),
    );
  }
}
