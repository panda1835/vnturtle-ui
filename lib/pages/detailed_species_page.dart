import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:vnturtle/widgets/conservation_status_text.dart';
import 'package:vnturtle/widgets/identification_image_row_widget.dart';
import 'package:vnturtle/widgets/language_switch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class DetailedSpeciesPage extends StatefulWidget {
  final Map<String, dynamic> speciesInfo;

  DetailedSpeciesPage({
    required this.speciesInfo,
  });

  @override
  State<DetailedSpeciesPage> createState() => _DetailedSpeciesPageState();
}

class _DetailedSpeciesPageState extends State<DetailedSpeciesPage> {
  Map<String, dynamic> lawInfo = {};

  String currentLocale = "";

  @override
  void initState(){
    super.initState();
  }

  Future<bool> loadData() async {
    String jsonLaw =
        await rootBundle.loadString('content/laws.json');
    
    setState(() {
      lawInfo = jsonDecode(jsonLaw);
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (currentLocale != Localizations.localeOf(context).languageCode){
      setState(() {
        currentLocale = Localizations.localeOf(context).languageCode;
      });

      loadData();
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
      body: FutureBuilder(
        future: loadData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == true) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Failed to load data.'
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    Center(
                      child: Text(
                        widget.speciesInfo['primary_name'][currentLocale],
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Container(
                          width: 150,
                          child: Text(
                            "${AppLocalizations.of(context)!.scientificName}: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(widget.speciesInfo['scientific_name'])
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Container(
                          width: 150,
                          child: Text(
                            "${AppLocalizations.of(context)!.otherName}:",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(child: Text("${widget.speciesInfo['other_names'][currentLocale]}"))
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Container(
                          width: 150,
                          child: Text(
                            "${AppLocalizations.of(context)!.secondaryName}:",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text("${widget.speciesInfo['secondary_name'][currentLocale]}")
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Container(
                          width: 150,
                          child: Text(
                            "${AppLocalizations.of(context)!.conservationStatus}: ",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: ConservationStatusText(conservationStatus: widget.speciesInfo['conservation_status']['iucn'], fontSize: 14,)
                        )
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "${AppLocalizations.of(context)!.legalProtection}:",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.speciesInfo['laws'].keys
                        .map<Widget>((lawKey) {
                          final lawValue = widget.speciesInfo['laws'][lawKey];
                          if (lawValue != "") {
                            return Row(
                              children: [
                                const SizedBox(width: 32),
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
                                          content: SingleChildScrollView(
                                            child: Text(lawInfo[lawKey][lawValue]['brief_description'][currentLocale]),
                                          ),
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
                          return const SizedBox(height: 1);
                        })
                        .toList(),
                    ),
                    
                    const SizedBox(height: 8.0),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.speciesInfo['reference_images']
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
                    const SizedBox(height: 16.0),
                    Text(
                      AppLocalizations.of(context)!.taxonomy,
                      style: const TextStyle(
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
                            Text(widget.speciesInfo['taxonomy']['class'][currentLocale])
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
                            Text(widget.speciesInfo['taxonomy']['order'][currentLocale])
                          ],
                        ),
                        const SizedBox(height: 8,),
                        Row(
                          children: [
                            Container(
                              width: 60,
                              child: Text(
                                "${AppLocalizations.of(context)!.taxonomyFamily}:",
                                style: TextStyle(fontWeight: FontWeight.bold)
                              ),
                            ),
                            Text(widget.speciesInfo['taxonomy']['family'][currentLocale])
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      AppLocalizations.of(context)!.characteristics,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(widget.speciesInfo['characteristics'][currentLocale]),
                    const SizedBox(height: 16.0),
                    IdentificationImageRow(speciesInfo: widget.speciesInfo,),
                    const SizedBox(height: 16.0),
                    Text(
                      AppLocalizations.of(context)!.habitat,
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.speciesInfo['habitat'][currentLocale],
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      AppLocalizations.of(context)!.distribution,
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.speciesInfo['distribution'][currentLocale],
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      AppLocalizations.of(context)!.funFacts,
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.speciesInfo['fun_fact'][currentLocale],
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      AppLocalizations.of(context)!.referenceSources,
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    for (var reference in widget.speciesInfo['reference_sources'][currentLocale])
                    Text(
                      "- ${reference}",
                    ),
                  ],
                ),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}