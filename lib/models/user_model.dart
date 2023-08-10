import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  final String email;
  final String name;
  final String id;

  final String username;
  final String role;
  final String alamat;
  final List userCart;
  final List userWish;

  final Timestamp createdAt;

  UserModel({
    required this.username,
    required this.createdAt,
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.alamat,
    required this.userCart,
    required this.userWish,
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      createdAt: snapshot["createdAt"],
      name: snapshot["name"],
      username: snapshot["username"],
      id: snapshot["id"],
      email: snapshot["email"],
      role: snapshot["role"],
      alamat: snapshot["alamat"],
      userCart: snapshot["userCart"],
      userWish: snapshot["userWish"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "username": username,
        "id": id,
        "email": email,
        "role": role,
        "alamat": alamat,
        "userCart": userCart,
        "userWish": userWish,
        "createdAt": Timestamp.now()
      };
}
