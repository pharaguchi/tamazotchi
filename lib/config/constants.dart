import 'package:flutter/material.dart';
import 'package:tamazotchi/config/color_constants.dart';

final textInputDecoration = InputDecoration(
  fillColor: Colors.grey,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  hintStyle: TextStyle(color: Colors.brown, fontSize: 14.0),
);

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
