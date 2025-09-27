import 'package:flutter/material.dart';

class Custombutton extends StatelessWidget {
   const Custombutton({super.key, required this.text, required this.color});
  final String text;
  final Color color;


  @override
  Widget build(BuildContext context) {
    return Container(

              padding: const EdgeInsets.symmetric(horizontal: 43, vertical: 15),
              decoration: BoxDecoration(
                
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
             );
  }
}