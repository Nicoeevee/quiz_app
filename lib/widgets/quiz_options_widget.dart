import 'package:data/local/models/question.dart';
import 'package:flutter/material.dart';

import 'screen_size_widget.dart';

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
