import 'package:chat_app/pages/chat_screen.dart';
import 'package:chat_app/pages/login_screen.dart';
import 'package:chat_app/pages/users_screen.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/shared/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static const routeName = "RegisterPage";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email, password, username;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 150),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const Spacer(flex: 2),
                    Image.asset(
                      'assets/images/icon.png',
                    ),
                    const Text(
                      'Chat with me',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontFamily: 'pacifico',
                      ),
                    ),
                    // const Spacer(flex: 2),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontFamily: 'pacifico',
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    customTextFormField(
                        onChanged: (String data) {
                          username = data;
                        },
                        hintText: 'Username'),
                    const SizedBox(height: 20),
                    customTextFormField(
                        onChanged: (String data) {
                          email = data;
                        },
                        hintText: 'Email'),
                    const SizedBox(height: 15),
                    customTextFormField(
                        onChanged: (String data) {
                          password = data;
                        },
                        hintText: 'Password'),
                    const SizedBox(height: 20),

                    customButton(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            isLoading = true;
                            setState(() {});
                            try {
                              await registerUser();

                              showSnackBar(context, 'Email Added');
                              Navigator.pushReplacementNamed(
                                  context, UsersScreen.routeName,
                                  arguments: email);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'Weak Password') {
                                showSnackBar(context, 'Weak Password');
                              } else if (e.code == 'email-already-in-use') {
                                showSnackBar(context, 'Email already exist');
                              }
                            } catch (e) {
                              showSnackBar(context, "There was an error");
                            }
                            isLoading = false;
                            setState(() {});
                          }
                        },
                        text: "Register"),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "already have an account? ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, LoginPage.routeName);
                          },
                          child: const Text(
                            ' Login',
                            style: TextStyle(
                              color: Color(0xffC7EDE6),
                            ),
                          ),
                        )
                      ],
                    ),
                    // const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> registerUser() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
    await userSetup(username: username, password: password, email: email);
  }

  Future<void> userSetup(
      {required String? username,
      required String? password,
      required String? email}) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');

      users.add({
        "username": username,
        "email": email,
        'password': password,
      });

      // //firebase auth instance to get uuid of user
      // FirebaseAuth auth = FirebaseAuth.instance.currentUser! as FirebaseAuth;
      //
      // //now below I am getting an instance of firebaseiestore then getting the user collection
      // //now I am creating the document if not already exist and setting the data.
      // await FirebaseFirestore.instance
      //     .collection('Users')
      //     .doc(auth.currentUser!.uid)
      //     .set({
      //   'username': username,
      //   'password': password,
      //   "email": email,
      // });
    } catch (e) {
      print(e);
    }
    return;
  }
}
