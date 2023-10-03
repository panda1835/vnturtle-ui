import 'package:flutter/material.dart';
import '../pages/detailed_species_page.dart';

import '../pages/confirm_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResultBlock extends StatefulWidget {
  final String nameVi;
  final String scientificName;
  final int score;
  final List<String> imagePaths;
  final String imageUrl;

  const ResultBlock({
    required this.scientificName,
    required this.nameVi,
    required this.score,
    required this.imagePaths,
    required this.imageUrl,
  });

  @override
  _ResultBlockState createState() => _ResultBlockState();
}

class _ResultBlockState extends State<ResultBlock> {
  bool _isReported = false;

  Future<void> _reportImage() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
          _isReported = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (widget.scientificName == 'No match') {
      return Card(
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.noMatchFoundPrompt,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _isReported ? null : _reportImage,
                child: Text(AppLocalizations.of(context)!.reportNoMatchButton),
              ),
              const SizedBox(
                height: 10,
              ),
              if (_isReported)
                Text(
                  AppLocalizations.of(context)!.imageReportedNoti,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
            ],
          ),
        ),
      );
    }
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
                  for (final imagePath in widget.imagePaths)
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
                        widget.nameVi,
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
                          builder: (context) => ConfirmPage(scientificName: widget.scientificName,),
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
                              DetailedSpeciesPage(speciesName: widget.scientificName,));
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