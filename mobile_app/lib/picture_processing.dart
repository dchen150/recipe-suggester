import 'dart:io';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/services/firebase.dart';
import 'package:provider/provider.dart';

class TakePhotoScreen extends StatefulWidget {
  final CameraDescription camera;
  final bool forReceipt;

  const TakePhotoScreen({Key key, this.camera, this.forReceipt = false})
      : super(key: key);

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
                                builder: (context) => DisplayPictureScreen(
                                  file: file,
                                  forReceipt: widget.forReceipt,
                                ),
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
  final bool forReceipt;

  const DisplayPictureScreen({Key key, this.file, this.forReceipt = false})
      : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  Future<Response> possibleFoods;
  TextEditingController addFoodController = TextEditingController();
  List<String> ingredients;
  DatabaseService db;

  @override
  void initState() {
    super.initState();
    possibleFoods = getPossibleFoods();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    db = DatabaseService(Provider.of<String>(context));
    final userData = Provider.of<DocumentSnapshot>(context);
    ingredients = DatabaseService.getIngredients(userData);
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
                                      widget.forReceipt
                                          ? 'Add food found in receipt'
                                          : 'Add food found in photo',
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
                                        onTap: () async {
                                          if (!ingredients.contains(
                                              suggestions[index]
                                                  .toLowerCase()
                                                  .trim()
                                                  .capFirstLetter())) {
                                            String message =
                                                await addIngredient(
                                                    context, db, ingredients,
                                                    ingredientToAdd:
                                                        suggestions[index]);
                                            showSnackBar(context, message);
                                          }
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
                                              ingredients.contains(
                                                      suggestions[index])
                                                  ? Icon(Icons.check,
                                                      color: Theme.of(context)
                                                          .accentColor)
                                                  : Icon(Icons.add),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: InkWell(
                                      onTap: () async {
                                        String message = await addIngredient(
                                            context, db, ingredients,
                                            controller: addFoodController);
                                        showSnackBar(context, message);
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
    final findFoodURL = widget.forReceipt
        ? 'https://us-central1-wish-a-dish-5dd7c.cloudfunctions.net/readReceipt'
        : 'https://us-central1-wish-a-dish-5dd7c.cloudfunctions.net/findFood';
    List<int> bytes = await widget.file.readAsBytes();
    String img64 = base64Encode(bytes);
    return post(findFoodURL, body: {'image': img64});
  }
}
