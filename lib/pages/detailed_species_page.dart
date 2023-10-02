import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:vnturtle/widgets/conservation_status_text.dart';
import 'package:vnturtle/widgets/language_switch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class DetailedSpeciesPage extends StatefulWidget {
  final String speciesName;

  DetailedSpeciesPage({required this.speciesName});

  @override
  State<DetailedSpeciesPage> createState() => _DetailedSpeciesPageState();
}

class _DetailedSpeciesPageState extends State<DetailedSpeciesPage> {
  Map<String, dynamic> speciesData = {};
  Map<String, dynamic> lawInfo = {};

  String currentLocale = "";

  Future<Map<String, dynamic>> loadSpeciesData(String locale) async {
    String jsonString =
        await rootBundle.loadString('content/species_info_$locale.json');
    return jsonDecode(jsonString);
  }

  Future<Map<String, dynamic>> loadLawInfo() async {
    String jsonString =
        await rootBundle.loadString('content/laws.json');
    return jsonDecode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (currentLocale != Localizations.localeOf(context).languageCode){
      setState(() {
        currentLocale = Localizations.localeOf(context).languageCode;
      });
      
      loadLawInfo().then((value) => setState(() {
        lawInfo = value;
      }));

      loadSpeciesData(currentLocale).then((value) => setState(() {
        speciesData = value;
      }));
    }

    Map<String, dynamic> speciesInfo = speciesData[widget.speciesName];
    
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
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                speciesInfo['primary_name'],
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Container(
                  width: 150,
                  child: Text(
                    "${AppLocalizations.of(context)!.scientificName}: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(speciesInfo['scientific_name'])
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Container(
                  width: 150,
                  child: Text(
                    "${AppLocalizations.of(context)!.otherName}:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text("${speciesInfo['other_names']}")
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Container(
                  width: 150,
                  child: Text(
                    "${AppLocalizations.of(context)!.secondaryName}:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text("${speciesInfo['secondary_name']}")
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Container(
                  width: 150,
                  child: Text(
                    "${AppLocalizations.of(context)!.conservationStatus}: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: ConservationStatusText(conservationStatus: speciesInfo['iucn'], fontSize: 14)
                )
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              "${AppLocalizations.of(context)!.legalProtection}:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: speciesInfo['laws'].keys
                .map<Widget>((lawKey) {
                  final lawValue = speciesInfo['laws'][lawKey];
                  if (lawValue != "") {
                    return Row(
                      children: [
                        SizedBox(width: 32),
                        Flexible(
                          child: Text("- ${lawInfo[lawKey][lawValue]['full_name'][currentLocale]}"),
                        ),
                        IconButton(
                          icon: Icon(Icons.help_outline),
                          iconSize: 14,
                          onPressed: () {
                            // Handle the tooltip button click
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(AppLocalizations.of(context)!.lawInfoTitle),
                                  content: Text(lawInfo[lawKey][lawValue]['brief_description'][currentLocale]),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(AppLocalizations.of(context)!.close),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    );
                  }
                  return SizedBox(height: 1);
                })
                .toList(),
            ),
            
            SizedBox(height: 8.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: speciesInfo['reference_images']
                    .map<Widget>(
                      (image) => Image.asset(
                        image,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              AppLocalizations.of(context)!.taxonomy,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8,),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      child: Text(
                        "${AppLocalizations.of(context)!.taxonomyClass}:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(speciesInfo['taxonomy']['class'])
                  ],
                ),
                SizedBox(height: 8,),
                Row(
                  children: [
                    Container(
                      width: 60,
                      child: Text(
                        "${AppLocalizations.of(context)!.taxonomyOrder}:",
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ),
                    Text(speciesInfo['taxonomy']['order'])
                  ],
                ),
                SizedBox(height: 8,),
                Row(
                  children: [
                    Container(
                      width: 60,
                      child: Text(
                        "${AppLocalizations.of(context)!.taxonomyFamily}:",
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ),
                    Text(speciesInfo['taxonomy']['family'])
                  ],
                )
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              AppLocalizations.of(context)!.characteristics,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(speciesInfo['characteristics']),
            SizedBox(height: 16.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: speciesInfo['identification_images']
                    .map<Widget>(
                      (image) => Image.asset(
                        image,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                    .toList(),
              ),
            ),
          
            SizedBox(height: 16.0),
            Text(
              AppLocalizations.of(context)!.habitat,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              speciesInfo['habitat'],
            ),
            SizedBox(height: 16.0),
            Text(
              AppLocalizations.of(context)!.distribution,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              speciesInfo['distribution'],
            ),
            SizedBox(height: 16.0),
            Text(
              AppLocalizations.of(context)!.funFacts,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              speciesInfo['fun_fact'],
            ),
            SizedBox(height: 16.0),
            Text(
              AppLocalizations.of(context)!.referenceSources,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              speciesInfo['reference_sources'][0],
            ),
          ],
        ),
      ),
    );
  }
}