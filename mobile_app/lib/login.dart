import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Image.asset('assets/images/cooking_background.png'),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Text('Wish A Dish'),
            ),
          ),
        ],
      );
}
