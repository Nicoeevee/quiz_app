import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quiz_app/pages/me.dart';

import 'pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

Future<String> _loadFromAsset() async {
  return await rootBundle.loadString("assets/quiz.json");
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    FutureBuilder(
        future: _loadFromAsset(),
        builder: (context, snapshot) {
          return HomePage(
            data: snapshot.data,
          );
        }),
    MePage()
  ];
  static List<String> _widgetTitle = <String>['目录', '我的'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
        var result = supportedLocales.where((element) => element.languageCode == locale.languageCode);
        if (result.isNotEmpty) {
          return locale;
        }
        return Locale('zh');
      },
      debugShowCheckedModeBanner: false,
      title: _widgetTitle[_selectedIndex],
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.category), label: '目录'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
