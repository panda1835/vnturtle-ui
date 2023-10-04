import 'package:flutter/material.dart';
import '../pages/detailed_species_page.dart';

import '../pages/confirm_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResultBlock extends StatefulWidget {
  final int score;
  final Map<String, dynamic> speciesInfo;

  const ResultBlock({
    required this.speciesInfo,
    required this.score,
  });

  @override
  _ResultBlockState createState() => _ResultBlockState();
}

class _ResultBlockState extends State<ResultBlock> {
  
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

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
                  for (final imagePath in widget.speciesInfo['identification_images'])
                    Image.asset(
                      imagePath,
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
                        widget.speciesInfo['primary_name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                  const SizedBox(width: 20.0),
                  Text(
                    '${widget.score.toString()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 130,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmPage(speciesInfo: widget.speciesInfo,),
                        ),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.confirmButton),
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  width: 130,
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) =>
                              DetailedSpeciesPage(speciesName: widget.speciesInfo['scientific_name'],));
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