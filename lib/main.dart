import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:navigation/Screens/business_screen.dart';
import 'package:navigation/Screens/create_user.dart';
import 'package:navigation/Screens/gaugechart_screen.dart';
import 'package:navigation/Screens/linechart_screen.dart';
import 'package:navigation/Screens/list_screen.dart';
import 'package:navigation/Screens/login_screen.dart';
import 'package:navigation/Screens/pdf_screen.dart';
import 'package:navigation/Screens/piechart_screen.dart';
import 'package:navigation/Screens/school_screen.dart';
import 'package:navigation/Screens/splash_screen.dart';
import 'package:navigation/Screens/test_screen.dart';
import 'package:navigation/Screens/webview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkLogin() async {
    return await SessionManager().containsKey('userid');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
          future: checkLogin(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == false) {
              return SplashScreen();
            } else {
              return MyHomePage(
                widgetBefore: businessScreen(),
                title: 'Demo',
              );
            }
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.widgetBefore, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final Widget widgetBefore;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late LoginScreen loginScreen;

  String content = "";

  late Widget _appWidget;

  void initState() {
    super.initState();
    _appWidget = widget.widgetBefore;
  }

  void _update(Widget nextPage) {
    setState(() {
      _appWidget = nextPage;
    });
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    businessScreen(),
    SchoolScreen(),
  ];

  void _onItemTapped(int index) {
    print("tapped $index");
    setState(() {
      _selectedIndex = index;
      _appWidget = _widgetOptions[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Login'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                setState(() {
                  // appWidget = Text("This is Login Page");
                  _appWidget = LoginScreen(
                    update: (Widget nextPage) {
                      _update(nextPage);
                    },
                  );
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Create User'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                setState(() {
                  _appWidget = CreateUserScreen();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('List Karyawan'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                setState(() {
                  _appWidget = ListScreen();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Pie Chart'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                setState(() {
                  _appWidget = PieChartScreen();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Line Chart'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                setState(() {
                  _appWidget = LineChartSample1();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Gauge Chart'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                setState(() {
                  _appWidget = GaugeChartScreen();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Pdf Report'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                setState(() {
                  _appWidget = PdfScreen();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Webview'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                setState(() {
                  _appWidget = WebViewScreen();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Test'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                setState(() {
                  _appWidget = testScreen();
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _appWidget,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
