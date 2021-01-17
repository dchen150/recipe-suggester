import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScrollController sc = ScrollController();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                'My Virtual Kitchen',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Items (20)',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              controller: sc,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                controller: sc,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 0.1, color: Colors.transparent)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Align(
                          child: Text(
                            'Apple $index',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.delete, color: Colors.green)),
                      ],
                    ),
                  ),
                ),
                itemCount: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
