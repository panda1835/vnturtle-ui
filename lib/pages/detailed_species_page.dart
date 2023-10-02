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

  String currentLocale = "";

  Future<Map<String, dynamic>> loadSpeciesData(String locale) async {
    String jsonString =
        await rootBundle.loadString('content/species_info_$locale.json');
    return jsonDecode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (currentLocale != Localizations.localeOf(context).languageCode){
      setState(() {
        currentLocale = Localizations.localeOf(context).languageCode;
      });
      
    }
    return FutureBuilder(
      future: loadSpeciesData(currentLocale),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> speciesInfo = snapshot.data[widget.speciesName];
          // Use the 'jsonData' variable to access the JSON data
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
            body: ListView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      speciesInfo['primary_name'],
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "${AppLocalizations.of(context)!.scientificName}: ${speciesInfo['scientific_name']}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "${AppLocalizations.of(context)!.otherName}: ${speciesInfo['other_names']}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "${AppLocalizations.of(context)!.secondaryName}: ${speciesInfo['secondary_name']}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.conservationStatus}: ",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      ConservationStatusText(conservationStatus: speciesInfo['iucn'], fontSize: 18)
                    ],
                  ),
                ),
               
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
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
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Đặc điểm nhận dạng',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
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
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Tình trạng bảo tồn: ${speciesInfo['iucn']}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Tên tiếng Anh: ${speciesInfo['secondary_name']}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Bản đồ phân bố: ${speciesInfo['distribution']}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Thông tin thú vị: ${speciesInfo['fun_fact']}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Sự cố hiển thị thông tin. Vui lòng thử lại sau');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}