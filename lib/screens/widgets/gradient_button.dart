import 'package:flutter/material.dart';
import 'package:myplayer/screens/views/home/views/home_screen.dart';

class GradientButton extends StatefulWidget {
  const GradientButton({Key? key}) : super(key: key);

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: DecoratedBox(
        decoration:  BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xff3c5bf2), Color(0xff7e51f2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(25),
        ),
        child: TextButton(

          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen(),));
          },
          child: const Text(
            'Get Started',
            style: TextStyle(color: Colors.white),
          ),
          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 0)),
        ),
      ),
    );
  }
}
