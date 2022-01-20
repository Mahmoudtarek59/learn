import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreenWithFirestore extends StatelessWidget {
  TextEditingController _message = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(auth.currentUser!.email ?? "name"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<QuerySnapshot<Map>>(
                future: FirebaseFirestore.instance.collection("chat").get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var data = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.all(5.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.green.shade100,
                        ),
                        child: Text(data[index]["message"].toString()),
                      ),
                    );
                  }
                }),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: _message,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                )),
                Container(
                    margin: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue),
                    child: IconButton(
                        onPressed: () async {
                          // Create a CollectionReference called users that references the firestore collection
                          CollectionReference ref =
                              FirebaseFirestore.instance.collection('chat');
                          await ref
                              .add({
                                "message": _message.text,
                                "uid": auth.currentUser!.uid,
                                "date":
                                    DateTime.now().toLocal().toIso8601String(),
                              })
                              .then((value) => print("data added"))
                              .catchError((e) => print(e.toString()));
                          _message.clear();
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
