import 'package:flutter/material.dart';
import 'OurColors.dart';
import 'command.dart';

class RowButton extends StatefulWidget {
  final keyPost;

  RowButton({Key? key, required this.keyPost});
  @override
  RowButton_ createState() => RowButton_();
}

class RowButton_ extends State<RowButton> {
  int indexButton = 0;

  void changeButton(int index, String command) {
    setState(() {
      indexButton = index;
    });
    widget.keyPost.currentState!.changeClassement(command);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            style: indexButton == 0 ? styleButtonOn : styleButtonOff,
            child: Row(
              children: [Icon(Icons.local_fire_department), Text("Popular")],
            ),
            onPressed: () => changeButton(0, Command.popular)),
        ElevatedButton(
            style: indexButton == 1 ? styleButtonOn : styleButtonOff,
            child: Row(
              children: [Icon(Icons.new_releases), Text("New")],
            ),
            onPressed: () => changeButton(1, Command.myNew))
      ],
    );
  }
}
