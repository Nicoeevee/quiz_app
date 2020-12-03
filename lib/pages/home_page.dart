import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz_app/entity/question.dart';
import 'package:quiz_app/pages/choice_type.dart';

import 'quiz_fitb_page.dart';
import 'quiz_tof_page.dart';

Future<String> _loadFromAsset() async {
  return await rootBundle.loadString("assets/quiz.json");
}

Future<Type> buildShowModalBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      final bigTextStyle = const TextStyle(fontSize: 16.0);
      final bigEdgeInsets = const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0);
      int _noOfQuestions = 10;
      Difficulty _difficulty = Difficulty.PRIMARY;
      Type _quizType = Type.FITB;
      bool processing = false;
      return StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setModalState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Text(
                  "数量",
                  style: bBigSize(context) ? bigTextStyle : null,
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  runSpacing: 16.0,
                  spacing: 16.0,
                  children: List.generate(5, (index) => (index + 1) * 10)
                      .map((e) => ChoiceChip(
                            padding: bBigSize(context) ? bigEdgeInsets : null,
                            label: Text(
                              '$e',
                              style: bBigSize(context) ? bigTextStyle : null,
                            ),
                            selected: _noOfQuestions == e,
                            onSelected: (bool selected) {
                              setModalState(() {
                                _noOfQuestions = e;
                              });
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  "等级",
                  style: bBigSize(context) ? bigTextStyle : null,
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  runSpacing: 16.0,
                  spacing: 16.0,
                  children: Difficulty.values
                      .map((Difficulty e) => ChoiceChip(
                            padding: bBigSize(context) ? bigEdgeInsets : null,
                            label: Text(
                              difficultyValues.reverse[e],
                              style: bBigSize(context) ? bigTextStyle : null,
                            ),
                            selected: _difficulty == e,
                            onSelected: (bool selected) {
                              setModalState(() {
                                _difficulty = e;
                              });
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  "题型",
                  style: bBigSize(context) ? bigTextStyle : null,
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  runSpacing: 16.0,
                  spacing: 16.0,
                  children: Type.values
                      .map((e) => ChoiceChip(
                            padding: bBigSize(context) ? bigEdgeInsets : null,
                            label: Text(
                              typeValues.reverse[e],
                              style: bBigSize(context) ? bigTextStyle : null,
                            ),
                            selected: _quizType == e,
                            onSelected: (bool selected) {
                              setModalState(() {
                                _quizType = e;
                              });
                              //
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                processing
                    ? CircularProgressIndicator()
                    : FloatingActionButton(
                        tooltip: '开始',
                        onPressed: () {
                          Navigator.pop(context, _quizType);
                        },
                        child: Icon(Icons.done_rounded),
                      ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    },
  );
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
