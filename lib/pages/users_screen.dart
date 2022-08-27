import 'package:chat_app/pages/chat_screen.dart';
import 'package:chat_app/pages/login_screen.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/shared/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  UsersScreen({Key? key}) : super(key: key);

  static const routeName = "Users Page";

  CollectionReference users = FirebaseFirestore.instance.collection("Users");

  String currentUserUsername = "";

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        // toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kLogo,
              height: 40,
            ),
            const SizedBox(width: 5),
            const Text("Users"),
          ],
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              showSnackBar(context, 'Sign Out');

              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.exit_to_app),
                Text("Sign Out"),
              ],
            ),
          ),
          // IconButton(
          //   onPressed: () async {
          //     await FirebaseAuth.instance.signOut();
          //   },
          //   icon: const Icon(Icons.exit_to_app),
          // ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: users.orderBy("username").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Map> usersData = [];
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                if (snapshot.data!.docs[i]["email"] == email) {
                  // print(email);
                  // snapshot.data!.docs.removeWhere((element) {
                  //   return element[email] == email;
                  //   // print(element.data());
                  //   // return true;
                  // });
                  currentUserUsername = snapshot.data!.docs[i]["username"];
                } else {
                  usersData.add({
                    "username": snapshot.data!.docs[i]["username"],
                    "email": snapshot.data!.docs[i]["email"]
                  });
                }
              }
              // print(snapshot.data!.docs[0][kMessage]);
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: usersData.isNotEmpty
                            ? ListView.separated(
                                shrinkWrap: true,
                                // controller: _controller,
                                // reverse: true,
                                itemCount: usersData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      child:
                                          Text(usersData[index]["username"][0]),
                                    ),
                                    title: Text(
                                      usersData[index]["username"],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      usersData[index]["email"],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                            currentUserUsername:
                                                currentUserUsername,
                                            secondUserUsername: usersData[index]
                                                ["username"],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider(
                                    thickness: 2,
                                  );
                                },
                              )
                            : Container(
                                height: 500,
                              )),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
