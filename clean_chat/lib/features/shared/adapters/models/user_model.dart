import 'package:clean_chat/features/shared/domain/entities/user.dart';

class UserModel extends User {
  UserModel({required String name, required String id})
      : super(name: name, id: id);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }

  static fromJson(Map<String, dynamic> json) =>
      User(name: json['name'], id: json['id']);

  static UserModel fromUser(User user) =>
      UserModel(name: user.name, id: user.id);
}
