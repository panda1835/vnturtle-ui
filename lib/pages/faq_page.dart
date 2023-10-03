import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:vnturtle/widgets/language_switch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CauHoiThuongGapPage extends StatefulWidget {
  @override
  _CauHoiThuongGapPageState createState() => _CauHoiThuongGapPageState();
}

class _CauHoiThuongGapPageState extends State<CauHoiThuongGapPage> {
  List<dynamic> faqData = [];
  String curentLocale = '';

  @override
  void initState() {
    super.initState();
  }

  Future<List<dynamic>> loadFaqData(String locale) async {
    String jsonData = await DefaultAssetBundle.of(context).loadString('content/faq_$locale.json');
    return json.decode(jsonData)['FAQs'];
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (curentLocale != Localizations.localeOf(context).languageCode){
      setState(() {
        curentLocale = Localizations.localeOf(context).languageCode;
      });
      loadFaqData(curentLocale).then((value) => setState(() {
        faqData = value;
      },));
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
      body: Visibility(
        visible: faqData.isNotEmpty,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.fAQ,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: faqData.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text(faqData[index]['question']),
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(faqData[index]['answer']),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
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