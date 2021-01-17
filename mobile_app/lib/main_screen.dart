import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/home_page.dart';
import 'package:mobile_app/add_bottom_sheet.dart';
import 'package:mobile_app/recipe.dart';

class MainScreen extends StatefulWidget {
  final CameraDescription camera;

  const MainScreen({Key key, this.camera}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;
  Widget currentPage = HomePage();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: currentPage,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTab,
          onTap: (index) {
            if (index == 1) {
              showModalBottomSheet(
                context: context,
                builder: (context) => AddBottomSheet(camera: widget.camera),
              );
            } else if (index != currentTab) {
              setState(() {
                currentTab = index;
                if (currentTab == 0) {
                  currentPage = HomePage();
                } else if (currentTab == 2) {
                  currentPage = RecipeWrapper();
                }
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
