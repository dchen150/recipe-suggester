import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

class RecipeScreen extends StatelessWidget {
  final String recipeId;

  const RecipeScreen({Key key, this.recipeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: FutureBuilder<Response>(
          future: getRecipe(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final responseBody = jsonDecode(snapshot.data.body);
              final title = responseBody["title"];
              final imageURL = responseBody["image"];

              // list of ingredients (object) which has the keys: name and amount
              final extendedIngredients = responseBody["extendedIngredients"];
              List<Map> ingredients = [];
              for (var i = 0; i < extendedIngredients.length; ++i) {
                ingredients.add({
                  "name": extendedIngredients[i].name,
                  "amount": extendedIngredients[i].amount
                });
              }

              // list of steps
              final analyzedInstructions = responseBody["analyzedInstructions"];
              List<String> instructions = [];
              for (var i = 0; i < analyzedInstructions.length; ++i) {
                instructions.add(analyzedInstructions[i].step);
              }
              // data for recipe page is: title, imageURL, ingredients, instructions
              return Container();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<Response> getRecipe() {
    final findFoodURL =
        'https://api.spoonacular.com/recipes/$recipeId/information?includeNutrition=false&apiKey=702e24bf089846eaaa5451516dfb4c3c';
    return get(findFoodURL);
  }
}
