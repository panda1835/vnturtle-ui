import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class ConservationStatusText extends StatefulWidget {
  final String conservationStatus;
  double fontSize;

  ConservationStatusText({super.key, 
    required this.conservationStatus,
    required this.fontSize
  });

  @override
  State<ConservationStatusText> createState() => _ConservationStatusTextState();
}

class _ConservationStatusTextState extends State<ConservationStatusText> {
  Map<String, dynamic> conservationStatusData = {};
  String currentLocale = "";

  @override
  void initState() {
    super.initState();
    
  }

  Future<Map<String, dynamic>> loadConservationStatus() async {
    String jsonString =
        await rootBundle.loadString('content/conservation_status.json');
    return jsonDecode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    
    if (currentLocale != Localizations.localeOf(context).languageCode){
      setState(() {
        currentLocale = Localizations.localeOf(context).languageCode;
      });

      loadConservationStatus().then((value) => setState(() => conservationStatusData = value,));
    }

    String hexColor = conservationStatusData[widget.conservationStatus]['hex_color'];
    String name = conservationStatusData[widget.conservationStatus][currentLocale];

    String newText = '$name (${widget.conservationStatus})';

    return Text(
      newText,
      style: TextStyle(
        color: Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000),
        fontWeight: FontWeight.bold,
        fontSize: widget.fontSize
      ),
    );
  }
}