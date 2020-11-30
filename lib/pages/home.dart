import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/entity/question.dart';

import 'quiz_fitb_page.dart';
import 'quiz_tof_page.dart';

class HomePage extends StatelessWidget {
  Future<String> _loadFromAsset() async {
    return await rootBundle.loadString("assets/quiz.json");
  }

  static List<String> type = <String>[
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

  @override
  Widget build(BuildContext context) {
    void _modalBottomSheetMenu(AsyncSnapshot<dynamic> snapshot) {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "选择等级",
                  style: MediaQuery.of(context).size.width > 800 ? TextStyle(fontSize: 30.0) : null,
                ),
                Row(
                  children: [
                    ActionChip(
                      padding: MediaQuery.of(context).size.width > 800 ? const EdgeInsets.symmetric(vertical: 20.0, horizontal: 64.0) : null,
                      label: Text(
                        "低级",
                        style: MediaQuery.of(context).size.width > 800 ? TextStyle(fontSize: 30.0) : null,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => QuizTOFPage(questions: questionFromJson(snapshot.data).where((element) => element.type == Type.TOF).toList())));
                      },
                    ),
                    const SizedBox(width: 8),
                    ActionChip(
                      padding: MediaQuery.of(context).size.width > 800 ? const EdgeInsets.symmetric(vertical: 20.0, horizontal: 64.0) : null,
                      label: Text(
                        "中级",
                        style: MediaQuery.of(context).size.width > 800 ? TextStyle(fontSize: 30.0) : null,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => QuizFITBPage(questions: questionFromJson(snapshot.data).where((element) => element.type == Type.FITB).toList())));
                      },
                    ),
                    const SizedBox(width: 8),
                    ActionChip(
                      padding: MediaQuery.of(context).size.width > 800 ? const EdgeInsets.symmetric(vertical: 20.0, horizontal: 64.0) : null,
                      label: Text(
                        "高级",
                        style: MediaQuery.of(context).size.width > 800 ? TextStyle(fontSize: 30.0) : null,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => QuizTOFPage(questions: questionFromJson(snapshot.data).where((element) => element.type == Type.TOF).toList())));
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    return FutureBuilder(
        future: _loadFromAsset(),
        builder: (context, snapshot) {
          return GridView.count(
              padding: const EdgeInsets.all(8.0),
              crossAxisCount: MediaQuery.of(context).size.width > 800 ? 5 : 3,
              children: type
                  .map((e) => Card(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            _modalBottomSheetMenu(snapshot);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e, style: MediaQuery.of(context).size.width > 800 ? TextStyle(fontSize: 30.0).copyWith(color: Colors.white) : TextStyle(color: Colors.white)),
                          ),
                        ),
                        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                      ))
                  .toList()
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
              );
        });
  }

  ListView buildListView(AsyncSnapshot snapshot) {
    return ListView(
      children: questionFromJson(snapshot.data)
          .map((e) => ListTile(
                title: Text(e.exercise),
              ))
          .toList(),
    );
  }
}
