import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:quiz_app/entity/question.dart';

class ChoiceTypePage extends StatefulWidget {
  final data;
  final String type;

  ChoiceTypePage({Key key, this.data, this.type}) : super(key: key);

  @override
  _ChoiceTypePageState createState() => _ChoiceTypePageState();
}

class _ChoiceTypePageState extends State<ChoiceTypePage> {
  @override
  Widget build(BuildContext context) {
    _MySearchDelegate _delegate = _MySearchDelegate(typeOfWork, widget.data);

    return Scaffold(
      appBar: AppBar(
        primary: true,
        title: Text('目录'),
        actions: <Widget>[
          IconButton(
            tooltip: '搜索',
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String selected = await showSearch<String>(
                context: context,
                delegate: _delegate,
              );
              if (selected != null) {
                debugPrint('你选择了: $selected');
              }
            },
          ),
        ],
      ),
      body: Scrollbar(
        child: GridView.builder(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8.0),
          itemCount: typeOfWork.length,
          itemBuilder: (BuildContext context, int index) {
            final item = typeOfWork[index];
            return buildCard(
              context,
              item,
              onTap: () async {
                Hive.box('settings').put('type', item);
                Navigator.pop(context);
                // final Type result = await buildShowModalBottomSheet(context);
                // if (result != null) {
                //   final typeQuestion = questionFromJson(widget.data).where((element) => element.type == result).toList();
                //   switch (result) {
                //     case Type.FITB:
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => QuizFITBPage(questions: typeQuestion)));
                //       break;
                //     case Type.TOF:
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => QuizTOFPage(questions: typeQuestion)));
                //       break;
                //   }
                // }
              },
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: bBigSize(context) ? 5 : 3,
          ),
        ),
      ),
    );
  }
}

Card buildCard(BuildContext context, String item, {VoidCallback onTap}) {
  return Card(
    child: InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: AutoSizeText(item,
            minFontSize: 10.0,
            textAlign: TextAlign.center,
            maxLines: 3,
            wrapWords: false,
            style: bBigSize(context)
                ? GoogleFonts.zcoolQingKeHuangYou(fontSize: 30.0, color: Colors.white)
                : GoogleFonts.zcoolQingKeHuangYou(
                    color: Colors.white,
                  )),
      ),
    ),
    color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
  );
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

final List<String> typeOfWork = <String>[
  "测量工题库",
  "混凝土工",
  "爆破工",
  "化验员",
  "钢筋工",
  "混凝土模具工",
  "搅拌站",
  "砌筑工",
  "施工安全员",
  "支护工",
  "装修工",
  "通风空调工",
  "管道工",
  "工程电工（维修工）",
  "电气设备安装工",
  "机械设备安装工",
  "工程机械操作手",
  "钻孔机械操作手",
  "焊工",
  "钳工",
  "地下工程钻探工",
  "高空作业车操作手",
  "机加工",
  "电动扒渣机操作手"
];

bool bBigSize(BuildContext context) => MediaQuery.of(context).size.width > 800;

class _MySearchDelegate extends SearchDelegate<String> {
  List<String> _allTypes;
  List<String> _history;
  final _data;

  _MySearchDelegate(List<String> types, data)
      : _allTypes = types,
        _data = data,
        _history = <String>[],
        super();

  @override
  String get searchFieldLabel => "按工种搜索";

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: '返回',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        // SearchDelegate.close() can return vlaues, similar to Navigator.pop().
        this.close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> suggestions = this.query.isEmpty ? _history : _allTypes.where((word) => word.contains(query)).toList();

    return suggestions.isEmpty
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('没有找到工种'),
                GestureDetector(
                  onTap: () {
                    // Returns this.query as result to previous screen, c.f.
                    // `showSearch()` above.
                    this.close(context, null);
                  },
                  child: Text(
                    this.query,
                    style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        : Scrollbar(
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              itemCount: suggestions.length,
              itemBuilder: (BuildContext context, int index) {
                final item = suggestions[index];
                return buildCard(
                  context,
                  item,
                  onTap: () async {
                    Hive.box('settings').put('type', item);
                    this.close(context, null);
                    Navigator.pop(context);
                    // final Type result = await buildShowModalBottomSheet(context);
                    // if (result != null) {
                    //   this.close(context, this.query);
                    //   final typeQuestion = questionFromJson(_data).where((element) => element.type == result).toList();
                    //   switch (result) {
                    //     case Type.FITB:
                    //       Navigator.push(context, MaterialPageRoute(builder: (_) => QuizFITBPage(questions: typeQuestion)));
                    //       break;
                    //     case Type.TOF:
                    //       Navigator.push(context, MaterialPageRoute(builder: (_) => QuizTOFPage(questions: typeQuestion)));
                    //       break;
                    //   }
                    // }
                  },
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: bBigSize(context) ? 5 : 3,
              ),
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions = this.query.isEmpty ? _history : _allTypes.where((word) => word.contains(query));

    return _SuggestionList(
      query: this.query,
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        this.query = suggestion;
        this._history
          ..remove(suggestion)
          ..insert(0, suggestion);
        showResults(context);
      },
    );
  }

  // Action buttons at the right of search bar.
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? IconButton(
              tooltip: '语音搜索',
              icon: const Icon(Icons.mic),
              onPressed: () {
                this.query = 'TODO: 实现语音输入';
              },
            )
          : IconButton(
              tooltip: '清空',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
    ];
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        var index = suggestion.indexOf(query);
        return ListTile(
          leading: query.isEmpty ? Icon(Icons.history) : Icon(null),
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, index),
              style: textTheme,
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(index, index + query.length),
                  style: textTheme.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: suggestion.substring(index + query.length),
                  style: textTheme,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
