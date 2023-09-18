import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'pages/species_info_page.dart';
import 'pages/faq_page.dart';
import 'pages/about_us_page.dart';
import 'pages/result_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VNTURTLE',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green.shade50,
        // buttonTheme: ButtonThemeData(buttonColor: Colors.black),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade50,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.green,
            fontFamily: "Happy Monkey",
            fontSize: 20,
          )
        )
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
    // 'Báo cáo vi phạm',
    'Câu hỏi thường gặp',
    'Về chúng tôi',
    'Gọi đến đường dây nóng 1800 1522 để báo cáo hành vi vi phạm'
  ];

  DropzoneViewController? controller;
  bool highlight = false;

  void _navigateToPage(String choice) {
    Widget page;
    switch (choice) {
      case 'Nhận diện':
        page = HomePage();
        break;
      case 'Thông tin loài':
        page = ThongTinLoaiPage();
        break;
      case 'Câu hỏi thường gặp':
        page = CauHoiThuongGapPage();
        break;
      // case 'Báo cáo vi phạm':
      //   page = BaoCaoViPhamPage();
      //   break;
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
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(imageUrl: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.secondaryHeaderColor,
        title: Text(
          'VNTURTLE',
        ),
      ),
      drawer: Drawer(
        backgroundColor: theme.secondaryHeaderColor,
        child: ListView.builder(
          itemCount: choices.length,
          itemBuilder: (context, index) {
            if (index == choices.length-1){
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  choices[index],
                ),
              );
            }
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
    
              Stack(
                children: [
                  DropzoneView(
                      onCreated: (controller) => this.controller = controller,
                      onDrop: _handleDroppedImage,
                      onHover:() => setState(()=> highlight = true),
                      onLeave: ()=> setState(()=> highlight = false),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              final events = await controller!.pickFiles();
                              if(events.isEmpty) return;
                              _handleDroppedImage(events.first);
                            },
                            icon: Icon(Icons.upload),
                            label: Text(
                              'Choose File',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          )
                        ],
                      ),
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