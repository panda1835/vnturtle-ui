import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:vnturtle/widgets/language_switch.dart';

class VeChungToiPage extends StatefulWidget {
  @override
  _VeChungToiPageState createState() => _VeChungToiPageState();
}

class _VeChungToiPageState extends State<VeChungToiPage> {
  String currentLocale = '';
  
  Future<String> _loadAboutUsContent(String locale) async {
    return await rootBundle.loadString('content/about_us_$locale.md');
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
        future: _loadAboutUsContent(currentLocale),
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