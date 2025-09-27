import 'package:flutter/material.dart';
import 'package:islami/Core/Assets/Colors.dart';
import 'package:islami/Core/Assets/ImagesPath.dart';
import 'package:islami/UI/Quran/SuraData.dart';

class Recantlycardsura extends StatefulWidget {
   const Recantlycardsura({super.key, required this.surasMostRecentlist});
  final SuraData surasMostRecentlist;

  @override
  State<Recantlycardsura> createState() => _RecantlycardsuraState();
}

class _RecantlycardsuraState extends State<Recantlycardsura> {
  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);
    return Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 285,
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                    color: ColorsApp.gold,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        
                        children: [
                          Text(
                            '${widget.surasMostRecentlist.SuraNameEn}',
                            style: theme.textTheme.bodyLarge
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${widget.surasMostRecentlist.SuraNameAr}',
                            style: theme.textTheme.bodyLarge
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${widget.surasMostRecentlist.verses}',
                            style: theme.textTheme.bodyMedium
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                       
                          child: Image.asset(
                            ImagesPath.logosura,
                          
                          ),
                        ),
                      
                    ],
                  ),
                 
                 
                );
  }
}