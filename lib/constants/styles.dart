import 'package:flutter/material.dart';

InputDecoration kInputDecoration = InputDecoration(
  hintText: 'Enter the input name',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlue, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
