import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:login/controler/language_controller.dart';
import 'package:provider/provider.dart';
import 'package:login/providers/login_provider.dart';
import 'package:login/screen/Home.dart';
import 'package:login/screen/admin.dart';
import 'package:login/screen/login.dart';
import 'package:login/screen/profile.dart';
import 'package:login/screen/register.dart';
import 'package:login/providers/register_provider.dart';
import 'package:login/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ru', 'RU'), // Add Russian language locale
        Locale('kk', 'KZ'), // Add Kazakh language locale
      ],
      fallbackLocale: const Locale('en', 'US'),
      path: 'assets/translations',
      child: MyApp(),
    ),
  );
}


class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme = darkTheme;

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    if (_currentTheme == lightTheme) {
      _currentTheme = darkTheme;
    } else if (_currentTheme == darkTheme) {
      _currentTheme = loftTheme;
    } else {
      _currentTheme = lightTheme;
    }
    notifyListeners();
  }
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider<RegistrationProvider>(
          create: (_) => RegistrationProvider(),
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(),
        ),
        ChangeNotifierProvider<LanguageController>(
          create: (_) => LanguageController(),
        ),
      ],
      child: Consumer<LoginProvider>(
        builder: (context, loginProvider, _) {
          return Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, _) {
              return Consumer<LanguageController>(
                builder: (context, languageController, _) {
                  return MaterialApp(
                    routes: {
                      '/login': (context) => LoginPage(),
                      '/profile': (context) => ProfilePage(),
                      '/register': (context) => RegisterPage(),
                      '/home': (context) => HomePage(),
                      '/admin': (context) => AdminPage(),
                    },
                    title: 'Your App',
                    theme: themeNotifier.currentTheme,
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: context.locale,
                    home: LoginPage(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
