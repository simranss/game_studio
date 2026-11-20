enum Mark { x, o }

extension MarkX on Mark {
  Mark get other => this == .x ? .o : .x;

  String get symbol => this == .x ? 'X' : 'O';
}

class TicTacToe {
  final List<Mark?> cells;
  final Mark turn;

  const TicTacToe._(this.cells, this.turn);

  factory TicTacToe.initial() => TicTacToe._(List.filled(9, null), .x);

  static const List<List<int>> lines = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
    [0, 4, 8], [2, 4, 6], // diagonals
  ];

  Mark? get winner {
    for (final l in lines) {
      final a = cells[l[0]];
      if (a != null && a == cells[l[1]] && a == cells[l[2]]) return a;
    }

    return null;
  }

  List<int>? get winningLine {
    for (final l in lines) {
      final a = cells[l[0]];
      if (a != null && a == cells[l[1]] && a == cells[l[2]]) return l;
    }

    return null;
  }

  bool get isDraw => winner == null && cells.every((c) => c != null);
  bool get isOver => winner != null || isDraw;

  List<int> get emptyCells => [
    for (var i = 0; i < 9; i++)
      if (cells[i] == null) i,
  ];

  TicTacToe play(int index) {
    if (isOver || cells[index] != null) {
      throw StateError('Illegal move $index');
    }

    final next = List<Mark?>.of(cells)..[index] = turn;
    return TicTacToe._(next, turn.other);
  }
}

/// Minimax: try every move, assume the opponent also plays perfectly,
/// and pick the move with the best guaranteed outcome.
int bestMove(TicTacToe game) {
  final me = game.turn;
  var bestScore = -1000;
  var best = game.emptyCells.first;

  for (final move in game.emptyCells) {
    final score = _minimax(game.play(move), me, 1);

    if (score > bestScore) {
      bestScore = score;
      best = move;
    }
  }

  return best;
}

int _minimax(TicTacToe game, Mark me, int depth) {
  final w = game.winner;
  if (w == me) return 10 - depth;
  if (w != null) return depth - 10;

  if (game.isDraw) return 0;

  final scores = [
    for (final move in game.emptyCells)
      _minimax(game.play(move), me, depth + 1),
  ];

  final isMyTurn = game.turn == me;
  return isMyTurn
      ? scores.reduce((a, b) => a > b ? a : b)
      : scores.reduce((a, b) => a < b ? a : b);
}
