import 'package:flutter/material.dart';
import 'package:tic_tac_toe/tictactoe.dart';

enum TicTacToeMode {
  local('2 Players', Icons.people),
  computer('vs Computer', Icons.smart_toy);

  final String label;
  final IconData icon;
  const TicTacToeMode(this.label, this.icon);
}

class TicTacToePage extends StatefulWidget {
  const new({super.key});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  var mode = TicTacToeMode.local;
  var me = Mark.x;
  var game = TicTacToe.initial();
  var xWinCount = 0, oWinCount = 0, drawCount = 0;

  bool get botsTurn => mode == .computer && game.turn == me.other;

  void _tap(int i) {
    if (game.isOver || game.cells[i] != null || botsTurn) return;

    setState(() => game = game.play(i));

    if (game.isOver) {
      _finished();
      return;
    }

    if (botsTurn) {
      Future.delayed(const Duration(milliseconds: 350), () {
        if (!mounted || game.isOver) return;
        setState(() => game = game.play(bestMove(game)));
        if (game.isOver) _finished();
      });
    }
  }

  void _finished() => setState(() {
    if (game.winner == .x) xWinCount++;
    if (game.winner == .o) oWinCount++;
    if (game.isDraw) drawCount++;
  });

  void _newGame() => setState(() => _newGameImpl());

  void _newGameImpl() {
    game = TicTacToe.initial();
    if (botsTurn) game = game.play(bestMove(game));
  }

  void _setMode(TicTacToeMode m) => setState(() {
    mode = m;
    _newGameImpl();
    xWinCount = oWinCount = drawCount = 0;
  });

  void _setMe(Mark m) => setState(() {
    me = m;
    _newGameImpl();
    xWinCount = oWinCount = drawCount = 0;
  });

  String get status {
    final w = game.winner;
    if (mode == .computer) {
      if (w == me) return 'You win?! (that should be impossible)';
      if (w == me.other) return 'The computer wins';
      if (game.isDraw) return 'Draw — the best you can do';
      return botsTurn ? 'Computer is thinking…' : 'Your turn (${me.symbol})';
    }

    if (w != null) return 'Player ${w.symbol} wins!';
    if (game.isDraw) return 'Draw';
    return 'Player ${game.turn.symbol}\'s turn';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final line = game.winningLine ?? const [];

    final xName = mode == .computer && me == .x ? 'You' : Mark.x.symbol;
    final oName = mode == .computer && me == .x ? 'Computer' : Mark.o.symbol;

    return Scaffold(
      appBar: AppBar(title: const Text('Tic-Tac-Toe')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          SegmentedButton<TicTacToeMode>(
            segments: [
              for (final m in TicTacToeMode.values)
                ButtonSegment(
                  value: m,
                  label: Text(m.label),
                  icon: Icon(m.icon),
                ),
            ],
            selected: {mode},
            onSelectionChanged: (selections) => _setMode(selections.first),
          ),
          if (mode == .computer) ...[
            const SizedBox(height: 8),
            SegmentedButton<Mark>(
              segments: [
                for (final m in Mark.values)
                  ButtonSegment(value: m, label: Text(m.symbol)),
              ],
              selected: {me},
              onSelectionChanged: (selections) => _setMe(selections.first),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            '$xName $xWinCount  ·  Draws $drawCount  ·  $oName $oWinCount',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(status, style: Theme.of(context).textTheme.titleLarge),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.count(
                  crossAxisCount: 3,
                  padding: const EdgeInsets.all(16),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (var i = 0; i < 9; i++)
                      Material(
                        color: line.contains(i)
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _tap(i),
                          child: Center(
                            child: Text(
                              game.cells[i]?.symbol ?? '',
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: .bold,
                                color: game.cells[i] == .x
                                    ? colorScheme.primary
                                    : colorScheme.tertiary,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: FilledButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('New game'),
              onPressed: _newGame,
            ),
          ),
        ],
      ),
    );
  }
}
