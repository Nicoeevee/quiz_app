import 'package:data/local/models/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz_app/pages/choice_type_page.dart';
import 'package:quiz_app/widgets/quiz_options_widget.dart';

import 'quiz_fitb_page.dart';
import 'quiz_tof_page.dart';

Future<String> _loadFromAsset() async {
  return await rootBundle.loadString("assets/json/quiz.json");
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              title: Text('主页'),
            ),
          ),
          Positioned(
            top: 32.0,
            right: 8.0,
            child: Image.asset(
              'assets/images/splash_icon.png',
              height: 128,
            ),
          ),
          Center(
            child: FutureBuilder(
                future: _loadFromAsset(),
                builder: (context, snapshot) {
                  return ValueListenableBuilder(
                    valueListenable: Hive.box('settings').listenable(),
                    builder: (BuildContext context, box, Widget child) {
                      final type = box.get('type', defaultValue: null);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlineButton(
                            child: Text(type == null ? '选择工种' : '开始$type测试'),
                            onPressed: () {
                              type == null
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChoiceTypePage(data: snapshot.data, type: type),
                                      ))
                                  : showQuizBottomSheet(context, snapshot);
                            },
                          ),
                          type == null
                              ? Container()
                              : OutlineButton(
                                  child: Text('更改工种'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ChoiceTypePage(data: snapshot.data, type: type),
                                        ));
                                  },
                                ),
                        ],
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  void showQuizBottomSheet(BuildContext context, AsyncSnapshot snapshot) async {
    final Type result = await buildShowModalBottomSheet(context);
    if (result != null) {
      final typeQuestion = questionFromJson(snapshot.data).where((element) => element.type == result).toList();
      switch (result) {
        case Type.FITB:
          Navigator.push(context, MaterialPageRoute(builder: (_) => QuizFITBPage(questions: typeQuestion)));
          break;
        case Type.TOF:
          Navigator.push(context, MaterialPageRoute(builder: (_) => QuizTOFPage(questions: typeQuestion)));
          break;
      }
    }
  }
}
