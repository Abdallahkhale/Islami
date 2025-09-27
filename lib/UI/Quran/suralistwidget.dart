import 'package:flutter/material.dart';
import 'package:islami/Core/Assets/icons.dart';
import 'package:islami/Core/Services/LocalStorage.dart';
import 'package:islami/Core/Services/localStorageKeys.dart';
import 'package:islami/UI/Quran/SuraData.dart';

class Suralistwidget extends StatefulWidget {
  final VoidCallback? onSuraSelected;
  final List<SuraData> surasList;

  const Suralistwidget({
    super.key, 
    this.onSuraSelected, 
    required this.surasList,
  });

  @override
  State<Suralistwidget> createState() => _SuralistwidgetState();
}

class _SuralistwidgetState extends State<Suralistwidget> {
  List<String> suraIndexList = [];

  @override
  void initState() {
    super.initState();
    final storedList = LocalStorage.getStringList(Localstoragekeys.SuraList);
    if (storedList != null) {
      suraIndexList = List<String>.from(storedList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      itemCount: widget.surasList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => ontapSura(index, context),
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(IconsPath.suranumber),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                ),
              ),
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.surasList[index].SuraNameEn,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                  ),
                  Text(
                    '${widget.surasList[index].verses} verses',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                widget.surasList[index].SuraNameAr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        color: Colors.white,
        indent: 10,
        endIndent: 10,
      ),
    );
  }

  ontapSura(int index, BuildContext context) async {
    
    final selectedSura = widget.surasList[index];
    final actualIndex = _getActualSuraIndex(selectedSura);
    
    if (actualIndex != -1) {
      suraIndexList.removeWhere((element) => element == actualIndex.toString());
      suraIndexList.insert(0, actualIndex.toString());
      
      if (suraIndexList.length > 5) {
        suraIndexList = suraIndexList.take(5).toList();
      }
      
      await LocalStorage.setStringList(Localstoragekeys.SuraList, suraIndexList);
    }
    
    if (context.mounted) {
      await Navigator.pushNamed(
        context,
        '/sura',
        arguments: {
          'suraData': selectedSura,
          'index': actualIndex != -1 ? actualIndex : index,
        },
      );
      
      if (widget.onSuraSelected != null) {
        widget.onSuraSelected!();
      }
    }
  }

  int _getActualSuraIndex(SuraData sura) {

    final allSuras = getSuras(); 
    
    for (int i = 0; i < allSuras.length; i++) {
      if (allSuras[i].SuraNameEn == sura.SuraNameEn && 
          allSuras[i].SuraNameAr == sura.SuraNameAr) {
        return i;
      }
    }
    return -1; 
}
}