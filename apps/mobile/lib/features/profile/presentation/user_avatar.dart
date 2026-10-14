import 'package:flutter/material.dart';

import '../domain/app_user.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.user, this.radius = 24});

  final AppUser user;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final initial = user.displayName.characters.first.toUpperCase();
    return CircleAvatar(
      radius: radius,
      foregroundImage: user.photoUrl == null
          ? null
          : NetworkImage(user.photoUrl!),
      child: Text(initial, style: TextStyle(fontSize: radius * 0.8)),
    );
  }
}
