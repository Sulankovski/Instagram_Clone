import 'package:flutter/material.dart';

showSnackBar(String content, BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 900),
      backgroundColor: Colors.transparent,
      content: Container(
        alignment: Alignment.center,
        child: Text(
          content,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ), 
      ),   
    ),
  );
}