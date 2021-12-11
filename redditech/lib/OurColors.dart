import 'package:flutter/material.dart';

List<Color> blues = [
  Color.fromARGB(255, 201, 240, 255),
  Color.fromARGB(255, 194, 238, 255),
  Color.fromARGB(255, 173, 232, 255),
];
List<Color> azure = [
  Color.fromARGB(255, 234, 255, 253),
  Color.fromARGB(255, 214, 255, 251),
  Color.fromARGB(255, 194, 255, 249),
];
List<Color> cultured = [
  Color.fromARGB(255, 239, 239, 240),
  Color.fromARGB(255, 234, 234, 235),
  Color.fromARGB(255, 224, 224, 225),
];
List<Color> languid = [
  Color.fromARGB(255, 213, 202, 214),
  Color.fromARGB(255, 210, 197, 211),
  Color.fromARGB(255, 201, 185, 202),
];
List<Color> taupe = [
  Color.fromARGB(255, 107, 94, 98),
  Color.fromARGB(255, 97, 86, 90),
  Color.fromARGB(255, 86, 77, 80),
];

ButtonStyle styleButtonOn = ElevatedButton.styleFrom(
    primary: languid[0],
    onSurface: blues[0],
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))));

ButtonStyle styleButtonOff = ElevatedButton.styleFrom(
    primary: taupe[2],
    onSurface: languid[0],
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))));
