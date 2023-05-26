import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe/constants/colors.dart';

class GameTile extends StatelessWidget {
  GameTile({
    super.key,
    required this.value,
    required this.isWinTile,
  });

  String value;
  bool isWinTile;

  List<BoxShadow> _getBoxShadow() {
    if (!isWinTile) return [];
    var bs = const BoxShadow(
      color: Colors.black, //New
      blurRadius: 12.0,
      offset: Offset(2, 2),
    );
    return [bs];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isWinTile ? MainColor.accentColor : MainColor.secondaryColor,
        boxShadow: _getBoxShadow(),
      ),
      child: Center(
        child: Text(
          value,
          style: GoogleFonts.coiny(
            textStyle: TextStyle(
              fontSize: 80,
              color: isWinTile ? Colors.white : MainColor.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
