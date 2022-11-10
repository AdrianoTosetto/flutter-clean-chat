import 'dart:math';

import 'package:clean_chat/features/chat/adapters/controllers/chat_controller.dart';
import 'package:clean_chat/features/shared/adapters/controllers/event_handler.dart';
import 'package:clean_chat/features/shared/adapters/models/user_model.dart';
import 'package:clean_chat/features/shared/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.chatTitle,
    required this.controller,
    required this.user,
  }) : super(key: key);

  final String chatTitle; // friend name or group name
  final EventHandler controller;

  final User user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          title: Text(
            widget.chatTitle,
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // resizeToAvoidBottomInset: false,
        body: SizedBox(
          height: MediaQuery.of(context).size.height - kToolbarHeight,
          width: MediaQuery.of(context).size.width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                constraints: const BoxConstraints.expand(),
                color: Colors.blueAccent,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ...List.generate(
                      //   30,
                      //   (_) {
                      //     bool isOwnMessage = Random().nextBool();
                      //     return Align(
                      //       alignment: isOwnMessage
                      //           ? Alignment.topRight
                      //           : Alignment.topLeft,
                      //       child: ChatBubble(
                      //         message: List.generate(100, (index) => 'hallo')
                      //             .join(''),
                      //         isOwnMessage: isOwnMessage,
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.blue,
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: TextField(
                        controller: textEditingController,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            border: InputBorder.none,
                            hintText: 'Write you message')),
                  ),
                  IconButton(
                      onPressed: () {
                        widget.controller.handle(SendMessage(SendMessagePayload(
                          message: textEditingController.text,
                          receiver: widget.user,
                        )));
                      },
                      icon: const Icon(Icons.send)),
                ],
              ),
            )
          ]),
        ));
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {Key? key, required this.message, required this.isOwnMessage})
      : super(key: key);

  final String message;
  final bool isOwnMessage;

  BorderRadius _borderRadius() {
    if (isOwnMessage) {
      return const BorderRadius.only(
        topLeft: Radius.circular(8),
        bottomLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      );
    }

    return const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
        bottomRight: Radius.circular(8));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomPaint(
        child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: _borderRadius(),
            ),
            child: Text(message)),
        painter: ChatBubblePaint(isOwnMessage: isOwnMessage),
      ),
    );
  }
}

class ChatBubblePaint extends CustomPainter {
  ChatBubblePaint({required this.isOwnMessage});

  final bool isOwnMessage;

  Path _generateBubblePath(bool isOwnMessage, Size size) {
    if (isOwnMessage) {
      return Path()
        ..moveTo(size.width, size.height - 10)
        ..lineTo(size.width + 10, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, size.height - 10);
    }

    return Path()
      ..moveTo(0, size.height - 10)
      ..lineTo(-10, size.height)
      ..lineTo(0, size.height);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 20.0;

    canvas.drawPath(_generateBubblePath(isOwnMessage, size), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
