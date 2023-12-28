import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vnturtle/l10n/l10n.dart';
import 'package:vnturtle/provider/locale_provider.dart';
import 'package:vnturtle/widgets/language_switch.dart';
import 'pages/species_info_page.dart';
import 'pages/manual_guide_page.dart';
import 'pages/faq_page.dart';
import 'pages/about_us_page.dart';
import 'pages/result_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp( 
    options: const FirebaseOptions(
      apiKey: "AIzaSyBuLZkKtrj18LzuVsvSstnnQuLbSp5lqFA", 
      appId: "1:859395045927:web:c2b790e235d26a81df6c02", 
      messagingSenderId: "859395045927", 
      projectId: "ecstatic-design-399511",
      storageBucket: "gs://ecstatic-design-399511.appspot.com",
    )
  );

  // Always portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
} 
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (content) => LocaleProvider(),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);
        return MaterialApp(
          title: 'VNTURTLE',
          theme: ThemeData(
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: Colors.green.shade50,
            cardColor: Colors.green.shade100,
            // buttonTheme: ButtonThemeData(buttonColor: Colors.black),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.green.shade50,
              iconTheme: const IconThemeData(color: Colors.green),
              titleTextStyle: const TextStyle(
                color: Colors.green,
                fontFamily: "Happy Monkey",
                fontSize: 20,
              )
            )
          ),
          supportedLocales: L10n.all,
          locale: provider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          home: HomePage(),
        );
      }
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void _navigateToPage(BuildContext context, String choice) {
    Widget page;

    if (choice == AppLocalizations.of(context)!.speciesInfo){
      page = ThongTinLoaiPage();
    }
    else if (choice == AppLocalizations.of(context)!.fAQ){
      page = CauHoiThuongGapPage();
    }
    else if (choice == AppLocalizations.of(context)!.aboutUs){
      page = VeChungToiPage();
    }
    else {
      page = Container();
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> _handleImagePicker() async {
    FilePickerResult? image = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(image: image,),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> choices = [
      // 'Nhận diện',
      AppLocalizations.of(context)!.speciesInfo,
      // 'Báo cáo vi phạm',
      AppLocalizations.of(context)!.fAQ,
      AppLocalizations.of(context)!.aboutUs,
      AppLocalizations.of(context)!.hotline,
      '18001522'
    ];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.secondaryHeaderColor,
        title: const Text(
          'VNTURTLE',
        ),
        centerTitle: true,
        actions: const [
          LanguageSwitchWidget(),
          SizedBox(width: 12,)
        ],
      ),
      drawer: Drawer(
        backgroundColor: theme.secondaryHeaderColor,
        child: ListView.builder(
          itemCount: choices.length,
          itemBuilder: (context, index) {
            if (index == choices.length-2){
              return Padding(
                padding: const EdgeInsets.only(top: 25, left: 16.0, right: 16),
                child: Text(
                  choices[index],
                ),
              );
            }
            if (index == choices.length-1){
              return Padding(
                padding: const EdgeInsets.only(top: 5, left: 16.0),
                child: Text(
                  choices[index],
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return ListTile(
              title: Text(choices[index]),
              tileColor: theme.primaryColorLight,
              onTap: () {
                _navigateToPage(context, choices[index]);
              },
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // padding: const EdgeInsets.all(5.0),
              child: Image.asset(
                'images/icons/logo.png',
                width: 200,
                height: 200,
              ),
            ),
            Text(
              'VNTURTLE',
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Happy Monkey',
                color: theme.primaryColor,
              ),
            ),
    
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: _handleImagePicker,
                      icon: Icon(Icons.upload),
                      label: Text(
                        AppLocalizations.of(context)!.uploadButton,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManualGuidePage(),
                  ),
                ),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    AppLocalizations.of(context)!.manualGuide,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
            Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.yellow,
        child: Text(
          AppLocalizations.of(context)!.warningNoShare,
          style: TextStyle(
            fontSize: 15,
            color: Colors.red,
          ),
        ),
      ),
          ]
        ),
      ),
      
    );
  }
}