import 'package:flutter/material.dart';
import 'package:tic_tac_toe/tictactoe_page.dart' show TicTacToePage;

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
      ),
      home: const TicTacToePage(),
    ),
  );
}
