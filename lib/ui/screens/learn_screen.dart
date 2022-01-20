import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
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
        children: [
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance.ref().child("chat").onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  var data = snapshot.data!.snapshot.children;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => Container(
                      width: double.infinity,
                      child: Row(
                        children: [
                          if (data
                                  .elementAt(index)
                                  .child("uid")
                                  .value
                                  .toString() ==
                              auth.currentUser!.uid.toString())
                            Spacer(),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            margin: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: data
                                          .elementAt(index)
                                          .child("uid")
                                          .value
                                          .toString() ==
                                      auth.currentUser!.uid.toString()
                                  ? Colors.blue
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Text(
                              data
                                  .elementAt(index)
                                  .child("maessage")
                                  .value
                                  .toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
            // child: FirebaseAnimatedList(
            //   query: FirebaseDatabase.instance.ref().child("chat"),
            //
            //   itemBuilder: (context, snapshot, animation, index) => Text(
            //     snapshot.child("maessage").value.toString(),
            //   ),
            // ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _message,
                    decoration: InputDecoration(
                      label: Text("Message"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                IconButton(
                  onPressed: () async {
                    DatabaseReference ref =
                        FirebaseDatabase.instance.ref().child("chat");

                    await ref.push().set({
                      "maessage": _message.text,
                      "uid": auth.currentUser!.uid,
                    });
                    _message.clear();
                  },
                  icon: Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
