import 'package:flutter/material.dart';
import 'package:sreach_gif/ui/home_page.dart';
void main (){
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(hintColor: Colors.white),
    debugShowCheckedModeBanner: false,
  ));
}