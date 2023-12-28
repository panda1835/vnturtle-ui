import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:vnturtle/widgets/identification_image_row_widget.dart';
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
            Text(
              AppLocalizations.of(context)!.clickImageForDetails,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            // Horizontal sliding gallery of images
            Container(
              height: 200,
              child: IdentificationImageRow(speciesInfo: widget.speciesInfo,)
            ),
            // Name and score
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    width: 250.0,
                    child: Text(
                      widget.speciesInfo['primary_name'][currentLocale],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  ),
                  const SizedBox(width: 20,),
                  widget.score > -1 // if -1 then it is unsupported species, do not display score
                  ? Text(
                    '${widget.score.toString()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                      fontSize: 20,
                    ),
                  )
                  : const Text(""),
                ],
              ),
            ),
            // Buttons
            screenWidth < maxWidth
            ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            )
            : Row(
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
                const SizedBox(width: 20,),
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