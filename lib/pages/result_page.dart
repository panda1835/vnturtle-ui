import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vnturtle/widgets/language_switch.dart';
import '../widgets/result_block_widget.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ResultPage extends StatefulWidget {
  final FilePickerResult image;

  const ResultPage({required this.image});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _isPredictionLoading = true;
  bool _isReportLoading = false;
  bool _isReported = false;
  bool _hasNoClassification = false;
  String currentLocale = '';
  Map<String, dynamic> jsonResponse = {
    "bbox": {
      "height": 0,
      "left": 0,
      "top": 0,
      "width": 0
    },
    "image_size": {
      "height": 10,
      "width": 10
    },
    "predictions": {},
    "version": {
      "detect": "",
      "classify": "",
    }
  };

  Map<String, dynamic> speciesInfo = {};
  Map<String, dynamic> unsupportedSpeciesInfo = {};
  double display_image_height = 180;
  double bbox_top=0;
  double bbox_left=0;
  double bbox_width=0;
  double bbox_height=0;

  @override
  void initState() {
    super.initState();
    runPrediction();
  }

  Future<Map<String, dynamic>> loadSpeciesInfo() async {
    final jsonString =
        await rootBundle.loadString('content/species_info.json');
    return json.decode(jsonString);
  }

  Future<Map<String, dynamic>> loadUnsupportedSpeciesInfo() async {
    final jsonString =
        await rootBundle.loadString('content/unsupported_species_info.json');
    return json.decode(jsonString);
  }


  Future<void> _reportImage() async {
    String snackBarMessage = "";
    // Create a Firestore document reference
    final DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection('no-classification-images').doc();

    // Create a Cloud storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();
    // Create a reference to the image in the storage
    final newReportImageRef = storageRef.child("no-classification-images/${documentReference.id}.jpg");
    Uint8List imageForReport = widget.image.files.single.bytes!;

    // Add timestamp to the record
    var dataForUpload = jsonResponse;
    dataForUpload['timestamp'] = Timestamp.now();

    setState(() {
      _isReportLoading = true;
    });

    try {
      // Upload the data to Firestore
      await documentReference.set(dataForUpload);
      await newReportImageRef.putData(imageForReport);
      // Update the state to reflect the successful upload
      setState(() {
        _isReported = true;
        _isReportLoading = false;
        _hasNoClassification = true;
      });

      snackBarMessage = AppLocalizations.of(context)!.imageReportedNoti;
    } catch (error) {
      // Handle any errors that occurred during the upload
      snackBarMessage = AppLocalizations.of(context)!.genericErrorMessageToUser;
      print('Error uploading data to Firestore: $error');
    }

    final snackBar = SnackBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      content: Text(
        snackBarMessage,
        style: TextStyle(color: Colors.black),
      ),
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<Map<String, dynamic>> uploadImage() async {
    var dio = Dio();
    var uri = "https://vnturtle-flask-f50c26c573de.herokuapp.com/predict";

    var formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        widget.image.files.single.bytes!,
        filename: 'image.jpg',
      ),
    });

    var response = await dio.post(uri, data: formData);

    var jsonResponse = json.decode(response.toString());

    // await Future.delayed(Duration(seconds: 1)); // Simulating API delay
    return jsonResponse;
  }

  // Convert bounding box to pixels
  double _convertBboxToPixels(double bboxValue, int imageHeight) {
    double ratio = display_image_height / imageHeight;
    return bboxValue * ratio;
  }

  Future<void> runPrediction() async {

    jsonResponse = await uploadImage();

    bbox_top = _convertBboxToPixels(jsonResponse['bbox']['top'], jsonResponse['image_size']['height']);
    bbox_left = _convertBboxToPixels(jsonResponse['bbox']['left'], jsonResponse['image_size']['height']);
    bbox_width = _convertBboxToPixels(jsonResponse['bbox']['width'], jsonResponse['image_size']['height']);
    bbox_height = _convertBboxToPixels(jsonResponse['bbox']['height'], jsonResponse['image_size']['height']);
    
    setState(() {
      _isPredictionLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (currentLocale != Localizations.localeOf(context).languageCode){
      setState(() {
        currentLocale = Localizations.localeOf(context).languageCode;
      });

      loadSpeciesInfo().then((value) => setState(() {
        speciesInfo = value;
      },));

      loadUnsupportedSpeciesInfo().then((value) => setState(() {
        unsupportedSpeciesInfo = value;
      },));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('VNTURTLE'),
        centerTitle: true,
        actions: [
          LanguageSwitchWidget(),
          const SizedBox(width: 12,)
        ],
      ),
      body: Center(
        child: Column(
          children: [
            // First Half - Title and Image
            Container(
              height: 200,
              child: Stack(
                children: [
                  // Center(
                    Image.memory(
                        widget.image.files.single.bytes!,
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
            _hasNoClassification 
                ? Container(
                    width: double.infinity,
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.stillNoMatchFound,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              AppLocalizations.of(context)!.letUsKnow,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 300,
                                  child: ElevatedButton(
                                    onPressed: null,
                                    child: Text(AppLocalizations.of(context)!.reportNoMatchButton),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              AppLocalizations.of(context)!.reportNoMatchExplain,
                              style: TextStyle(fontWeight: FontWeight.normal,),
                            )
                          ],
                        ),
                      ),
                    ),
                ) : Expanded(
              flex: 2,
              child: _isPredictionLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        for (final entry
                            in jsonResponse['predictions']!.entries.toList()
                            ..sort((a, b) => (b.value as double).compareTo(a.value as double)))
                          ResultBlock(
                            speciesInfo: speciesInfo[entry.key],
                            score: ((entry.value*100).toInt()),
                            image: widget.image,
                          ),

                          Container(
                            width: double.infinity,
                            child: Card(
                              elevation: 5,
                              margin: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.noMatchFoundPrompt,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.checkUnsupportedSpeciesPrompt,
                                      style: const TextStyle(fontWeight: FontWeight.normal),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 300,
                                          child: ElevatedButton(
                                            child: Text(
                                              AppLocalizations.of(context)!.notSupportedSpeciesButtonText
                                            ),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                backgroundColor: theme.secondaryHeaderColor,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(16.0),
                                                          child: Text(
                                                            AppLocalizations.of(context)!.notSupportedSpeciesTitle,
                                                            style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 25),
                                                          ),
                                                        ),
                                                        for (final entry in unsupportedSpeciesInfo.entries.toList())
                                                        ResultBlock(
                                                          image: widget.image, 
                                                          score: -1, 
                                                          speciesInfo: entry.value
                                                        ),
                                                      ]
                                                    ),
                                                  );
                                                }
                                              );
                                            }, 
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Container(
                            width: double.infinity,
                            child: Card(
                              elevation: 5,
                              margin: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.stillNoMatchFound,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.letUsKnow,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    _isReportLoading
                                      ? const CircularProgressIndicator() // Show a progress indicator while loading
                                      : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 300,
                                            child: ElevatedButton(
                                              onPressed: _isReported ? null : _reportImage,
                                              child: Text(AppLocalizations.of(context)!.reportNoMatchButton),
                                            ),
                                          ),
                                        ],
                                      ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // if (_isReported)
                                    Text(
                                      AppLocalizations.of(context)!.reportNoMatchExplain,
                                      style: TextStyle(fontWeight: FontWeight.normal,),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}