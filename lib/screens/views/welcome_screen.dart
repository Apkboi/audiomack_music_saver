import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myplayer/screens/widgets/gradient_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();

  // late AnimationController    fadeInAnimationController = AnimationController(
  // duration: const Duration(seconds: 2),
  // vsync: this,
  // )..forward();

  // late final animationController = AnimationController(
  //   duration: const Duration(seconds: 10),
  //   vsync: this,
  //
  // );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0.0, 0.0),
    end: const Offset(0.0, 0.0),
  ).animate(CurvedAnimation(
    parent: animationController,
    curve: Curves.easeIn,
  ));
  ImageProvider backgroundImage =
      const AssetImage('assets/jpg/musiclistener.jpg');

  // late  Animation fadeInAnimation = Tween(
  //   begin: 0.0,
  //   end: 1.0,
  // ).animate(animationController);

  @override
  void initState() {
    log(animationController.isAnimating.toString());
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    // fadeInAnimationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: backgroundImage, fit: BoxFit.cover)),
        child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            Center(
              child: Column(
                children: [
                  SlideTransition(
                    position: _offsetAnimation,
                    child: Column(
                      children: [
                        const Text(
                          'A . U . D . I . O   S A V E',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Make your life more live',
                          style:
                              TextStyle(fontSize: 15, color: Colors.blueGrey),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Row(
                            children: const [
                              Expanded(
                                  child: Divider(
                                color: Colors.white,
                                thickness: 1,
                              )),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: Divider(
                                color: Colors.white,
                                thickness: 1,
                              )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // FadeTransition(
                  //   opacity: fadeInAnimationController,
                  //   child: const GradientButton(),
                  // ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaY: 18,
                      sigmaX: 15,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(18),
                      child: Column(
                        children: const [
                          Text(
                            'Lorem Ispeum Yea! 🤩 🤩',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to de ',
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 15),
                          ),
                          Align(
                            child: GradientButton(),
                            alignment: Alignment.bottomRight,
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
