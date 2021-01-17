import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/services/firebase.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sc = ScrollController();
    final db = DatabaseService(Provider.of<String>(context));
    final userData = Provider.of<DocumentSnapshot>(context);
    final ingredients = DatabaseService.getIngredients(userData);

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
            'Items (${ingredients.length})',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              controller: sc,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: ingredients.length,
                physics: BouncingScrollPhysics(),
                controller: sc,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Align(
                        child: Text(
                          '${ingredients[index]}',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            child: Icon(Icons.delete, color: Colors.green),
                            onTap: () async {
                              try {
                                String ingredientToRemove = ingredients[index];
                                await db.removeIngredient(ingredients, index);
                                showSnackBar(
                                    context, '$ingredientToRemove removed');
                              } catch (_) {
                                showSnackBar(context, 'Something went wrong');
                              }
                            },
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
