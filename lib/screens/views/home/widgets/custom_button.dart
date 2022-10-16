import 'package:flutter/material.dart';

import '../views/home_screen.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({Key? key}) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xff3c5bf2), Color(0xff7e51f2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
          },
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
          style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0)),
        ),
      ),
    );
  }
}
