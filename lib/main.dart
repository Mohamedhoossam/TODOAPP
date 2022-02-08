import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:todo_app/modules/mainscreen/mainscreen.dart';

void main() {
  runApp(ToDo());
}
class ToDo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Widget splash = SplashScreenView(
      navigateRoute: MainScreen(),
      duration: 3000,
      imageSize: 130,
      imageSrc:"assets/images/icon2.jpg",
      text: "TODO",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: splash,

    );
  }
}



