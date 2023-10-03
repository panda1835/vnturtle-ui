import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vnturtle/widgets/language_switch.dart';

class ConfirmPage extends StatefulWidget {
  final Map<String, dynamic> speciesInfo;

  const ConfirmPage({
    required this.speciesInfo,
  });

  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  bool _isContributed = false;
  // Map<String, dynamic> speciesData = {};
  String currentLocale = '';

  Future<Map<String, dynamic>> loadSpeciesData(String locale) async {
    String jsonString =
        await rootBundle.loadString('content/species_info_$locale.json');
      
    return jsonDecode(jsonString);
  }

  Future<void> _makeAPICall() async {
    // Make the POST request to the API
    // Replace API_URL with your actual API endpoint
    
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _isContributed = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (currentLocale != Localizations.localeOf(context).languageCode){
      setState(() {
        currentLocale = Localizations.localeOf(context).languageCode;
      });

    }
    return Scaffold(
      appBar: AppBar(
        title: Text('VNTURTLE'),
        centerTitle: true,
        actions: const [
          LanguageSwitchWidget(),
          SizedBox(width: 12,)
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // margin: EdgeInsets.only(top: 100),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage(widget.speciesInfo['reference_images'][0]), // Replace with your image path
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.speciesInfo['primary_name'],
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.speciesInfo['scientific_name'],
              style: const TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 400,
              child: RichText(
                text: TextSpan(
                  text: widget.speciesInfo['warning'],
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: ' ${AppLocalizations.of(context)!.contactHotline} ',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    const TextSpan(
                      text: '18001522',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                      ),
                    ),
                    TextSpan(
                      text: ' ${AppLocalizations.of(context)!.forAssistance}.',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 20,),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: _isContributed ? null : _makeAPICall,
                  child: Text(AppLocalizations.of(context)!.contributeImage),
                ),
                SizedBox(width: 10,),
                Container(
                  width: 20,
                  child: IconButton(
                    icon: const Icon(Icons.help_outline),
                    splashRadius: 5,
                    tooltip: AppLocalizations.of(context)!.contributeImageMessage,
                    onPressed: () {
                      // Handle the tooltip button click
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.contributeImage),
                            content: Text(AppLocalizations.of(context)!.contributeImageMessage),
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
                    }
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            if (_isContributed)
              Container(
                width: 400,
                child: Text(
                  AppLocalizations.of(context)!.contributeThankyouMessage,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
