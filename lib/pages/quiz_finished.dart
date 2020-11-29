import 'package:flutter/material.dart';

import '../entity/question.dart';
import 'check_answers.dart';

class QuizFinishedPage extends StatelessWidget {
  final List<Question> questions;
  final Map<int, dynamic> answers;

  int correctAnswers;

  QuizFinishedPage({Key key, @required this.questions, @required this.answers}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    int correct = 0;
    this.answers.forEach((index, value) {
      if (this.questions[index].answer == value) correct++;
    });
    final TextStyle titleStyle = TextStyle(color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.w500);
    final TextStyle trailingStyle = TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        title: Text('结果'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Theme.of(context).primaryColor, Theme.of(context).accentColor], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("总题数", style: titleStyle),
                  trailing: Text("${questions.length}", style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("得分", style: titleStyle),
                  trailing: Text("${(correct / questions.length * 100).toStringAsFixed(2)}%", style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("正确答案", style: titleStyle),
                  trailing: Text("$correct/${questions.length}", style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("错误答案", style: titleStyle),
                  trailing: Text("${questions.length - correct}/${questions.length}", style: trailingStyle),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text("返回主页"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text("检查答案"),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => CheckAnswersPage(
                                questions: questions,
                                answers: answers,
                              )));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
