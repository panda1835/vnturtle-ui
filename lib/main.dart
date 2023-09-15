import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'pages/species_info.dart';
import 'pages/report.dart';
import 'pages/faq.dart';
import 'pages/aboutus.dart';
import 'pages/result_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VNTURTLE',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> choices = [
    // 'Nhận diện',
    'Thông tin loài',
    'Báo cáo vi phạm',
    'Câu hỏi thường gặp',
    'Về chúng tôi'
  ];

  DropzoneViewController? controller;
  bool highlight = false;

  void _navigateToPage(String choice) {
    Widget page;
    switch (choice) {
      // case 'Nhận diện':
      //   page = HomePage();
      //   break;
      case 'Thông tin loài':
        page = ThongTinLoaiPage();
        break;
      case 'Câu hỏi thường gặp':
        page = CauHoiThuongGapPage();
        break;
      case 'Báo cáo vi phạm':
        page = BaoCaoViPhamPage();
        break;
      case 'Về chúng tôi':
        page = VeChungToiPage();
        break;
      default:
        page = Container();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _handleDroppedImage(dynamic event) async {
    
    final name = event.name;

    final mime = await controller!.getFileMIME(event);
    final byte = await controller!.getFileSize(event);
    final url = await controller!.createFileUrl(event);

    print('Name : $name');
    print('Mime: $mime');
    print('Size : ${byte / (1024 * 1024)}');
    print('URL: $url');

    // Placeholder API call function for testing
    Map<String, dynamic> jsonResponse = await _placeholderApiCall(url);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(jsonResponse: jsonResponse),
      ),
    );
  }

  Future<Map<String, dynamic>> _placeholderApiCall(String imagePath) async {
    // Placeholder API call function that returns a mock JSON response
    // In a real implementation, you would make an actual API request here
    // and receive the JSON response
    await Future.delayed(Duration(seconds: 1)); // Simulating API delay
    return {
      "predictions": {
        "prediction1": {"scientific_name": "Platysternon megacephalum", "score": "70"},
        "prediction2": {"scientific_name": "Cuora amboinensis", "score": "20"},
        "prediction3": {"scientific_name": "Cuora galbinifrons", "score": "5"},
        "prediction4": {"scientific_name": "Cuora bourreti", "score": "3"},
        "prediction5": {"scientific_name": "Cuora mouhotii", "score": "2"}
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.secondaryHeaderColor,
      appBar: AppBar(
        backgroundColor: theme.secondaryHeaderColor,
        title: Text(
          'VNTURTLE',
          style: TextStyle(
            fontFamily: "Happy Monkey",
            color: theme.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: theme.secondaryHeaderColor,
        child: ListView.builder(
          itemCount: choices.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(choices[index]),
              tileColor: theme.primaryColorLight,
              onTap: () {
                _navigateToPage(choices[index]);
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
            // Container(
              // child: ElevatedButton.icon(
              //   onPressed: () async {
              //     final events = await controller!.pickFiles();
              //     if (events.isEmpty) return;
              //     _handleDroppedImage(events.first);
              //   },
              //   icon: Icon(Icons.search),
              //   label: Text(
              //     'Choose File',
              //     style: TextStyle(color: Colors.white, fontSize: 15),
              //   ),
              // ),
              Stack(
                children: [
                  DropzoneView(
                      onCreated: (controller) => this.controller = controller,
                      onDrop: _handleDroppedImage,
                      onHover:() => setState(()=> highlight = true),
                      onLeave: ()=> setState(()=> highlight = false),
                  ),

                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final events = await controller!.pickFiles();
                            if(events.isEmpty) return;
                            _handleDroppedImage(events.first);
                          },
                          icon: Icon(Icons.search),
                          label: Text(
                            'Choose File',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ),
                ]
              )
            ]
        ),
      )
      
    );
  }
}