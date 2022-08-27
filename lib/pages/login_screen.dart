import 'package:chat_app/pages/chat_screen.dart';
import 'package:chat_app/pages/register_screen.dart';
import 'package:chat_app/pages/users_screen.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/shared/custom_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routeName = "LoginPage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? email, password, name;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
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
                        'Login',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontFamily: 'pacifico',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    customTextFormField(
                        onChanged: (String? data) {
                          email = data;
                        },
                        hintText: 'Email'),
                    const SizedBox(height: 15),
                    customTextFormField(
                        onChanged: (String? data) {
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
                              await loginUser();
                              showSnackBar(context, 'Login Successfull');
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
                        text: "Login"),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "don't have an account? ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, RegisterPage.routeName);
                          },
                          child: const Text(
                            ' Register',
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

  Future<void> loginUser() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
