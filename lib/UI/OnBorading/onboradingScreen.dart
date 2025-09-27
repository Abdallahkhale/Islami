import 'package:flutter/material.dart';
import 'package:islami/Core/Assets/Colors.dart';
import 'package:islami/Core/Assets/ImagesPath.dart';
import 'package:islami/Core/Services/LocalStorage.dart';
import 'package:islami/Core/Services/localStorageKeys.dart';
import 'package:islami/UI/OnBorading/customOnborading.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboradingscreen extends StatelessWidget {
  Onboradingscreen({super.key});
  final Controller = PageController();
  
  void dispose() {
    Controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: 80.0, 
        ),
        child: PageView(
          controller: Controller,
          children: [
            Customonborading(title: 'Welcome To Islmi App', subtitle: '', imgpath: ImagesPath.onb1,),
            Customonborading(title: 'Welcome To Islmi App', subtitle: 'We Are Very Excited To Have You In Our Community', imgpath: ImagesPath.onb2,),
            Customonborading(title: 'Reading the Quran', subtitle: 'Read, and your Lord is the Most Generous', imgpath: ImagesPath.onb3,),
            Customonborading(title: 'Bearish', subtitle: 'Praise the name of your Lord, the Most High', imgpath: ImagesPath.onb4,),
           
          ],
        ),
      ),
      bottomSheet: Container(
        color: ColorsApp.primaryColor,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: ColorsApp.gold, // Text color
              ),
              onPressed: () {
               
                  Controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
              
              },
              child: const Text('back'),
            ),
            SmoothPageIndicator(
              count: 4,
              controller: Controller,
              onDotClicked: (index) {
                Controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              effect: const ExpandingDotsEffect(
                dotHeight: 8.0,
                dotWidth: 8.0,
                activeDotColor: ColorsApp.gold,
                dotColor: Colors.grey,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: ColorsApp.gold, // Text color
              ),
              onPressed: () {
                if (Controller.page?.toInt() == 3) {

                 LocalStorage.setBool(Localstoragekeys.onboardingCmpleted, true);
                  Navigator.pushReplacementNamed(context, '/home');
                
                } else {
                  Controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } 
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}