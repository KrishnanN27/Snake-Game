import 'dart:async';

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

  //startGame
  void startGame() {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();
      });
    });
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

          snakePosition.removeAt(0);
        }
        break;
      case snakeDirection.LEFT:
        {
          if (snakePosition.last % rowSize == 0) {
            snakePosition.add(snakePosition.last - 1 + rowSize);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }

          snakePosition.removeAt(0);
        }
        break;
      case snakeDirection.UP:
        {
          if (snakePosition.last < rowSize) {
            snakePosition.add(snakePosition.last - rowSize + totalNoOfSquares);
          } else {
            snakePosition.add(snakePosition.last - rowSize);
          }
          snakePosition.removeAt(0);
        }
        break;
      case snakeDirection.DOWN:
        {
          if (snakePosition.last + rowSize > totalNoOfSquares) {
            snakePosition.add(snakePosition.last + rowSize - totalNoOfSquares);
          } else {
            snakePosition.add(snakePosition.last + rowSize);
          }
          snakePosition.removeAt(0);
        }
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Column(
        //highscores
        children: [
          Expanded(child: Container()),
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
              startGame();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 70, right: 70, bottom: 80),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.all(30),
                  color: Colors.grey,
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
    );
  }
}
