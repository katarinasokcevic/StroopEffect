import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';
import '../models/game_model.dart';
import 'base_scaffold.dart';
import '../models/result_data.dart';

class GamePage extends StatefulWidget {
  final bool isCroatian;
  final bool isSecondRound;
  final ResultData resultData;

  const GamePage({
    Key? key,
    required this.isCroatian,
    required this.isSecondRound,
    required this.resultData,
  }) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late GameController _controller;
  late GameModel _model;

  @override
  void initState() {
    super.initState();
    _model = GameModel(
      isCroatian: widget.isCroatian,
      isSecondRound: widget.isSecondRound,
      resultData: widget.resultData,
    );
    _controller = GameController(
      gameModel: _model,
      updateState: () => setState(() {}),
    );
    _controller.startGame();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              "The game Stroop effect",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _model.currentWord,
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: _model.wordColor,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _model.colors
                    .take(2)
                    .map((color) => Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _controller.handleAnswer(color, context);
                    },
                    child: Container(height: 70),
                  ),
                ))
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _model.colors
                    .skip(2)
                    .take(2)
                    .map((color) => Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _controller.handleAnswer(color, context);
                    },
                    child: Container(height: 70),
                  ),
                ))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
