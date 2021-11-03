// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DeleteHome(),
    );
  }
}

class DeleteHome extends StatefulWidget {
  const DeleteHome({Key? key}) : super(key: key);
  @override
  _DeleteHomeState createState() => _DeleteHomeState();
}

class _DeleteHomeState extends State<DeleteHome> {
  TextEditingController userEmail = TextEditingController();
  List<String> userEmails = [
    "edison416@gmail.com",
    "romax@naturalmaxco.com",
    "2954872121@qq.com",
    "dannio-group@outlook.com",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete Stores"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                      "Number of Users: ${snapshot.data!.docs.length.toString()}"),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // ! Delete stores and users
                      userEmails.forEach((userEmailIndex) async {
                        await FirebaseFirestore.instance
                            .collection("users")
                            .where("email", isEqualTo: userEmailIndex)
                            .limit(1)
                            .get()
                            .then((value) async {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(value.docs[0].id)
                              .get()
                              .then((docSnapshot) async {
                            if (docSnapshot.exists) {
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(value.docs[0].id)
                                  .delete()
                                  .then((value) {
                                print("deleted user ---- ${userEmailIndex}");
                              });
                            }
                          });
                        });

                        await FirebaseFirestore.instance
                            .collection("stores")
                            .where("email", isEqualTo: userEmailIndex)
                            .limit(1)
                            .get()
                            .then((value) async {
                          await FirebaseFirestore.instance
                              .collection("stores")
                              .doc(value.docs[0].id)
                              .get()
                              .then((docSnapshot) async {
                            if (docSnapshot.exists) {
                              await FirebaseFirestore.instance
                                  .collection("stores")
                                  .doc(value.docs[0].id)
                                  .delete()
                                  .then((value) {
                                print("deleted store ---- ${userEmailIndex}");
                              });
                            }
                          });
                        });
                      });
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text("Remove Store and Users"),
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
