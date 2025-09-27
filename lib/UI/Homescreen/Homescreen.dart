import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/Core/Assets/Colors.dart';
import 'package:islami/Core/Assets/icons.dart';
import 'package:islami/UI/Hadeeh/HadeehScreen.dart';
import 'package:islami/UI/Quran/Quran.Screen.dart';
import 'package:islami/UI/Radio/RadioScreen.dart';
import 'package:islami/UI/Sabeeh/sabeehScreen.dart';
import 'package:islami/UI/Time/TimeScreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const QurnScreen(),
    const Hadeehscreen(),
    const Sabeehscreen(),
    const Radioscreen(),
     Timescreen()

   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, 
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(IconsPath.hala)),
            label: 'Quran',
            activeIcon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(40),
              ),
              child: ImageIcon(AssetImage(IconsPath.hala))
            )
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(IconsPath.book)),
            label: 'Hadith',
            activeIcon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(40),
              ),
              child: ImageIcon(AssetImage(IconsPath.book))
            )
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(IconsPath.nec)),
            label: 'Sab7a',
            activeIcon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(40),
              ),
              child: ImageIcon(AssetImage(IconsPath.nec))
            )
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(IconsPath.radio)),
            label: 'Radio',
            activeIcon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(40),
              ),
              child: ImageIcon(AssetImage(IconsPath.radio))
            )
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(IconsPath.time)),
            label: 'Time',
            activeIcon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(40),
              ),
              child: ImageIcon(AssetImage(IconsPath.time))
            )
          ),
        ],
      ),
      body: _screens[_currentIndex], 
    );
  }
}