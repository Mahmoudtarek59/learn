import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LearnFirestore extends StatefulWidget {
  @override
  State<LearnFirestore> createState() => _LearnFirestoreState();
}

class _LearnFirestoreState extends State<LearnFirestore> {


  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(auth.currentUser!.displayName ?? auth.currentUser!.email!),
        actions: [
          IconButton(
              onPressed: () async {
                await auth.signOut();
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("chat")
                .orderBy("date",descending: true)///edit
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var data = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: data.length,
                  reverse: true,///edit
                  dragStartBehavior: DragStartBehavior.down,
                  itemBuilder: (context, index) => Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        if (data[index]["uid"].toString() ==
                            auth.currentUser!.uid.toString())
                          Spacer(),
                        Container(
                          // width: MediaQuery.of(context).size.width * 0.65,
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.65),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          margin: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: data[index]['uid'].toString() ==
                                    auth.currentUser!.uid.toString()
                                ? Colors.blue
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Text(
                            data[index]["message"].toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          )),
          Container(
            margin: EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: _message,
                  decoration: InputDecoration(
                    label: Text("Message"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                )),
                SizedBox(
                  width: 10.0,
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    CollectionReference ref =
                        FirebaseFirestore.instance.collection("chat");
                    ref.add({
                      "message": _message.text,
                      "uid": auth.currentUser!.uid,
                      "date": DateTime.now().toLocal().toIso8601String(),
                    }).then((value) {
                      _message.clear();
                    });
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
