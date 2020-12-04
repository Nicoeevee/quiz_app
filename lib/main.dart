import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz_app/pages/home_page.dart';
import 'package:quiz_app/pages/me_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settings');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[HomePage(), MePage()];
  static Map<String, dynamic> _widgetTitle = {
    '主页': Icons.category,
    '我的': Icons.person,
  };

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
      title: 'Quiz - ${_widgetTitle.keys.elementAt(_selectedIndex)}',
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _widgetTitle.entries
              .map((e) => BottomNavigationBarItem(
                    icon: Icon(e.value),
                    label: e.key,
                  ))
              .toList(),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
