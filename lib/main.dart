import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:money_bizo/providers/cart_provider.dart';
import 'package:money_bizo/providers/city_suburb_provider.dart';
import 'package:money_bizo/providers/download_progress.dart';
import 'package:money_bizo/providers/home_screen_provider.dart';
import 'package:money_bizo/providers/product_provider.dart';
import 'package:money_bizo/providers/saved_provider.dart';
import 'package:money_bizo/providers/transaction_provider.dart';
import 'package:money_bizo/screens/authentication/splash_screen.dart';
import 'package:provider/provider.dart';

import 'providers/login_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/search_provider.dart';
import 'widget/sahared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // NotificationService().initNotification();
  // Prefs.clearPrefs();

  // final fcmtoken = await FirebaseMessaging.instance.getToken();
  // debugPrint('device token :${fcmtoken!}');

  Prefs.getToken().then((value) {
    debugPrint('token: $value');
  });

  Prefs.getPrefs('loginId').then((value) {
    debugPrint('loginId: $value');
  });

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => SearchProvider()),
    ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ChangeNotifierProvider(create: (_) => DownloadProgress()),
    ChangeNotifierProvider(create: (_) => TransactionProvider()),
    ChangeNotifierProvider(create: (_) => SavedProvider()),
    ChangeNotifierProvider(create: (_) => CitySuburbProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Bizo',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyText1: TextStyle(
              fontFamily: 'ProductSans',
              fontSize: 16.0,
              fontWeight: FontWeight.normal),
        ),
      ),
      home: const SplashScreen(),
      // home: const ForgotPasswordScreen(),
    );
  }
}
