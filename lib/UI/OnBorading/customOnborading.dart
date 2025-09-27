import 'package:flutter/material.dart';
import 'package:islami/Core/Assets/Colors.dart';
import 'package:islami/Core/Assets/ImagesPath.dart';

class Customonborading extends StatelessWidget {
  String imgpath;
  String title;
  String subtitle;
  Customonborading({super.key, required this.imgpath, required this.title, required this.subtitle });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(ImagesPath.logo, width: 300, height: 170),

        Center(
          child: Image.asset(
            imgpath,
            width: 290,
            height: 315,
          ),
        ),
         Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: ColorsApp.gold,
          ),
        ),
        const SizedBox(height: 10),
          Text(
            textAlign: TextAlign.center,
          subtitle,
          style: const TextStyle(
            
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorsApp.gold,
          ),
        ),
      ],
    );
  }
}