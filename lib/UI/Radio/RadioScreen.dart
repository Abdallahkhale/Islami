import 'package:flutter/material.dart';
import 'package:islami/Core/Assets/Colors.dart';
import 'package:islami/Core/Assets/ImagesPath.dart';
import 'package:islami/UI/Quran/SuraData.dart';
import 'package:islami/UI/Radio/Customcard.dart';
import 'package:islami/UI/Radio/Model/radio_model.dart';
import 'package:islami/UI/Radio/Model/reciter_model.dart';
import 'package:islami/UI/Radio/Services/api_service.dart';
import 'package:islami/UI/Radio/custombutton.dart';

class Radioscreen extends StatefulWidget {
  const Radioscreen({super.key});

  @override
  State<Radioscreen> createState() => _RadioscreenState();
}

class _RadioscreenState extends State<Radioscreen> {
  bool isReciters = false;
  bool isRadio = true;
  bool isLoading = false;
    List<SuraData> suras = getSuras();

  
  List<RadioStation> radioStations = [];
  List<Reciter> reciters = [];
  String? error;

  @override
  void initState() {
    super.initState();
    loadRadios();
  }

  Future<void> loadRadios() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final radioResponse = await ApiService.getRadios();
      setState(() {
        radioStations = radioResponse.radios;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> loadReciters() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final reciterResponse = await ApiService.getReciters();
      setState(() {
        reciters = reciterResponse.reciters;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagesPath.Radioshadow),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Image.asset(ImagesPath.logo, height: 130, width: 220),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isRadio = true;
                      isReciters = false;
                    });
                    if (radioStations.isEmpty) {
                      loadRadios();
                    }
                  },
                  child: Custombutton(
                    text: 'Radio',
                    color: (isRadio ? ColorsApp.gold : ColorsApp.blacklight),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isReciters = true;
                      isRadio = false;
                    });
                    if (reciters.isEmpty) {
                      loadReciters();
                    }
                  },
                  child: Custombutton(
                    text: 'Reciters',
                    color: (isReciters ? ColorsApp.gold : ColorsApp.blacklight),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: ColorsApp.gold),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: $error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isRadio ? loadRadios : loadReciters,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (isRadio) {
      return ListView.separated(
        itemBuilder: (context, index) => Customcard(
          title: radioStations[index].name,
          audioUrl: radioStations[index].url,
          isRadio: true,
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: radioStations.length,
      );
    } else {
      List<SurahItem> allSurahs = [];
      for (Reciter reciter in reciters) {
        if (reciter.moshaf.isNotEmpty) {
          List<String> surahUrls = reciter.moshaf[0].getSurahUrls();
          for (int i = 0; i < surahUrls.length; i++) {
            allSurahs.add(SurahItem(
              reciterName: reciter.name,
              surahNumber: i + 1,
              audioUrl: surahUrls[i],
            ));
          }
        }
      }

      return ListView.separated(
        itemBuilder: (context, index) => Customcard(
          title: 'سورة ${ suras[allSurahs[index].surahNumber -1].SuraNameAr } - ${allSurahs[index].reciterName}',
          audioUrl: allSurahs[index].audioUrl,
          isRadio: false,
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: allSurahs.length,
      );
    }
  }
}