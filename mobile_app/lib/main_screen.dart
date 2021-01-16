import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTab,
          onTap: (index) {
            if (index == 1) {
              showModalBottomSheet(
                context: context,
                builder: (context) => BottomSheet(),
              );
            } else {
              setState(() {
                currentTab = index;
              });
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/recipe.png')),
              label: 'Recipes',
            ),
          ],
        ),
      );
}

class BottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        height: 180,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Icon(
                    Icons.close,
                    size: 30,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Image.asset(
                      'assets/images/text.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
                  Text('Add by text'),
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Image.asset(
                      'assets/images/camera.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
                  Text('Add by photo'),
                ],
              ),
            )
          ],
        ),
      );
}
