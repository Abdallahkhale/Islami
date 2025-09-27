import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islami/Core/Assets/Colors.dart';
import 'package:islami/Core/Assets/ImagesPath.dart';
import 'package:islami/Core/Assets/icons.dart';

class Hadeehscreen extends StatefulWidget {
  const Hadeehscreen({super.key});

  @override
  State<Hadeehscreen> createState() => _HadeehscreenState();
}

class _HadeehscreenState extends State<Hadeehscreen> {
  List<List<String>> allHadeeth = []; 
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAllHadeeth();
  }

  Future<void> loadAllHadeeth() async {
    List<List<String>> loadedHadeeth = [];
    
    for (int i = 1; i <= 50; i++) {
      try {
        String content = await rootBundle.loadString('assets/Hadeeth/h$i.txt');
        List<String> hadeethLines = content.split('\n').where((line) => line.trim().isNotEmpty).toList();
        if (hadeethLines.isNotEmpty) {
          loadedHadeeth.add(hadeethLines);
        }
      } catch (e) {
        break;
      }
    }
    
    setState(() {
      allHadeeth = loadedHadeeth;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagesPath.hadeehshadow),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            ImagesPath.logo,
            width: 200,
            height: 129,
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : CarouselSlider(
                    options: CarouselOptions(
                      height: double.infinity,
                      autoPlay: false,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      viewportFraction: 0.85,
                    ),
                    items: allHadeeth.map((hadeeth) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Container(
                        
                        decoration: const BoxDecoration(
                          
                        color: ColorsApp.gold,
                          image: DecorationImage(
                            image: AssetImage(ImagesPath.logosura ),
                            fit: BoxFit.fill,
                            opacity: 0.25,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Image.asset(IconsPath.leftlogo, height: 90, width: 90 , color: ColorsApp.black,),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Image.asset(IconsPath.rightlogo, height: 90, width: 90, color: ColorsApp.black),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                              child: ListView.builder(
                                itemCount: hadeeth.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        hadeeth[index],
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: ColorsApp.black,
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                             Positioned(
                             
                              bottom: 0,
                              child: Image.asset(IconsPath.bottomlogo, color: ColorsApp.black,
                                height: 90,
                              
                              ),
                            ),
                          ],
                        ),
                      ),
                    )).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}