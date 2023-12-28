import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:vnturtle/widgets/language_switch.dart';

class ManualGuidePage extends StatefulWidget {
  @override
  _ManualGuidePageState createState() => _ManualGuidePageState();
}

class _ManualGuidePageState extends State<ManualGuidePage> {
  String currentLocale = '';
  
  Future<String> _loadManualGuideContent(String locale) async {
    return await rootBundle.loadString('content/manual-guide/manual_guide_$locale.md');
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocale != Localizations.localeOf(context).languageCode){
      setState(() {
        currentLocale = Localizations.localeOf(context).languageCode;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VNTURTLE', 
        ),
        centerTitle: true,
        actions: [
          LanguageSwitchWidget(),
          const SizedBox(width: 12,)
        ],
      ),
      body: FutureBuilder(
        future: _loadManualGuideContent(currentLocale),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Failed to load content.'
                ),
              );
            } else {
              return Markdown(data: snapshot.data!);
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}