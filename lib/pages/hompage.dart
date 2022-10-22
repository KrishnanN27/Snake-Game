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

class _HomePageState extends State<HomePage> {
  //grid dimensions

  int rowSize = 10, totalNoOfSquares = 0;

  //snake position
  List<int> snakePosition = [0, 1, 2];

  //food location
  int foodPosition = 55;
  static var myFont = GoogleFonts.pressStart2p(textStyle: TextStyle(color: Colors.black,letterSpacing: 3));

  //startGame
  void startGame(){
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        //add a new head and remove the tail



      });
    });
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
              child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 100,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10),
                  itemBuilder: (context, index) {
                   if(snakePosition.contains(index)){
                     return SnakePixel();
                   }
                   else if(foodPosition == index){
                     return FoodPixel();
                   }
                   else{
                     return const BlankPixel();
                   }
                  })),
          Expanded(child: GestureDetector(
            onTap: (){

            },
            child: Padding(
              padding: EdgeInsets.only(left: 70,right: 70,bottom: 80),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.all(30),
                  color: Colors.grey,
                  child: Center(
                    child: Text('PLAY GAME',style: myFont.copyWith(fontSize: 10,),),
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
