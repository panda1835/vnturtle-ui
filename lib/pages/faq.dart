import 'package:flutter/material.dart';
import 'dart:convert';

class CauHoiThuongGapPage extends StatefulWidget {
  @override
  _CauHoiThuongGapPageState createState() => _CauHoiThuongGapPageState();
}

class _CauHoiThuongGapPageState extends State<CauHoiThuongGapPage> {
  List<dynamic> faqData = [];

  @override
  void initState() {
    super.initState();
    loadFaqData();
  }

  Future<void> loadFaqData() async {
    String jsonData = await DefaultAssetBundle.of(context).loadString('content/faq.json');
    setState(() {
      faqData = json.decode(jsonData)['FAQs'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget buildContent() {
      if (faqData.isEmpty) {
        return SizedBox.shrink(); // Return an empty widget
      } else {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Câu Hỏi Thường Gặp',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
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
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VNTURTLE', 
          style: TextStyle(
            fontFamily: "Happy Monkey",
            color: theme.primaryColor,
          ),
        ),
      ),
      body: Visibility(
        visible: faqData.isNotEmpty,
        child: buildContent(),
      ),
    );
  }
}