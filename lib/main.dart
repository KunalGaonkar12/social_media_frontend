import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/config/keys.dart';
import 'package:social_media/config/router/router.dart';

import 'config/app/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Provider set up
    return MultiProvider(providers:Providers.getAllProviders(),
   child: MaterialApp.router(
    title: 'Social media',
scaffoldMessengerKey: Keys.scaffoldMessengerKey,
routerConfig: Routers.getRoutes(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    ),
    ));
  }
}

