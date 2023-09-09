import 'package:flutter/material.dart';
import 'pages/species_info.dart';
import 'pages/report.dart';
import 'pages/faq.dart';
import 'pages/aboutus.dart';


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
    'Nhận diện',
    'Thông tin loài',
    'Báo cáo vi phạm',
    'Câu hỏi thường gặp',
    'Về chúng tôi'
  ];

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              'images/logo.png',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.image),
                    iconSize: 40,
                    onPressed: () {
                      // Add your camera button logic here
                    },
                  ),
                  Text("Thư viện")
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    iconSize: 100,
                    onPressed: () {
                      // Add your image gallery button logic here
                    },
                  ),
                  Text("Chụp ảnh")
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
