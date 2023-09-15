import 'package:flutter/material.dart';

class ResultBlock extends StatelessWidget {
  // final String scientificName;
  final String nameVi;
  final String score;
  final List<String> imagePaths;

  const ResultBlock({
    // required this.scientificName,
    required this.nameVi,
    required this.score,
    required this.imagePaths,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    Image.asset(imagePath),
                ],
              ),
            ),
            // Name_vi and score
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(nameVi),
                  SizedBox(width: 20.0),
                  Text('$score%'),
                ],
              ),
            ),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle Xác nhận button press
                  },
                  child: Text('Xác nhận'),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle Thông tin thêm button press
                  },
                  child: Text('Thông tin thêm'),
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