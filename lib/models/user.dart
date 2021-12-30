import 'package:flutter/material.dart';

class User with ChangeNotifier {
  final String userId;
  final String firstName;
  final String lastName;
  final String userMobile;
  final String userEmail;
  final String userReferalCode;
  final String token;
  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.userMobile,
    required this.userEmail,
    required this.userReferalCode,
    required this.token,
  });
}
