import 'package:flutter/material.dart';

class FoodPixel extends StatelessWidget {
  const FoodPixel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4)
        ),
        child: Image.asset("lib/images/a.jpg",fit: BoxFit.cover,width: 5,),
      ),
    );
  }
}
