import 'package:flutter/material.dart';
import 'package:myplayer/screens/widgets/onboarding_item.dart';
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: PageView(children: const [
        OnboardingItem(text: Text(''), img: '', header: 'header'),
        OnboardingItem(text: Text(''), img: '', header: 'header')
      ]),
    );

  }
}
