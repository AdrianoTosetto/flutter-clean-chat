import 'dart:io';

import 'package:clean_chat/features/chat/adapters/controllers/chat_controller.dart';
import 'package:clean_chat/features/chat/adapters/presenters/chat_presenter.dart';
import 'package:clean_chat/features/chat/external/ui/screens/home_screen.dart';
import 'package:clean_chat/features/chat/locator.dart' as chat_locator;
import 'package:clean_chat/features/sign_chat/adapters/controllers/sign_up_controller.dart';
import 'package:clean_chat/features/sign_chat/adapters/presenters/sign_up_presenter.dart';
import 'package:clean_chat/features/sign_chat/external/ui/screens/sign_up_screen.dart';
import 'package:clean_chat/features/sign_chat/locator.dart' as sign_up_locator;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class _HttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(context)
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
}

void main() {
  HttpOverrides.global = _HttpOverrides();
  sign_up_locator.setupSignUp();
  chat_locator.setupChat();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUpScreen(
        controller: chat_locator.locator.get<SignUpController>(),
        presenter: chat_locator.locator.get<SignUpPresenter>(),
      ),
      // home: HomeScreen(
      //   controller: chat_locator.locator.get<ChatController>(),
      //   presenter: chat_locator.locator.get<ChatPresenter>(),
      // ),
    );
  }
}
