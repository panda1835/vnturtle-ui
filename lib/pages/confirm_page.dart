import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Uint8List;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vnturtle/widgets/conservation_status_text.dart';
import 'package:vnturtle/widgets/language_switch.dart';

class ConfirmPage extends StatefulWidget {
  final Map<String, dynamic> speciesInfo;
  final FilePickerResult image;

  const ConfirmPage({
    required this.speciesInfo,
    required this.image
  });

  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  bool _isContributeLoading = false;
  bool _isContributed = false;
  // Map<String, dynamic> speciesData = {};
  String currentLocale = '';

  Future<void> _contributeImage() async {

    String snackBarMessage = "";

    // Create a Firestore document reference
    final DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection('contribute-images').doc();
    // Create a Cloud storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();

    // Create a reference to the image in the storage
    final mountainsRef = storageRef.child("contribute-images/${documentReference.id}.jpg");
    Uint8List imageForReport = widget.image.files.single.bytes!;

    // Add timestamp to the record
    var dataForUpload = {
      "scientific_name": widget.speciesInfo['scientific_name'],
      "timestamp": DateTime.now(),
    };

    setState(() {
      _isContributeLoading = true;
    });

    try {
      // Upload the data to Firestore
      await documentReference.set(dataForUpload);
      await mountainsRef.putData(imageForReport);

      // Update the state to reflect the successful upload
      setState(() {
        _isContributed = true;
        _isContributeLoading = false;
      });
      snackBarMessage = AppLocalizations.of(context)!.imageReportedNoti;
    } catch (error) {
      // Handle any errors that occurred during the upload
      snackBarMessage = AppLocalizations.of(context)!.genericErrorMessageToUser;
      print('Error uploading data to Firestore: $error');
    }

    final snackBar = SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(
        snackBarMessage,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (currentLocale != Localizations.localeOf(context).languageCode){
      setState(() {
        currentLocale = Localizations.localeOf(context).languageCode;
      });

    }
    return Scaffold(
      appBar: AppBar(
        title: Text('VNTURTLE'),
        centerTitle: true,
        actions: const [
          LanguageSwitchWidget(),
          SizedBox(width: 12,)
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage(widget.speciesInfo['reference_images'][0]), // Replace with your image path
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    widget.speciesInfo['primary_name'][currentLocale],
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.speciesInfo['scientific_name'],
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20),
                ConservationStatusText(conservationStatus: widget.speciesInfo['conservation_status']['iucn'], fontSize: 14),
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  // width: 400,
                  child: RichText(
                    text: TextSpan(
                      text: widget.speciesInfo['warning'][currentLocale],
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' ${AppLocalizations.of(context)!.contactHotline} ',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text: '18001522',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                        TextSpan(
                          text: ' ${AppLocalizations.of(context)!.forAssistance}.',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 10,),

                const Divider(
                  height: 20,
                  thickness: 1,
                  indent: 10.0,
                  endIndent: 10.0,
                  color: Colors.grey,
                ),
                SizedBox(height: 10,),
          
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.contributeToVNTurtle,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.contributeYourImage,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // if (_isReported)
                        Text(
                          AppLocalizations.of(context)!.contributeImageMessage,
                          style: const TextStyle(fontWeight: FontWeight.normal,),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _isContributeLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: _isContributed ? null : _contributeImage,
                                child: Text(AppLocalizations.of(context)!.contributeImageButton),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
