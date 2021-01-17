import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/services/firebase.dart';
import 'package:provider/provider.dart';

class RecipeWrapper extends StatefulWidget {
  @override
  _RecipeWrapperState createState() => _RecipeWrapperState();
}

class _RecipeWrapperState extends State<RecipeWrapper> {
  num recipeId;
  Future<Response> recipeResponse;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userData = Provider.of<DocumentSnapshot>(context);
    recipeId = DatabaseService.getRecipeId(userData);
    recipeResponse = _getRecipe();
  }

  @override
  Widget build(BuildContext context) {
    if (recipeId == -1) {
      return NoRecipeScreen();
    }

    return FutureBuilder<Response>(
        future: recipeResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot?.data?.body?.isEmpty ?? true) {
              return NoRecipeScreen();
            }

            final responseBody = jsonDecode(snapshot.data.body);

            if (responseBody["title"] == null ||
                responseBody["image"] == null ||
                responseBody["extendedIngredients"] == null ||
                responseBody["analyzedInstructions"] == null ||
                List.from(responseBody["extendedIngredients"]).isEmpty ||
                List.from(responseBody["analyzedInstructions"]).isEmpty) {
              return NoRecipeScreen();
            }

            final title = responseBody["title"] as String;
            final imageURL = responseBody["image"] as String;

            List<String> ingredients = [];
            List.from(responseBody["extendedIngredients"])?.forEach((body) {
              if (body != null) {
                Map<String, dynamic> map = Map.from(body);
                ingredients.add(map['originalString']);
              }
            });

            // list of steps
            List<String> instructions = [];
            List.from(Map.from(List.from(
                    responseBody["analyzedInstructions"])[0])['steps'])
                .forEach((body) {
              instructions.add(body['step'] as String);
            });

            // data for recipe page is: title, imageURL, ingredients, instructions
            return LastRecipeScreen(
              title: title,
              imageURL: imageURL,
              ingredients: ingredients,
              instructions: instructions,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<Response> _getRecipe() {
    final findFoodURL =
        'https://api.spoonacular.com/recipes/${recipeId.toInt()}/information?includeNutrition=false&apiKey=139bf223ffa5465b8f0205b17a706e65';
    return get(findFoodURL);
  }
}

class LastRecipeScreen extends StatelessWidget {
  final String title;
  final String imageURL;
  final List<String> ingredients;
  final List<String> instructions;

  const LastRecipeScreen(
      {Key key, this.title, this.imageURL, this.ingredients, this.instructions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> stepsList = [];

    for (int i = 0; i < instructions.length; i++) {
      stepsList.add(ListTile(title: Text('${i + 1}. ${instructions[i]}')));
    }

    if ((title?.isEmpty ?? true) ||
        (imageURL?.isEmpty ?? true) ||
        (ingredients?.isEmpty ?? true) ||
        (instructions?.isEmpty ?? true)) {
      return NoRecipeScreen();
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Recipe',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(title, style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 5),
            Image.network(imageURL),
            Expanded(
              child: ListView(
                children: [
                  ExpansionTile(
                    title: Text('Ingredients'),
                    children: ingredients
                        .map((title) => ListTile(title: Text('$title')))
                        .toList(),
                  ),
                  ExpansionTile(
                    title: Text('Steps'),
                    children: stepsList,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NoRecipeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Recipe',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'You have not recently asked for a recipe',
              style: TextStyle(fontSize: 19),
            ),
            SizedBox(height: 20),
            Text(
              'Try saying “Hey google, talk to Wish a Dish” to your Google Assistant',
              style: TextStyle(fontSize: 19),
            ),
            SizedBox(height: 25),
            Expanded(child: Image.asset('assets/images/recipeFiller.png')),
          ],
        ),
      ),
    );
  }
}
