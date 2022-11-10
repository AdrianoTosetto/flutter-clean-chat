import 'dart:async';
import 'dart:developer';

import 'package:clean_chat/features/chat/external/ui/screens/home_screen.dart';
import 'package:clean_chat/features/sign_chat/external/ui/screens/chat_screen/chat_screen.dart';
import 'package:clean_chat/features/sign_chat/external/ui/screens/sign_up_screen.dart';
import 'package:clean_chat/features/sign_chat/locator.dart' as sign_up_locator;
import 'package:clean_chat/features/chat/locator.dart' as chat_locator;
import 'package:flutter/material.dart';

mixin NavigatorManager {
  static const String signUp = 'signUp';
  static const String home = 'home';
  static const String chat = 'chat';

  Map<String, Widget> pages = {
    'signUp': sign_up_locator.locator.get<SignUpScreen>(),
    'home': chat_locator.locator.get<HomeScreen>(),
    // 'chat': chat_locator.locator.get<ChatScreen>(),
  };

  void handle(StreamController<String> controller, BuildContext context) async {
    controller.stream.listen((String route) {
      var page = pages[route]!;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
    });
  }
}
