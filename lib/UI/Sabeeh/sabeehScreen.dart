import 'package:flutter/material.dart';
import 'package:islami/Core/Assets/ImagesPath.dart';

class Sabeehscreen extends StatefulWidget {
  const Sabeehscreen({super.key});

  @override
  State<Sabeehscreen> createState() => _SabeehscreenState();
}

class _SabeehscreenState extends State<Sabeehscreen> {
  int counter = 0;
  List<String> tasbeehList = [
    'سبحان الله',
    'الحمد لله',
    'الله أكبر',
  ];
  void initState() {
    super.initState();
    counter = 0; 
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagesPath.tasbeehShadow),
          fit: BoxFit.fill,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
             counter++;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              ImagesPath.logo,
              height: 171,
              width: 290,
            ),
            const SizedBox(height: 20),
            Text(
              'سَبِّحِ اسْمَ رَبِّكَ الأعلى ',
              textAlign: TextAlign.center,
              
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              children:[ 
                RotatedBox(
                quarterTurns: counter % 5,
                child: Image.asset(
                  ImagesPath.sebahaBodynew,
              
                  height: 280,
                  width: 270,
                ),
              ),
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                bottom: 0,
                child: Text(
                  tasbeehList[(counter ~/ 34) % 3],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
                 Positioned(
                top: 170,
                left: 0,
                right: 0,
                bottom: 0,
                child: Text(
                  '${counter%34}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
              ),
              ]
            )
          ],
        ),
      ),
    )
    );
  }
}