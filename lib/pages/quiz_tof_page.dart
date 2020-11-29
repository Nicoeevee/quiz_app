import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:quiz_app/pages/quiz_finished.dart';

import '../entity/question.dart';

class QuizTOFPage extends StatefulWidget {
  final List<Question> questions;

  const QuizTOFPage({Key key, @required this.questions}) : super(key: key);

  @override
  _QuizTOFPageState createState() => _QuizTOFPageState();
}

class _QuizTOFPageState extends State<QuizTOFPage> {
  final TextStyle _questionStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white);
  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool showResult = false;

  void _prevSubmit() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        showResult = true;
      });
    }
  }

  void _submit() {
    if (_answers[_currentIndex] == null) {
      _key.currentState.showSnackBar(SnackBar(
        content: Text("您必须选择一个答案才能检查。"),
      ));
      return;
    }
    setState(() {
      showResult = true;
    });
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      _key.currentState.showSnackBar(SnackBar(
        content: Text("您必须选择一个答案才能继续。"),
      ));
      return;
    }
    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        _currentIndex++;
        showResult = _answers[_currentIndex] != null || false;
      });
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => QuizFinishedPage(questions: widget.questions, answers: _answers)));
    }
  }

  @override
  Widget build(BuildContext context) {
    Question question = widget.questions[_currentIndex];
    // final List<dynamic> answer = question.answer.split(' ');
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text("${typeValues.reverse[question.type]} ${_currentIndex + 1}/${widget.questions.length}"),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: OutlineButton(
                  onPressed: _prevSubmit,
                  child: Text('上一题'),
                ),
              ),
              Expanded(
                child: OutlineButton(
                  onPressed: _submit,
                  child: Text('检查'),
                ),
              ),
              Expanded(
                child: OutlineButton(
                  onPressed: _nextSubmit,
                  child: Text(
                    _currentIndex == (widget.questions.length - 1) ? "提交" : "下一题",
                    style: MediaQuery.of(context).size.width > 800 ? TextStyle(fontSize: 30.0) : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: Text("${_currentIndex + 1}"),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          widget.questions[_currentIndex].exercise,
                          softWrap: true,
                          style: MediaQuery.of(context).size.width > 800 ? _questionStyle.copyWith(fontSize: 30.0) : _questionStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile(
                          title: Icon(Icons.check,
                              color: !showResult || _answers[_currentIndex] == null
                                  ? Colors.black
                                  : question.answer == '√'
                                      ? Colors.green
                                      : Colors.red),
                          value: '√',
                          onChanged: (value) {
                            setState(() {
                              _answers[_currentIndex] = '√';
                            });
                          },
                          groupValue: _answers[_currentIndex],
                        ),
                        RadioListTile(
                          title: Icon(Icons.clear,
                              color: !showResult || _answers[_currentIndex] == null
                                  ? Colors.black
                                  : question.answer == '×'
                                      ? Colors.green
                                      : Colors.red),
                          value: '×',
                          onChanged: (value) {
                            setState(() {
                              _answers[_currentIndex] = '×';
                            });
                          },
                          groupValue: _answers[_currentIndex],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text("您确定要退出测试吗？您所有的进度都将丢失。"),
            title: Text("警告!"),
            actions: <Widget>[
              FlatButton(
                child: Text("是"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text("否"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }
}
