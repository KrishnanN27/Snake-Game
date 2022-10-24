import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake/pages/blank_pixel.dart';
import 'package:snake/pages/food_pixel.dart';
import 'package:snake/pages/highscore_tile.dart';
import 'package:snake/pages/snake_pixel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final nameController = TextEditingController();

  //grid dimensions

  int rowSize = 10, totalNoOfSquares = 100;

  //snake position
  List<int> snakePosition = [0, 1, 2];

  //food location
  int foodPosition = 55;

  //highscore list
  List<String> highscoreListId = [];
  late final Future? letGetDocIds;

  static var myFont = GoogleFonts.pressStart2p(
      textStyle: TextStyle(color: Colors.black, letterSpacing: 3));

  //snake direction is intially to the right
  var currentDirection = snakeDirection.RIGHT;


  //game over
  bool gameOver() {
    // the game is over when the snake runs into itself
    List<int> bodySnake = snakePosition.sublist(0, snakePosition.length - 1);
    if (bodySnake.contains(snakePosition.last)) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    letGetDocIds = getDocId();
    // TODO: implement initState
    super.initState();
  }

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection("highscores")
        .orderBy('score', descending: true)
        .limit(5)
        .get()
        .then((value) => value.docs.forEach((element) {
              highscoreListId.add(element.reference.id);
            }));
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
                        controller: nameController,
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

  Future newGame() async{
    highscoreListId = [];
    await getDocId();
    setState(() {
      snakePosition = [0, 1, 2];
      foodPosition = 55;
      currentDirection = snakeDirection.RIGHT;
      gameHasStarted = false;
      currentScore = 0;
    });
  }

  void submitScore() {
    //get access to collectionm
    var database = FirebaseFirestore.instance;

    //add data to firebase
    database.collection('highscores').add({
      "name": nameController.text,
      "score": currentScore,
    });
  }

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
     var myFont = GoogleFonts.pressStart2p(
        textStyle: TextStyle(color: Colors.black, letterSpacing: 3));

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event){
          if(event.isKeyPressed(LogicalKeyboardKey.arrowDown)){
            currentDirection = snakeDirection.DOWN;
          }else if(event.isKeyPressed(LogicalKeyboardKey.arrowUp) ){
            currentDirection = snakeDirection.UP;
          }else if(event.isKeyPressed(LogicalKeyboardKey.arrowRight ) ){
            currentDirection = snakeDirection.RIGHT;
          }else if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)){
            currentDirection = snakeDirection.LEFT;
          }

        },
        child: Center(
          child: SizedBox(
            width: screenWidth > 428 ? 428 : screenWidth,
            child: Center(
              child: Padding(
                padding:  const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //highscores
                  children: [
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //user current score
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Current Score',
                                style:
                                    myFont.copyWith(color: Colors.grey, fontSize: 10),
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
                        ),
                        SizedBox(width: 12,),
                        Expanded(
                          child:
                              Padding(
                                padding: const EdgeInsets.all(13.0),
                                child: gameHasStarted
                                    ? Container()
                                    : FutureBuilder(
                                    future: letGetDocIds,
                                    builder: (context, snapshot) {
                                      return ListView.builder(
                                          itemCount: highscoreListId.length,
                                          itemBuilder: (context, index) {
                                            return HighScoreTile(
                                                documentId: highscoreListId[index]);
                                          });
                                    }),
                              ),

                        ),
                        //high score,top 5

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
                    screenWidth > 428 ?  Text('You can also use your arrow keys to play',style: myFont.copyWith(color: Colors.grey,letterSpacing: 2,fontSize: 8)): Container(),
                    // Text('@CREATEDBYKRISHNA',style: myFont,),
                    SizedBox(height: 24,),
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
                            padding: EdgeInsets.all(20),
                            color: gameHasStarted ? Colors.grey[700] : Colors.grey,
                            child: Center(
                              child: Text(
                                'START GAME',
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
            ),
          ),
        ),
      ),
    );
  }
}
