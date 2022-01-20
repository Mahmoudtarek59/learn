import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _message = TextEditingController();

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
            child: FirebaseAnimatedList(
              query: FirebaseDatabase.instance.ref("chat"),
              padding: EdgeInsets.all(10.0),
              defaultChild: Center(
                child: CircularProgressIndicator(),
              ),
              itemBuilder: (context, snapshot, animation, index) {
                return Container(
                  margin: EdgeInsets.all(5.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.green.shade100,
                  ),
                  child: Text(snapshot.child('message').value.toString()),
                );
              },
            ),
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
                          DatabaseReference ref =
                              FirebaseDatabase.instance.ref().child("chat");
                          await ref.push().set({
                            'message': _message.text,
                            "date": DateTime.now().toLocal().toIso8601String(),
                            "name": "mahmoud tarek"
                          });
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
