import 'package:flutter/material.dart';
import 'package:tamazotchi/config/color_constants.dart';

final simpleInputDecoration = InputDecoration(
  filled: false,
  border: InputBorder.none,
  contentPadding: EdgeInsets.zero,
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
  ),
);
