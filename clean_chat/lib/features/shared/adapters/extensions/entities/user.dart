import 'package:clean_chat/features/shared/domain/entities/user.dart';

extension UserExtension on User {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }

  static fromJson(Map<String, dynamic> json) {
    return User(name: json['name'], id: json['id']);
  }
}
