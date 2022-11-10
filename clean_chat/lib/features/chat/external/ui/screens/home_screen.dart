import 'package:clean_chat/features/chat/adapters/controllers/chat_controller.dart';
import 'package:clean_chat/features/chat/adapters/presenters/home_presenter.dart';
import 'package:clean_chat/features/shared/adapters/controllers/event_handler.dart';
import 'package:clean_chat/features/shared/domain/entities/user.dart';
import 'package:clean_chat/features/shared/domain/storages/local_storage.dart';
import 'package:clean_chat/features/sign_chat/external/ui/screens/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {Key? key, required this.controller, required this.presenter})
      : super(key: key);
  final EventHandler controller;
  final HomePresenter presenter;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.handle(FetchUsers());
    var json = GetIt.I
        .get<LocalStorage<Map<String, dynamic>>>()
        .fetch('logged_user')
        .then((value) => print('json = ${value.toString()}'));
    print('json==');
    print(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: const Icon(Icons.menu),
            title: const Text('Chat rooms'),
          ),
          body: ValueListenableBuilder(
            valueListenable: widget.presenter.viewModel,
            builder: (BuildContext context, HomeViewModelDS viewModel, _) =>
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: viewModel.loadedUsers
                        .map((User user) => ChatTile(
                              avatarText:
                                  user.name.substring(0, 2).toUpperCase(),
                              user: user,
                            ))
                        .toList()),
          ),
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  ChatTile({
    Key? key,
    required this.avatarText,
    required this.user,
    this.lastMessage = 'Touch to start conversation',
  }) : super(key: key);

  final String avatarText;
  final User user;
  late final String lastMessage;

  Widget _avatar() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE7F0FF),
      ),
      child: Center(
        child: Text(
          avatarText,
          style: GoogleFonts.lato(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[900]),
        ),
      ),
      height: 64,
      width: 64,
    );
  }

  Widget _chatTileBody() {
    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(user.name,
                style: GoogleFonts.lato(fontWeight: FontWeight.bold))),
        Flexible(
          fit: FlexFit.tight,
          child: Center(
            child: Text(
              lastMessage,
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _avatar(),
          const SizedBox(width: 8),
          Flexible(
            child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        user: user,
                        controller: GetIt.I.get<ChatController>(),
                        chatTitle: user.name,
                      ),
                    ),
                  );
                },
                child: _chatTileBody()),
          ),
        ],
      ),
    );
  }
}
