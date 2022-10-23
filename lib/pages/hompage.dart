import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake/pages/blank_pixel.dart';
import 'package:snake/pages/food_pixel.dart';
import 'package:snake/pages/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

//snake direction
enum snakeDirection { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  //userScore
  int currentScore = 0;

  bool gameHasStarted = false;

  //grid dimensions

  int rowSize = 10, totalNoOfSquares = 100;

  //snake position
  List<int> snakePosition = [0, 1, 2];

  //food location
  int foodPosition = 55;
  static var myFont = GoogleFonts.pressStart2p(
      textStyle: TextStyle(color: Colors.black, letterSpacing: 3));

  //snake direction is intially to the right
  var currentDirection = snakeDirection.RIGHT;

  //game over
  bool gameOver() {
    // the game is over when the snake runs into itself
    List<int> bodySnake = snakePosition.sublist(0, snakePosition.length -1);
    if (bodySnake.contains(snakePosition.last )) {
      return true;
    }
    return false;
  }

  //startGame
  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        //snake moving
        moveSnake();

        if (gameOver()) {
          //displaying message to the user
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text('Game Over'),
                  content: Column(
                    children: [
                      Text('Your score is:' + currentScore.toString()),
                      TextField(
                        decoration: InputDecoration(hintText: "Enter Name"),
                      )
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        submitScore();
                        Navigator.pop(context);
                        newGame();
                      },
                      child: Text('Submit'),
                    )
                  ],
                );
              });
          timer.cancel();
        }
      });
    });
  }

  void newGame() {
    setState(() {
      snakePosition = [0, 1, 2];
      foodPosition = 55;
      currentDirection = snakeDirection.RIGHT;
      gameHasStarted = false;
      currentScore = 0;
    });
  }

  void submitScore() {}

  void eatFood() {
    currentScore++;
    //maki
    while (snakePosition.contains(foodPosition)) {
      foodPosition = Random().nextInt(totalNoOfSquares);
    }
  }

  void moveSnake() {
    switch (currentDirection) {
      case snakeDirection.RIGHT:
        {
          if (snakePosition.last % rowSize == 9) {
            snakePosition.add(snakePosition.last + 1 - rowSize);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
        }
        break;
      case snakeDirection.LEFT:
        {
          if (snakePosition.last % rowSize == 0) {
            snakePosition.add(snakePosition.last - 1 + rowSize);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
        }
        break;
      case snakeDirection.UP:
        {
          if (snakePosition.last < rowSize) {
            snakePosition.add(snakePosition.last - rowSize + totalNoOfSquares);
          } else {
            snakePosition.add(snakePosition.last - rowSize);
          }
        }
        break;
      case snakeDirection.DOWN:
        {
          if (snakePosition.last + rowSize > totalNoOfSquares) {
            snakePosition.add(snakePosition.last + rowSize - totalNoOfSquares);
          } else {
            snakePosition.add(snakePosition.last + rowSize);
          }
        }
        break;
      default:
    }

    // snake is eating food
    if (snakePosition.last == foodPosition) {
      eatFood();
    } else {
      //remove tail
      snakePosition.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {

    //getting the screen width

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SizedBox(
        width: screenWidth > 428  ? 428 : screenWidth,
        child: Column(
          //highscores
          children: [
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //user current score
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Current Score',
                      style: myFont.copyWith(color: Colors.grey, fontSize: 10),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      currentScore.toString(),
                      style: myFont.copyWith(fontSize: 24),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'High Scores',
                      style: myFont.copyWith(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),

                //highscore,top 5
              ],
            )),
            Expanded(
                flex: 3,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy > 0 &&
                        currentDirection != snakeDirection.UP) {
                      // print('move up');
                      currentDirection = snakeDirection.DOWN;
                    } else if (details.delta.dy < 0 &&
                        currentDirection != snakeDirection.DOWN) {
                      // print('move down');
                      currentDirection = snakeDirection.UP;
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 0 &&
                        currentDirection != snakeDirection.LEFT) {
                      // print('move right');
                      currentDirection = snakeDirection.RIGHT;
                    } else if (details.delta.dx < 0 &&
                        currentDirection != snakeDirection.RIGHT) {
                      // print('move left');
                      currentDirection = snakeDirection.LEFT;
                    }
                  },
                  child: GridView.builder(
                      itemCount: 100,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10),
                      itemBuilder: (context, index) {
                        if (snakePosition.contains(index)) {
                          return SnakePixel();
                        } else if (foodPosition == index) {
                          return FoodPixel();
                        } else {
                          return const BlankPixel();
                        }
                      }),
                )),
            Expanded(
                child: GestureDetector(
              onTap: () {
                gameHasStarted ? () {} : startGame();
              },
              child: Padding(
                padding: EdgeInsets.only(left: 70, right: 70, bottom: 80),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(30),
                    color: gameHasStarted ? Colors.grey[700] : Colors.grey,
                    child: Center(
                      child: Text(
                        'PLAY GAME',
                        style: myFont.copyWith(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
          ],
          //grid
          //playbutton
        ),
      ),
    );
  }
}
