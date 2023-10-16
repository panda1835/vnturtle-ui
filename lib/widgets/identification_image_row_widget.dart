import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IdentificationImageRow extends StatefulWidget {
  final Map<String, dynamic> speciesInfo;

  IdentificationImageRow({ 
    required this.speciesInfo,
  });

  @override
  State<IdentificationImageRow> createState() => _IdentificationImageRowState();
}

class _IdentificationImageRowState extends State<IdentificationImageRow> {
  String currentLocale = "";
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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.speciesInfo['identification_images']
            .map<Widget>(
              (image) => GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(
                                image["image"],
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                              child: Text(
                                image["description"][currentLocale],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Image.asset(
                  image["image"],
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ).toList(),
        ),
    );
  }
}