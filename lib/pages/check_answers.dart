import 'package:flutter/material.dart';
import 'package:quiz_app/entity/question.dart';

class CheckAnswersPage extends StatelessWidget {
  final List<Question> questions;
  final Map<int, dynamic> answers;

  const CheckAnswersPage({Key key, @required this.questions, @required this.answers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('检查答案'),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: questions.length + 1,
            itemBuilder: _buildItem,
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == questions.length) {
      return RaisedButton(
        child: Text("完成"),
        onPressed: () {
          Navigator.of(context).popUntil(ModalRoute.withName(Navigator.defaultRouteName));
        },
      );
    }
    Question question = questions[index];
    bool correct = question.answer == answers[index];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              question.exercise,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16.0),
            ),
            SizedBox(height: 5.0),
            Text(
              answers[index],
              style: TextStyle(color: correct ? Colors.green : Colors.red, fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            correct
                ? Container()
                : Text.rich(
                    TextSpan(children: [TextSpan(text: "答案："), TextSpan(text: question.answer, style: TextStyle(fontWeight: FontWeight.w500))]),
                    style: TextStyle(fontSize: 16.0),
                  )
          ],
        ),
      ),
    );
  }
}
