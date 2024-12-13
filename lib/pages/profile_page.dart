import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Профиль")),
      body: const Center(
        child: Text(
          'Пользователя пока нет.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
