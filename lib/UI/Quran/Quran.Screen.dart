import 'package:flutter/material.dart';
import 'package:islami/Core/Assets/Colors.dart';
import 'package:islami/Core/Assets/ImagesPath.dart';
import 'package:islami/Core/Assets/icons.dart';
import 'package:islami/Core/Services/LocalStorage.dart';
import 'package:islami/Core/Services/localStorageKeys.dart';
import 'package:islami/UI/Quran/RecantlyCardsura.dart';
import 'package:islami/UI/Quran/SuraData.dart';
import 'package:islami/UI/Quran/suralistwidget.dart';

class QurnScreen extends StatefulWidget {
  const QurnScreen({super.key});

  @override
  State<QurnScreen> createState() => _QurnScreenState();
}

class _QurnScreenState extends State<QurnScreen> {
  List<SuraData> suras = getSuras();
  List<SuraData> surasMostRecent = [];
  List<SuraData> surasList = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadRecentSuras();
  }

  void _loadRecentSuras() {
    final storedSuraList = LocalStorage.getStringList(Localstoragekeys.SuraList);
    if (storedSuraList != null) {
      setState(() {
        surasMostRecent = storedSuraList.map((e) {
          int index = int.parse(e);
          if (index >= 0 && index < suras.length) {
            return suras[index];
          }
          return null;
        }).where((sura) => sura != null).cast<SuraData>().toList();
      });
    } else {
      setState(() {
        surasMostRecent = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagesPath.quranShadow),
          fit: BoxFit.fill,
        ),
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              ImagesPath.logo,
              width: 300,
              height: 140,
              fit: BoxFit.fill,
            ),
            TextFormField(
              onChanged: (value) {
                searchQuery = value;
                searchQueryf(value);
              },
              style: const TextStyle(
                color: ColorsApp.gold,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                labelStyle: const TextStyle(
                  color: ColorsApp.gold,
                  fontSize: 16,
                ),
                hintText: 'Sura Name',
                hintStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ImageIcon(AssetImage(IconsPath.hala), color: Colors.white),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorsApp.gold),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorsApp.gold),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            if (searchQuery.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text('Suras List', style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 10),
              Suralistwidget(onSuraSelected: _loadRecentSuras, surasList: surasList),
            ] else ...[
              const SizedBox(height: 20),
              const Text('Most Recent', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 10),
              surasMostRecent.isEmpty
                  ? const Center(
                      child: Text(
                        'No recent suras',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  : SizedBox(
                      height: 155,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: surasMostRecent.length,
                        itemBuilder: (context, index) {
                          return Recantlycardsura(surasMostRecentlist: surasMostRecent[index]);
                        },
                        separatorBuilder: (context, index) => const SizedBox(width: 10),
                      ),
                    ),
              const SizedBox(height: 20),
              const Text('Suras List', style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 10),
              Suralistwidget(onSuraSelected: _loadRecentSuras, surasList: suras),
            ],
          ],
        ),
      ),
    );
  }

  void searchQueryf(String query) {
    setState(() {
      if (query.isEmpty) {
        surasList = [];
      } else {
        surasList = suras.where((sura) {
          return sura.SuraNameAr.toLowerCase().contains(query.toLowerCase()) ||
                 sura.SuraNameEn.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }
}