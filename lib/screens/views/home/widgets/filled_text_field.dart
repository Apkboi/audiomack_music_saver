import 'package:flutter/material.dart';
import 'package:myplayer/theme/app_theme.dart';

class FilledTextField extends StatelessWidget {
  const FilledTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration:AppTheme.inputDecoration(context).copyWith(labelStyle: const TextStyle(color: Colors.white)),
    );
  }
}
