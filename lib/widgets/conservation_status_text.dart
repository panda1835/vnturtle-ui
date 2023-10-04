import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ConservationStatusText extends StatefulWidget {
  final String conservationStatus;
  final double fontSize;

  ConservationStatusText({ 
    required this.conservationStatus,
    required this.fontSize,
  });

  @override
  State<ConservationStatusText> createState() => _ConservationStatusTextState();
}

class _ConservationStatusTextState extends State<ConservationStatusText> {
  String currentLocale = "";
  String hexColor = "";
  String name = "";
  String newText = "";

  Map<String, dynamic> conservationStatusData = {   
    "NE": {
        "vi": "Không được đánh giá",
        "en": "Not Evaluated",
        "hex_color": "#E5E5E5"
    },
    "DD": {
        "vi": "Thiếu dữ liệu",
        "en": "Data Deficient",
        "hex_color": "#C3C3C3"
    },
    "LC": {
        "vi": "Ít quan tâm",
        "en": "Least Concern",
        "hex_color": "#6EBA3E"
    },
    "NT": {
        "vi": "Sắp bị đe dọa",
        "en": "Near Threatened",
        "hex_color": "#A0C040"
    },
    "VU": {
        "vi": "Sắp nguy cấp",
        "en": "Vulnerable",
        "hex_color": "#F7CB47"
    },
    "EN": {
        "vi": "Nguy cấp",
        "en": "Endangered",
        "hex_color": "#E38A47"
    },
    "CR": {
        "vi": "Cực kỳ nguy cấp",
        "en": "Critically Endangered",
        "hex_color": "#B53522"
    },
    "EW": {
        "vi": "Tuyệt chủng trong tự nhiên",
        "en": "Extinct in the Wild",
        "hex_color": "#7F628A"
    },
    "EX": {
        "vi": "Tuyệt chủng",
        "en": "Extinct",
        "hex_color": "#4C4338"
    },
    "NM": {
        "vi": "Chưa được đề cập",
        "en": "Not Mentioned in the IUCN Redlist",
        "hex_color": "#000000"
    }
  };

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

    hexColor = conservationStatusData[widget.conservationStatus]['hex_color'];
    name = conservationStatusData[widget.conservationStatus][currentLocale];
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