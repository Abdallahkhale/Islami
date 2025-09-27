import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islami/Core/Assets/Colors.dart';
import 'package:islami/Core/Assets/icons.dart';
import 'package:islami/UI/Quran/SuraData.dart';

class Sura extends StatefulWidget {
  final SuraData suraData;
  final int index;

  const Sura({super.key, required this.suraData, required this.index});

  @override
  State<Sura> createState() => _SuraState();
}

class _SuraState extends State<Sura> {
  List<String> verses = [];

  @override
  void initState() {
    super.initState();
    loadSuraContent(widget.index + 1);
  }

  Future<void> loadSuraContent(int i) async {
    String content = await rootBundle.loadString('assets/Suras/$i.txt');

    setState(() {
      verses = content.split('\n').map((verse) => verse.trim()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.suraData.SuraNameEn,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: ColorsApp.gold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset(IconsPath.leftlogo, height: 90, width: 90),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Image.asset(IconsPath.rightlogo, height: 90, width: 90),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.suraData.SuraNameAr,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: ColorsApp.gold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: ListView.builder(
                itemCount: verses.length,
                itemBuilder: (context, index) {
                  
                  if (verses[index].isEmpty) {
                    return const SizedBox.shrink();
                  }
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: ColorsApp.gold,
                          fontSize: 20,
                        ),
                        children: [
                          if (index < verses.length - 1 )
                            TextSpan(text: '{${index + 1}} '),
                          TextSpan(text: verses[index]),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Image.asset(IconsPath.bottomlogo),
    );
  }
}