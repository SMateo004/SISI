import 'package:flutter/material.dart';

import '../domain/app_user.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.user, this.radius = 24});

  final AppUser user;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final name = user.name?.trim() ?? '';
    return CircleAvatar(
      radius: radius,
      foregroundImage: user.photoUrl == null
          ? null
          : NetworkImage(user.photoUrl!),
      child: name.isEmpty
          ? Icon(Icons.person, size: radius * 1.1)
          : Text(
              name.characters.first.toUpperCase(),
              style: TextStyle(fontSize: radius * 0.8),
            ),
    );
  }
}
