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
  Map<String, dynamic> conservationStatusData = {};

  String currentLocale = '';

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  Future<Map<String, dynamic>> loadSpeciesData(locale) async {
    String jsonString =
        await rootBundle.loadString('content/species_info_$locale.json');
    return jsonDecode(jsonString);
  }

  Future<Map<String, dynamic>> loadConservationStatusData() async {
    String jsonString =
        await rootBundle.loadString('content/conservation_status.json');
    return jsonDecode(jsonString);
  }

  void filterSpeciesList(String query) {
    setState(() {
      filteredSpeciesNames = speciesNames.where((name) {
        Map<String, dynamic> speciesInfo = speciesData[name];
        String nameVi = speciesInfo['primary_name'];
        String conservationStatus = speciesInfo['iucn'];
        String nameEn = speciesInfo['secondary_name'];
        String nameSci = speciesInfo['scientific_name'];

        return nameVi.toLowerCase().contains(query.toLowerCase()) ||
            conservationStatus.toLowerCase().contains(query.toLowerCase()) ||
            nameSci.toLowerCase().contains(query.toLowerCase()) ||
            nameEn.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void navigateToDetailPage(String speciesName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedSpeciesPage(speciesName: speciesName,),
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
    
      loadSpeciesData(currentLocale).then((value) => setState(() {
        speciesData = value;
        speciesNames = speciesData.keys.toList();
        filteredSpeciesNames = speciesNames;
      },));

      loadConservationStatusData().then((value) => setState(() {
        conservationStatusData = value;
      }));
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
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 32),
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
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: AssetImage(speciesInfo['reference_images'][0]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  speciesInfo['primary_name'],
                                  style:
                                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8.0),
                                // Row(
                                //   children: [
                                    // Text('${AppLocalizations.of(context)!.conservationStatus}: '),
                                    ConservationStatusText(conservationStatus: speciesInfo['iucn'], fontSize: 14, conservationStatusData: conservationStatusData,),
                                //   ],
                                // ),
                                const SizedBox(height: 8.0),
                                Text('${AppLocalizations.of(context)!.scientificName}: ${speciesInfo['scientific_name']}'),
                                const SizedBox(height: 8.0),
                                Text('${AppLocalizations.of(context)!.secondaryName}: ${speciesInfo['secondary_name']}'),
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

