import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String uid;
  DatabaseService(this.uid);

  // collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // get reference to doc and update
  // will create the doc if it doesn't exist already
  Future<void> setIngredients(List<String> ingredients) async {
    return await usersCollection.doc(uid).set(
        {'ingredients': _joinIngredients(ingredients)},
        SetOptions(merge: true));
  }

  Future<void> addIngredient(
      List<String> currentIngredients, String newIngredient) async {
    currentIngredients.insert(0, newIngredient);
    await setIngredients(currentIngredients);
  }

  Future<void> removeIngredient(
      List<String> currentIngredients, int index) async {
    currentIngredients.removeAt(index);
    await setIngredients(currentIngredients);
  }

  Future<void> setRecipe(int recipeId) async {
    return await usersCollection
        .doc(uid)
        .set({'recipeId': recipeId}, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot> get userInfo {
    return usersCollection.doc(uid).snapshots();
  }

  static List<String> getIngredients(DocumentSnapshot doc) {
    final data = doc?.data();

    if (data == null || data['ingredients'] == null) {
      return [];
    }

    return _splitIngredients(data['ingredients']);
  }

  static String getRecipeId(DocumentSnapshot doc) {
    final data = doc?.data();

    if (data == null || data['recipes'] == null) {
      return '';
    }

    return data['recipes'];
  }

  static List<String> _splitIngredients(String ingredients) {
    if (ingredients?.isEmpty ?? true) {
      return [];
    } else {
      return ingredients.split(',');
    }
  }

  static String _joinIngredients(List<String> ingredients) {
    if (ingredients?.isEmpty ?? true) {
      return '';
    } else {
      return ingredients.join(',');
    }
  }
}

//Returns confirmation message
Future<String> addIngredient(
    BuildContext context, DatabaseService db, List<String> currentIngredients,
    {String ingredientToAdd, TextEditingController controller}) async {
  String toAdd = ingredientToAdd ?? '';
  if (controller != null) {
    toAdd = controller.text;
  }
  toAdd = toAdd.trim().toLowerCase().capFirstLetter();

  if (currentIngredients.contains(toAdd)) {
    return '$toAdd already in your ingredients';
  } else {
    try {
      await db.addIngredient(currentIngredients, toAdd);

      FocusScope.of(context).unfocus();
      controller?.clear();
      return '$toAdd added!';
    } catch (_) {
      return 'Something went wrong';
    }
  }
}

extension StringExtension on String {
  String capFirstLetter() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
