import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/tictactoe.dart';

void main() {
  test('detects a row win', () {
    var game = TicTacToe.initial();
    for (final move in [0, 3, 1, 4, 2]) {
      game = game.play(move);
    }

    expect(game.winner, Mark.x);
    expect(game.winningLine, [0, 1, 2]);
  });

  test('AI blocks an immediate threat', () {
    var game = TicTacToe.initial();
    for (final move in [0, 4, 1]) {
      game = game.play(move);
    }

    expect(bestMove(game), 2);
  });

  test('perfect play from both sides is a draw', () {
    var game = TicTacToe.initial();
    while (!game.isOver) {
      game = game.play(bestMove(game));
    }

    expect(game.isDraw, isTrue);
  });
}
