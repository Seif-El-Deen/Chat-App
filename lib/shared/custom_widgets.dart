import 'package:chat_app/shared/constants.dart';
import 'package:flutter/material.dart';

Widget customTextFormField(
    {required Function(String)? onChanged, required String hintText}) {
  return TextFormField(
    validator: (data) {
      if (data!.isEmpty) {
        return 'Field is required';
      }
      return null;
    },
    onChanged: onChanged,
    obscureText: hintText == 'Password',
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget customButton({required VoidCallback onTap, required String text}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
      ),
    ),
  );
}

Widget chatBubble(
    {required String message, required bool isSender, required String date}) {
  return Align(
    alignment: !isSender ? Alignment.centerLeft : Alignment.centerRight,
    child: Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: !isSender ? kPrimaryColor : Colors.lightBlue[600],
        borderRadius: !isSender
            ? const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            date,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
