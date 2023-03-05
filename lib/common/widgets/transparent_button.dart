import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;

  final String text;
  final Color textColor;
  const TransparentButton(
      {Key? key,
      required this.backgroundColor,
      required this.text,
      required this.textColor,
      this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0.0),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
            ),
          ),
          width: 250,
          height: 35,
        ),
      ),
    );
  }
}
