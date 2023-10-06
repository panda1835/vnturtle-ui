import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../pages/detailed_species_page.dart';

import '../pages/confirm_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResultBlock extends StatefulWidget {
  final int score;
  final Map<String, dynamic> speciesInfo;
  final FilePickerResult image;

  const ResultBlock({
    required this.speciesInfo,
    required this.score,
    required this.image
  });

  @override
  _ResultBlockState createState() => _ResultBlockState();
}

class _ResultBlockState extends State<ResultBlock> {
  String currentLocale = "";
  final int maxWidth = 420;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (currentLocale != Localizations.localeOf(context).languageCode){
      setState(() {
        currentLocale = Localizations.localeOf(context).languageCode;
      });
    }

    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Horizontal sliding gallery of images
            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // Use the reference_images field from species_info_vi.json
                  for (final image in widget.speciesInfo['identification_images'])
                    Image.asset(
                      image['image'],
                      height: 150,
                    ),
                ],
              ),
            ),
            // Name_vi and score
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    width: 200.0,
                    child: Text(
                      widget.speciesInfo['primary_name'][currentLocale],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  ),
                  screenWidth < maxWidth
                  ? SizedBox(width: screenWidth - 200 - 20 - 85)
                  : SizedBox(width: 20,),
                  widget.score > -1 // if -1 then it is unsupported species, do not display score
                  ? Text(
                    '${widget.score.toString()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                      fontSize: 20,
                    ),
                  )
                  : Text(""),
                ],
              ),
            ),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmPage(speciesInfo: widget.speciesInfo, image: widget.image,),
                        ),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.confirmButton),
                  ),
                ),
                screenWidth < maxWidth
                  ? SizedBox(width: screenWidth - 200 - 20 - 140)
                  : SizedBox(width: 20,),
                Container(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) =>
                              DetailedSpeciesPage(speciesInfo: widget.speciesInfo,));
                    },
                    child: Text(AppLocalizations.of(context)!.moreInfoButton),
                  ),
                ),
                const SizedBox(width: 16.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}