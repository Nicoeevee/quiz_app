import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/entity/question.dart';

import 'quiz_fitb_page.dart';
import 'quiz_tof_page.dart';

class HomePage extends StatelessWidget {
  Future<String> _loadFromAsset() async {
    return await rootBundle.loadString("assets/quiz.json");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试'),
      ),
      body: FutureBuilder(
          future: _loadFromAsset(),
          builder: (context, snapshot) {
            return ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.rule),
                  title: Text('判断题'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => QuizTOFPage(questions: questionFromJson(snapshot.data).where((element) => element.type == Type.TOF).toList())));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.create),
                  title: Text('填空题'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => QuizFITBPage(questions: questionFromJson(snapshot.data).where((element) => element.type == Type.FITB).toList())));
                  },
                )
              ],
            );
          }),
    );
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
