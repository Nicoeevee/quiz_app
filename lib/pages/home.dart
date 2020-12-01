import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiz_app/entity/question.dart';

import 'quiz_tof_page.dart';

class HomePage extends StatelessWidget {
  final data;

  HomePage({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _MySearchDelegate _delegate = _MySearchDelegate(type, data);

    return Scaffold(
      appBar: AppBar(
        primary: true,
        automaticallyImplyLeading: false,
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
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('你选择了: $selected'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: buildGridView(context, type, data),
    );
  }
}

final List<String> level = <String>["初级", "中级", "高级"];
final List<String> type = <String>[
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

Scrollbar buildGridView(BuildContext context, list, data) {
  return Scrollbar(
    child: GridView.builder(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        final item = list[index];
        return buildCard(context, item, data);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: bBigSize(context) ? 5 : 3,
      ),

      // [
      //   ListTile(
      //     leading: Icon(Icons.rule),
      //     title: Text('判断题'),
      //     onTap: () {
      //       Navigator.push(context, MaterialPageRoute(builder: (_) => QuizTOFPage(questions: questionFromJson(snapshot.data).where((element) => element.type == Type.TOF).toList())));
      //     },
      //   ),
      //   ListTile(
      //     leading: Icon(Icons.create),
      //     title: Text('填空题'),
      //     onTap: () {
      //       Navigator.push(context, MaterialPageRoute(builder: (_) => QuizFITBPage(questions: questionFromJson(snapshot.data).where((element) => element.type == Type.FITB).toList())));
      //     },
      //   )
      // ],
    ),
  );
}

Card buildCard(BuildContext context, item, data) {
  return Card(
    child: InkWell(
      onTap: () {
        goToPage(context, data);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(item, style: bBigSize(context) ? TextStyle(fontSize: 30.0, color: Colors.white) : TextStyle(color: Colors.white)),
      ),
    ),
    color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
  );
}

Future goToPage(BuildContext context, data) async {
  final result = await buildShowModalBottomSheet(context);
  if (result != null) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => QuizTOFPage(questions: questionFromJson(data).where((element) => element.type == result).toList())));
  }
}

Future buildShowModalBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      final bigTextStyle = const TextStyle(fontSize: 30.0);
      final bigEdgeInsets = const EdgeInsets.symmetric(vertical: 20.0, horizontal: 64.0);
      return Container(
        height: bBigSize(context) ? 300 : 150,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "选择等级",
                style: bBigSize(context) ? bigTextStyle : null,
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                runSpacing: 16.0,
                spacing: 16.0,
                children: level
                    .map((e) => ActionChip(
                          padding: bBigSize(context) ? bigEdgeInsets : null,
                          label: Text(
                            e,
                            style: bBigSize(context) ? bigTextStyle : null,
                          ),
                          onPressed: () {
                            Navigator.pop(context, Type.TOF);
                          },
                        ))
                    .expand((element) => [element, const SizedBox(width: 8)])
                    .toList(),
              ),
            ],
          ),
        ),
      );
    },
  );
}

bool bBigSize(BuildContext context) => MediaQuery.of(context).size.width > 800;

class _MySearchDelegate extends SearchDelegate<String> {
  final List<String> _types;
  final List<String> _history;
  final _data;

  _MySearchDelegate(List<String> types, data)
      : _types = types,
        _data = data,
        _history = <String>[],
        super();

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
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
    return buildGridView(context, [this.query], _data);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions = this.query.isEmpty ? _history : _types.where((word) => word.contains(query));

    return _SuggestionList(
      query: this.query,
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        this.query = suggestion;
        this._history.insert(0, suggestion);
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
