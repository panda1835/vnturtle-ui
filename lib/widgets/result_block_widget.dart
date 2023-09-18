import 'package:flutter/material.dart';
import '../pages/detailed_species_page.dart';

class ResultBlock extends StatelessWidget {
  // final String scientificName;
  final String nameVi;
  final String scientificName;
  final String score;
  final List<String> imagePaths;

  const ResultBlock({
    required this.scientificName,
    required this.nameVi,
    required this.score,
    required this.imagePaths,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(10),
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
                  for (final imagePath in imagePaths)
                    Image.asset(imagePath, height: 150,),
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
                    margin: EdgeInsets.only(top:10, bottom: 10),
                    width: 200.0,
                    child: Text(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      nameVi
                    )
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                      fontSize: 20,
                    ),
                    '$score%'
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
                      // Handle Xác nhận button press
                    },
                    child: Text('Xác nhận'),
                  ),
                ),
                SizedBox(width: 8.0),
                Container(
                  width: 130,
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context, 
                        builder: (BuildContext context) => DetailedSpeciesPage(speciesName: scientificName));
                    },
                    child: Text('Thông tin thêm'),
                  ),
                ),
                SizedBox(width: 16.0),
              ],
            ),
          ],
        )
      )
    );
  }
}