import 'package:flutter/material.dart';

class PlayButton extends StatefulWidget {
  final double size;
  final Widget icon ;
  final Color? color;
  final VoidCallback onPressed;

  const PlayButton({Key? key, required this.size, required this.icon, this.color, required this.onPressed}) : super(key: key);

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.onPressed();
      },
      child: Container(
        height: widget.size,
        width: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          gradient: widget.color == null ? const LinearGradient(
              colors: [Color(0xff3c5bf2), Color(0xff7e51f2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight):null,
          borderRadius: BorderRadius.circular(widget.size*0.5),
        ),
        child: Center(child: widget.icon),

      ),
    );
  }
}
