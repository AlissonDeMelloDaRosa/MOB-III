import 'dart:ffi';

import 'package:flutter/foundation.dart';

class User {
  final Int id;
  final String name;
  final String email;
  final String picture;
  final String dog_name;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.picture,
    required this.dog_name,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as Int,
      name: json['name'] as String,
      email: json['email'] as String,
      picture: json['picture'] as String,
      dog_name: json['dog_name'] as String,
    );
  }
}
