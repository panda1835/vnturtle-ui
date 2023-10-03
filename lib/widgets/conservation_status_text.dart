import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ConservationStatusText extends StatefulWidget {
  final String conservationStatus;
  final double fontSize;
  final Map<String, dynamic> conservationStatusData;

  ConservationStatusText({ 
    required this.conservationStatus,
    required this.fontSize,
    required this.conservationStatusData
  });

  @override
  State<ConservationStatusText> createState() => _ConservationStatusTextState();
}

class _ConservationStatusTextState extends State<ConservationStatusText> {
  String currentLocale = "";
  String hexColor = "";
  String name = "";
  String newText = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    if (currentLocale != Localizations.localeOf(context).languageCode){
      setState(() {
        currentLocale = Localizations.localeOf(context).languageCode;
      });
    }

    hexColor = widget.conservationStatusData[widget.conservationStatus]['hex_color'];
    name = widget.conservationStatusData[widget.conservationStatus][currentLocale];
    newText = '$name (${widget.conservationStatus})';
    
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