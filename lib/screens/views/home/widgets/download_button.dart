import 'package:flutter/material.dart';

class DownloadButton extends StatelessWidget {
  final Widget? icon;
  final VoidCallback? onPressed;

  const DownloadButton({Key? key, this.icon, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: const BorderSide(
            color: Colors.grey,
          ),
        ),
        onPressed: onPressed,
        child: icon == null
            ?  Icon(
                Icons.arrow_downward,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 16,
              )
            : icon!,
      ),
    );
  }
}
