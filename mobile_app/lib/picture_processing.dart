import 'dart:io';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
                                    DisplayPictureScreen(file: file),
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
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ));
            }
          },
        ),
      );
}

class DisplayPictureScreen extends StatefulWidget {
  final XFile file;

  const DisplayPictureScreen({Key key, this.file}) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  Future<Response> possibleFoods;
  TextEditingController addFoodController = TextEditingController();
  @override
  void initState() {
    super.initState();
    possibleFoods = getPossibleFoods();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Stack(
          children: [
            Image.file(
              File(widget.file.path),
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            FutureBuilder<Response>(
              future: possibleFoods,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var suggestionsJson =
                      jsonDecode(snapshot?.data?.body ?? '')['objects'];
                  List<String> suggestions =
                      suggestionsJson != null ? List.from(suggestionsJson) : [];

                  return SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 30, 16, 30),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text(
                                      'Add food found in photo',
                                      style: TextStyle(fontSize: 22),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: suggestions.length,
                                      itemBuilder: (context, index) => InkWell(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  '${suggestions[index]} added'),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                suggestions[index],
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Icon(Icons.add),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: InkWell(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                '${addFoodController.text} added'),
                                          ),
                                        );
                                        addFoodController.clear();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: addFoodController,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Add food not suggested here',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 24),
                                            child: Icon(Icons.add),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                  );
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ));
                }
              },
            ),
          ],
        ),
      );

  Future<Response> getPossibleFoods() async {
    final findFoodURL =
        'https://us-central1-wish-a-dish-5dd7c.cloudfunctions.net/findFood';
    List<int> bytes = await widget.file.readAsBytes();
    String img64 = base64Encode(bytes);
    return post(findFoodURL, body: {'image': img64});
  }
}
