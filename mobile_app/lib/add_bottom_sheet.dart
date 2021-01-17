import 'dart:io' as Io;
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TakePhotoScreen(
                    camera: camera,
                  ),
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

class TakePhotoScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePhotoScreen({Key key, this.camera}) : super(key: key);

  @override
  _TakePhotoScreenState createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<TakePhotoScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.ultraHigh,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  CameraPreview(_controller),
                  Positioned(
                    bottom: 30,
                    child: GestureDetector(
                      onTap: () async {
                        // Take the Picture in a try / catch block. If anything goes wrong,
                        // catch the error.
                        try {
                          // Ensure that the camera is initialized.
                          await _initializeControllerFuture;

                          // Attempt to take a picture and log where it's been saved.
                          XFile file = await _controller.takePicture();

                          // If the picture was taken, display it on a new screen.
                          if (file != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DisplayPictureScreen(imagePath: file.path),
                              ),
                            );
                          }
                        } catch (e) {
                          // If an error occurs, log the error to the console.
                          print(e);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 4, color: Colors.white)),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      );
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: FutureBuilder<Response>(
          future: getGroceries(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print(jsonDecode(snapshot.data.body)["objects"]);
              return Container();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<Response> getGroceries() {
    final findFoodURL =
        'https://us-central1-wish-a-dish-5dd7c.cloudfunctions.net/findFood';
    List<int> bytes = Io.File(this.imagePath).readAsBytesSync();
    String img64 = base64Encode(bytes);
    return post(findFoodURL, body: {'image': img64});
  }
}
