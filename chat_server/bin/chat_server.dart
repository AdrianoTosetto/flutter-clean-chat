import 'dart:convert';

import 'dart:math';
import 'dart:async';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:faker_dart/faker_dart.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf/shelf.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

shelf_router.Router chatRouter = shelf_router.Router();

const String serverIP = '192.168.100.27';
const int serverPort = 4040;

extension on int {
  String get hexString => toRadixString(16);
}

String uuid() {
  final Random random = Random();
  const String template = '00000000-0000-4000-0000-000000000000';

  return template.split('').map((String hexChar) {
    if (hexChar == '4' || hexChar == '-') {
      return hexChar;
    }
    return random.nextInt(15).hexString;
  }).join();
}

class User {
  late final String name;
  late final String id;

  User({required this.name, String? uid}) {
    id = uid ?? uuid();
    print('id = ${toJson()}');
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
      };

  @override
  String toString() => json.encode(toJson());
}

Faker faker = Faker.instance;
List<User> activeUsers = [
  User(name: faker.name.firstName()),
  User(name: faker.name.firstName()),
];

Future<void> main() async {
  final Map<String, WebSocketChannel> channels = {};
  var handler = webSocketHandler((WebSocketChannel webSocket) {
    webSocket.stream.listen((message) {
      Map<String, dynamic> messageJson = json.decode(message as String);
      if (messageJson['type'] == 'user_ack') {
        print('new user subscribed');
        String id = messageJson['user_id'];
        channels[id] = webSocket;
      }

      if (messageJson['type'] == 'new_message') {
        String receiverId = messageJson['receiver_id'];
        channels[receiverId]!.sink.add(message);
      }

      print(message);
    });
  });

  chatRouter.get('/connect', handler);

  chatRouter.get('/users', (Request request) {
    return Response.ok(json.encode({
      'users': activeUsers,
    }));
  });

  chatRouter.get('/users/id/<id>', (Request request, String id) {
    var users = activeUsers.where((User user) => user.id == id);
    if (users.isEmpty) {
      return Response.notFound(json.encode({'Error': 'UserNotFound'}));
    }
    return Response.ok(json.encode({'user': users.first.toJson()}));
  });

  chatRouter.get('/users/name/<name>', (Request request, String name) async {
    await Future.delayed(const Duration(seconds: 2));
    var users = activeUsers.where((User user) => user.name == name);
    if (users.isEmpty) {
      return Response.notFound(json.encode({'Error': 'UserNotFound'}));
    }
    return Response.ok(json.encode(users.first.toJson()));
  });

  chatRouter.post('/user', (Request request) async {
    await Future.delayed(const Duration(seconds: 2));
    var body = (await request.readAsString());
    var userJson = json.decode(body);
    var user = User(name: userJson['name']);
    activeUsers.add(user);

    return Response.ok(json.encode(user.toJson()));
  });

  shelf_io.serve(chatRouter, serverIP, serverPort).then((server) {
    print('Serving at ws://${server.address.host}:${server.port}');
  });
}
