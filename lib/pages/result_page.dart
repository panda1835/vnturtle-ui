import 'package:flutter/material.dart';
import '../widgets/result_block_widget.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_size_getter/image_size_getter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


class ResultPage extends StatefulWidget {
  final String imageUrl;

  const ResultPage({required this.imageUrl});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _isLoading = true;
  late Map<String, dynamic> jsonResponse;
  Map<String, dynamic> speciesInfo = {};
  
  double display_image_height = 180;
  double bbox_top=0;
  double bbox_left=0;
  double bbox_width=0;
  double bbox_height=0;

  @override
  void initState() {
    super.initState();
    _processData(widget.imageUrl);
    loadData();
  }

  Future<Map<String, dynamic>> loadSpeciesInfo() async {
    final jsonString =
        await rootBundle.loadString('content/species_info_vi.json');
    return json.decode(jsonString);
  }

  void loadData() async {
    speciesInfo = await loadSpeciesInfo();
    // Use the speciesInfo variable to access the JSON data
  }

  Future<Map<String, dynamic>> _placeholderApiCall(String imagePath) async {
    // Placeholder API call function that returns a mock JSON response
    // In a real implementation, you would make an actual API request here
    // and receive the JSON response
    await Future.delayed(Duration(seconds: 1)); // Simulating API delay
    return {
      "bbox": {
        "height": 723,
        "left": 459,
        "top": 545,
        "width": 1021
      },
      "image_size": {
        "height": 1500,
        "width": 2000
      },
      "predictions": {
        "Cuora bourreti": 0.02,
        "Cuora mouhotii": 0.59,
        "Cuora picturata": 0.02,
        "Geoemyda spengleri": 0.2,
        "Mauremys mutica": 0.16
      }
    };
  }

  // Convert bounding box to pixels
  double _convertBboxToPixels(double bboxValue, int imageHeight) {
    double ratio = display_image_height / imageHeight;
    return bboxValue * ratio;
  }

  Future<void> _processData(url) async {
    jsonResponse = await _placeholderApiCall(url);
    bbox_top = _convertBboxToPixels(jsonResponse['bbox']['top'], jsonResponse['image_size']['height']);
    bbox_left = _convertBboxToPixels(jsonResponse['bbox']['left'], jsonResponse['image_size']['height']);
    bbox_width = _convertBboxToPixels(jsonResponse['bbox']['width'], jsonResponse['image_size']['height']);
    bbox_height = _convertBboxToPixels(jsonResponse['bbox']['height'], jsonResponse['image_size']['height']);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VNTURTLE'),
      ),
      body: Column(
        children: [
          // First Half - Title and Image
          Container(
            height: 200,
            child: Stack(
              children: [
                // Center(
                  Image.network(
                      widget.imageUrl,
                      height: display_image_height,
                  ),
                // ),
                Positioned(
                  top: bbox_top,
                  left: bbox_left,
                  width: bbox_width,
                  height: bbox_height,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),

              ]
            ),
            ),
          // Second Half - List View (wrapped with SingleChildScrollView)
          Expanded(
            flex: 2,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        for (final entry
                            in jsonResponse['predictions'].entries)
                          ResultBlock(
                            scientificName: entry.key,
                            nameVi: speciesInfo[entry.key]['primary_name'],
                            score: entry.value,
                            imagePaths: (speciesInfo[entry.key]
                                    ['reference_images'] as List<dynamic>)
                                .cast<String>(),
                            imageUrl: "",
                          ),

                        ResultBlock(
                            scientificName: 'No match',
                            nameVi: '',
                            score: 0,
                            imagePaths: [],
                            imageUrl: widget.imageUrl,
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}