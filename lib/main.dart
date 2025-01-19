import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(TicTacToeApp());

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<String> board = List.filled(9, "");
  bool isPlayerOne = true;
  bool gameOver = false;
  bool ninjaMode = false;
  int moves = 0;

  final possibilities = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  void resetBoard() {
    setState(() {
      board = List.filled(9, "");
      isPlayerOne = true;
      gameOver = false;
      moves = 0;
    });
  }

  void toggleNinjaMode() {
    setState(() {
      if (moves == 0) ninjaMode = !ninjaMode;
    });
  }

  String getRandomEmoji() {
    const emojis = [
      "💔", "🐢", "🦚", "🍞", "☕", "🏀", "🎰", "☢️", "♻️", "☮︎", "☯︎", "🇧🇷"
    ];
    return emojis[Random().nextInt(emojis.length)];
  }

  void makeMove(int index) {
    if (board[index].isEmpty && !gameOver) {
      setState(() {
        board[index] = ninjaMode
            ? getRandomEmoji()
            : (isPlayerOne ? "🤠" : "🎃");
        isPlayerOne = !isPlayerOne;
        moves++;
        checkWinner();
      });
    }
  }

  void checkWinner() {
    for (var possibility in possibilities) {
      final a = possibility[0];
      final b = possibility[1];
      final c = possibility[2];
      if (board[a].isNotEmpty && board[a] == board[b] && board[a] == board[c]) {
        setState(() {
          gameOver = true;
        });
        return;
      }
    }
    if (moves == 9 && !gameOver) {
      setState(() {
        gameOver = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tic Tac Toe"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () => makeMove(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.purple.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              board[index],
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (gameOver)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          moves == 9 && !board.any((element) => element.isEmpty)
                              ? "It's a Draw!"
                              : "${isPlayerOne ? "🎃" : "🤠"} Wins!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: resetBoard,
                    child: Text("Reset"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: toggleNinjaMode,
                    child: Text("Ninja Mode"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
