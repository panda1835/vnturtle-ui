import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vnturtle/l10n/l10n.dart';
import 'package:vnturtle/provider/locale_provider.dart';

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

  @override
  void initState() {
    super.initState();
    loadConservationStatus().then((value) => setState(() {
      conservationStatusData = value;  
    }));
  }

  Future<Map<String, dynamic>> loadConservationStatus() async {
    String jsonString =
        await rootBundle.loadString('content/conservation_status.json');
    return jsonDecode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    String currentLocale = Localizations.localeOf(context).languageCode;

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