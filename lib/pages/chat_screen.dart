import 'package:chat_app/models/message.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/shared/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  ChatPage(
      {Key? key,
      required this.currentUserUsername,
      required this.secondUserUsername})
      : super(key: key);

  static const routeName = "Chat Page";

  String currentUserUsername;
  String secondUserUsername;
  String documentName = "";

  CollectionReference chats = FirebaseFirestore.instance.collection('Chats');

  // late Future<DocumentReference<Map<String, dynamic>>>
  //     messages; //=FirebaseFirestore.instance.collection('Chats').doc("$currentUserUsername VS $secondUserUsername");
  // CollectionReference messages =
  //     FirebaseFirestore.instance.collection(kMessagesCollections);

  TextEditingController controller = TextEditingController();

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    // String email = ModalRoute.of(context)!.settings.arguments as String;

    // messages = FirebaseFirestore.instance
    //     .collection('Chats').doc("$currentUserUsername VS $secondUserUsername").add();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kLogo,
              height: 40,
            ),
            const SizedBox(width: 5),
            const Text("Chat"),
          ],
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: chats.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Map> messagesList = [];
              // print(snapshot.data!.docs[0].id);
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                if (snapshot.data!.docs[i].id ==
                    "$currentUserUsername VS $secondUserUsername") {
                  // print(snapshot.data!.docs[i].data());
                  documentName = "$currentUserUsername VS $secondUserUsername";
                  dynamic data = snapshot.data!.docs[i].data();
                  // (data ?? {}).sort();
                  (data ?? {}).forEach((key, value) {
                    messagesList.add({
                      "message": value["message"],
                      "sender": value["sender"],
                      "date": DateTime.parse(key),
                    });
                  });

                  break;
                } else if (snapshot.data!.docs[i].id ==
                    "$secondUserUsername VS $currentUserUsername") {
                  documentName = "$secondUserUsername VS $currentUserUsername";
                  dynamic data = snapshot.data!.docs[i].data();
                  (data ?? {}).forEach((key, value) {
                    messagesList.add({
                      "message": value["message"],
                      "sender": value["sender"],
                      "date": DateTime.parse(key),
                    });
                  });

                  break;
                }
              }

              if (documentName.isEmpty) {
                documentName = "$currentUserUsername VS $secondUserUsername";
              }

              messagesList.sort((a, b) => (b["date"]).compareTo(a["date"]));

              // for (int i = 0; i < messagesList.length; i++) {
              //   print(messagesList[i]);
              // }
              // print(snapshot.data!.docs[0][kMessage]);
              return Column(
                children: [
                  Expanded(
                      child: messagesList.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              controller: _controller,
                              reverse: true,
                              itemCount: messagesList.length,
                              itemBuilder: (BuildContext context, int index) {
                                // return SizedBox();
                                print(messagesList[index]["sender"]);
                                return chatBubble(
                                    message: messagesList[index]["message"],
                                    date: messagesList[index]["date"]
                                        .toString()
                                        .substring(0, 16),
                                    isSender: messagesList[index]["sender"] ==
                                        currentUserUsername);
                              })
                          : Container(
                              height: 500,
                            )),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: controller,
                      onSubmitted: (String message) {
                        FirebaseFirestore.instance.collection('Chats');
                        chats.doc(documentName).set({
                          DateTime.now().toString(): {
                            "message": message,
                            "sender": currentUserUsername,
                          }
                        }, SetOptions(merge: true));

                        controller.clear();
                        // _controller.animateTo(
                        //     _controller.position.maxScrollExtent,
                        //     duration: const Duration(seconds: 1),
                        //     curve: Curves.fastOutSlowIn);
                        _controller
                            .jumpTo(_controller.position.maxScrollExtent);
                      },
                      decoration: InputDecoration(
                        hintText: "Send Message",
                        suffixIcon: const Icon(
                          Icons.send,
                          color: kPrimaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
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
