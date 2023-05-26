import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe/constants/colors.dart';
import 'package:tic_tac_toe/widgets/game_tile.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  var displayXO = ['', '', '', '', '', '', '', '', ''];
  var oTurn = true;
  String? currentWinner;
  var oScore = 0;
  var xScore = 0;
  var totalAttempts = 0;
  var isGameRunning = false;
  List<List<int>>? winningIndexes;

  var customFontWhite = GoogleFonts.coiny(
    textStyle: const TextStyle(
      color: Colors.white,
      letterSpacing: 3,
      fontSize: 28,
    ),
  );

  void _clearBoard() {
    setState(() {
      displayXO = ['', '', '', '', '', '', '', '', ''];
      oTurn = true;
      currentWinner = null;
      isGameRunning = true;
      winningIndexes?.clear();
    });
  }

  void _onTapped(int index) {
    if (!isGameRunning || currentWinner != null || displayXO[index] != "") {
      return;
    }
    setState(() {
      displayXO[index] = oTurn ? "O" : "X";
      oTurn = !oTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    var zero = displayXO[0];
    var one = displayXO[1];
    var two = displayXO[2];
    var three = displayXO[3];
    var four = displayXO[4];
    var five = displayXO[5];
    var six = displayXO[6];
    var seven = displayXO[7];
    var eight = displayXO[8];

    List<List<int>> matchingIndexes = [];

    String? winner;
    // 1st Row
    if (zero != '') {
      if (zero == one && one == two) {
        winner = zero;
        matchingIndexes.add([0, 1, 2]);
      }
    }

    // 2nd Row
    if (three != '') {
      if (three == four && four == five) {
        winner = three;
        matchingIndexes.add([3, 4, 5]);
      }
    }

    // 3rd Row
    if (six != '') {
      if (six == seven && seven == eight) {
        winner = six;
        matchingIndexes.add([6, 7, 8]);
      }
    }

    // 1st Column
    if (zero != '') {
      if (zero == three && three == six) {
        winner = zero;
        matchingIndexes.add([0, 3, 6]);
      }
    }

    // 2nd Column
    if (one != '') {
      if (one == four && four == seven) {
        winner = one;
        matchingIndexes.add([1, 4, 7]);
      }
    }

    // 3rd Column
    if (two != '') {
      if (two == five && five == eight) {
        winner = two;
        matchingIndexes.add([2, 5, 8]);
      }
    }

    // 1st Cross
    if (zero != '') {
      if (zero == four && four == eight) {
        winner = zero;
        matchingIndexes.add([0, 4, 8]);
      }
    }

    // 2nd Cross
    if (two != '') {
      if (two == four && four == six) {
        winner = two;
        matchingIndexes.add([2, 4, 6]);
      }
    }

    if (winner != null && matchingIndexes.isNotEmpty) {
      setState(() {
        currentWinner = winner;
        winner == "X" ? xScore++ : oScore++;
        totalAttempts += 1;
        isGameRunning = false;
        winningIndexes = matchingIndexes;
      });
    }
    _checkForDraw();
  }

  void _checkForDraw() {
    var filledElements = displayXO.toList();
    filledElements.removeWhere((element) => element == "");
    if (currentWinner == null && filledElements.length == 9) {
      setState(() {
        currentWinner = "Draw";
        totalAttempts += 1;
        isGameRunning = false;
      });
    }
  }

  String? _getResultDeclaration() {
    if (currentWinner != null) {
      if (currentWinner == "Draw") {
        return "Gamw Draw";
      }
      return "$currentWinner won the game!";
    }
    return null;
  }

  Widget _getPlayWidget() {
    if (isGameRunning) {
      return Text("Game in progress", style: customFontWhite);
    }

    return TextButton(
      onPressed: _clearBoard,
      child: Text(
        totalAttempts == 0 ? "Play" : "Play Again",
        style: customFontWhite.copyWith(
          color: MainColor.secondaryColor,
          fontSize: 50,
        ),
      ),
    );
  }

  bool _checkIsWinIndex(int index) {
    var allWinIndexes = winningIndexes?.expand((v) => v).toList();
    return allWinIndexes?.contains(index) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(children: [
              Expanded(
                flex: 3,
                child: Column(children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Player O",
                              style: customFontWhite,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "$oScore",
                              style: customFontWhite.copyWith(fontSize: 40),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(width: 30),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Player X",
                              style: customFontWhite,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "$xScore",
                              style: customFontWhite.copyWith(fontSize: 40),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ]),
              ),
              Expanded(
                flex: 12,
                child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _onTapped(index),
                      child: GameTile(
                        value: displayXO[index],
                        isWinTile: _checkIsWinIndex(index),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_getResultDeclaration() ?? "",
                          style: customFontWhite),
                      const SizedBox(height: 20),
                      _getPlayWidget(),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
