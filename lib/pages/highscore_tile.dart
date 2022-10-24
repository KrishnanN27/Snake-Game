import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HighScoreTile extends StatelessWidget {
  final String documentId;

  const HighScoreTile({Key? key,required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

     var myFont = GoogleFonts.pressStart2p(
        textStyle: TextStyle(color: Colors.black, letterSpacing: 3));

    //get the collection of highscores
    CollectionReference highScores = FirebaseFirestore.instance.collection('highscores');

    return FutureBuilder<DocumentSnapshot>(
      future: highScores.doc(documentId).get(),
        builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          Map<String,dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          
          return Column(
            children: [

              SizedBox(height: 8,),

              Row(
                children: [
                  Text(data['name'],style: myFont.copyWith(color: Colors.grey,fontSize: 10),),
                  SizedBox(width: 10,),
                  Text(data['score'].toString(),style: myFont.copyWith(color: Colors.grey,fontSize: 10),),

                ],),
            ],
          );
        }
        else{
          return Text('loading',style: myFont.copyWith(color: Colors.grey,fontSize: 10),);
        }
        });
  }
}
