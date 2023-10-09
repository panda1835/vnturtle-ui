import 'package:flutter/material.dart';
import 'package:vnturtle/widgets/conservation_status_text.dart';
import 'package:vnturtle/widgets/language_switch.dart';
import 'dart:convert';
import 'detailed_species_page.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThongTinLoaiPage extends StatefulWidget {
  @override
  _ThongTinLoaiPageState createState() => _ThongTinLoaiPageState();
}

class _ThongTinLoaiPageState extends State<ThongTinLoaiPage> {
  List<String> speciesNames = [];
  List<String> filteredSpeciesNames = [];
  Map<String, dynamic> speciesData = {};
  Map<String, dynamic> unsupportedSpeciesData = {};

  String currentLocale = '';

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  Future<Map<String, dynamic>> loadSpeciesData() async {
    String jsonString =
        await rootBundle.loadString('content/species_info.json');
    return jsonDecode(jsonString);
  }

  Future<Map<String, dynamic>> loadUnsupportedSpeciesData() async {
    String jsonString =
        await rootBundle.loadString('content/unsupported_species_info.json');
    return jsonDecode(jsonString);
  }


  void filterSpeciesList(String query) {
    setState(() {
      filteredSpeciesNames = speciesNames.where((name) {
        Map<String, dynamic> speciesInfo = speciesData[name];
        String nameVi = speciesInfo['primary_name'][currentLocale];
        String conservationStatus = speciesInfo['conservation_status']['iucn'];
        String nameEn = speciesInfo['secondary_name'][currentLocale];
        String nameSci = speciesInfo['scientific_name'];
        String otherName = speciesInfo['other_names'][currentLocale];
        String isNative = "";
        if (speciesInfo['native'] == "true"){
          isNative = AppLocalizations.of(context)!.native;
        } else {
          isNative = AppLocalizations.of(context)!.nonNative;
        }
        return nameVi.toLowerCase().contains(query.toLowerCase()) ||
            conservationStatus.toLowerCase().contains(query.toLowerCase()) ||
            nameSci.toLowerCase().contains(query.toLowerCase()) ||
            nameEn.toLowerCase().contains(query.toLowerCase()) ||
            isNative.toLowerCase().contains(query.toLowerCase()) ||
            otherName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void navigateToDetailPage(String speciesName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedSpeciesPage(speciesInfo: speciesData[speciesName],),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (currentLocale != Localizations.localeOf(context).languageCode){
      setState(() {
        currentLocale = Localizations.localeOf(context).languageCode;
      });
    
      loadUnsupportedSpeciesData().then((value) => setState(() {
        unsupportedSpeciesData = value;
      },));

      loadSpeciesData().then((value) => setState(() {
        speciesData = value;
        speciesData.addAll(unsupportedSpeciesData);
        speciesNames = speciesData.keys.toList();
        filteredSpeciesNames = speciesNames;
      },));

    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VNTURTLE', 
        ),
        centerTitle: true,
        actions: const [
          LanguageSwitchWidget(),
          SizedBox(width: 12,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.speciesInfo,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 32),
              child: TextField(
                controller: searchController,
                onChanged: filterSpeciesList,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.search,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredSpeciesNames.length,
                itemBuilder: (context, index) {
                  String speciesName = filteredSpeciesNames[index];
                  Map<String, dynamic> speciesInfo = speciesData[speciesName];
                  String isNative = "";
                  Color nativeColor = Colors.black;
                  if (speciesInfo['native'] == "true"){
                    isNative = AppLocalizations.of(context)!.native;
                    nativeColor = Colors.green.shade300;
                  } else {
                    isNative = AppLocalizations.of(context)!.nonNative;
                    nativeColor = Colors.orange.shade300;
                  }
                  return GestureDetector(
                    onTap: () => navigateToDetailPage(speciesName),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      decoration: BoxDecoration( 
                        color: theme.secondaryHeaderColor,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.black38, // Border color
                          width: 0.5, // Border width
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      image: DecorationImage(
                                        image: AssetImage(speciesInfo['reference_images'][0]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                ),
                                Positioned(
                                  top: 10,
                                  left: 40,
                                  child: Transform.rotate(
                                    angle: 0.785398, // 45 degrees in radians
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 80,
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(8.0),
                                        color: nativeColor
                                      ),
                                      child: Text(
                                        isNative,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        speciesInfo['primary_name'][currentLocale],
                                        style: const TextStyle(
                                          fontSize: 18.0, 
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  speciesInfo['scientific_name'], 
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                
                                ConservationStatusText(conservationStatus: speciesInfo['conservation_status']['iucn'], fontSize: 14,),
                                
                                const SizedBox(height: 8.0),
                                Text('${AppLocalizations.of(context)!.otherName}: ${speciesInfo['other_names'][currentLocale]}'),
                              ],
                            ),
                          ),
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
    );
  }
}
