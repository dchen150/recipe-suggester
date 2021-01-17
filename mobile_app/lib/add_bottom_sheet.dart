import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/picture_processing.dart';

class AddBottomSheet extends StatelessWidget {
  final CameraDescription camera;

  const AddBottomSheet({Key key, this.camera}) : super(key: key);

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
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AddFoodDialog(),
                );
              },
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TakePhotoScreen(camera: camera),
                ),
              ),
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

class AddFoodDialog extends StatefulWidget {
  @override
  _AddFoodDialogState createState() => _AddFoodDialogState();
}

class _AddFoodDialogState extends State<AddFoodDialog> {
  TextEditingController addFoodController = TextEditingController();
  String confirmMessage = '';

  @override
  Widget build(BuildContext context) => Dialog(
        child: Container(
          height: 225,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add food',
                      style: TextStyle(fontSize: 20),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        size: 25,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                TextField(
                  controller: addFoodController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Food',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    confirmMessage,
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: RaisedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        confirmMessage = '${addFoodController.text} added!';
                      });
                      addFoodController.clear();
                    },
                    color: Theme.of(context).accentColor,
                    child: Text('Add'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
