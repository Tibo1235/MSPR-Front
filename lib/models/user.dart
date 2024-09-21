import 'package:flutter/material.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class User {
  String? token;
  final int userId;
  final String role;

  User({
    this.token,
    required this.userId,
    required this.role
  });

  factory User.fromJson(Map<String, dynamic> json ) {
    return User(
      userId: json['userId'] as int,
      role : json['role'] as String,
    );
  }
}

class UserInfo {
  final String pseudo;
  final String email;
  final String ville;
  final String codePostal;

  UserInfo({
    required this.pseudo,
    required this.email,
    required this.ville,
    required this.codePostal
  });

  factory UserInfo.fromJson(Map<String, dynamic> json ) {
    return UserInfo(
      pseudo: json['pseudo'] as String,
      email : json['email'] as String,
      ville : json['ville'] as String,
      codePostal : json['code-postal'] as String,
    );
  }
}
