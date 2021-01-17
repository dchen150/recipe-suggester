import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // get reference to doc and update
  // will create the doc if it doesn't exist already
  Future updateUserData(String ingredients, int recipeID) async {
    return await usersCollection
        .doc(uid)
        .set({'ingredients': ingredients, 'recipeID': recipeID});
  }

  // get user stream/snapshot
  Stream<DocumentSnapshot> get users {
    return usersCollection.doc(uid).snapshots();
  }
}
