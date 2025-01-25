import 'package:flutter/material.dart';

class TextBubble extends StatelessWidget {
  final double borderRadiusAmt;
  final Color containerColor;
  final EdgeInsetsGeometry paddingInset;
  final Widget childWidget;

  const TextBubble({
    super.key,
    this.borderRadiusAmt = 15.0,
    this.containerColor = const Color(0xFFD2C3B3),
    this.paddingInset = const EdgeInsets.fromLTRB(10, 5, 10, 5),
    required this.childWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadiusAmt),
      child: Container(
          color: containerColor,
          child: Padding(
            padding: paddingInset,
            child: childWidget,
          )),
    );
  }
}
