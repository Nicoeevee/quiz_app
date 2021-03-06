import 'package:data/local/models/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:quiz_app/pages/quiz_finished_page.dart';
import 'package:quiz_app/widgets/screen_size_widget.dart';

class QuizFITBPage extends StatefulWidget {
  final List<Question> questions;

  const QuizFITBPage({Key key, @required this.questions}) : super(key: key);

  @override
  _QuizFITBPageState createState() => _QuizFITBPageState();
}

class _QuizFITBPageState extends State<QuizFITBPage> {
  final TextStyle _questionStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white);
  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool showResult = false;
  var controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void _prevSubmit() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        showResult = true;
      });
      controller.text = _answers[_currentIndex];
    }
  }

  void _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      setState(() {
        showResult = true;
      });
    }
  }

  void _nextSubmit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (_currentIndex < (widget.questions.length - 1)) {
        setState(() {
          _currentIndex++;
          showResult = _answers[_currentIndex] != null || false;
        });
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => QuizFinishedPage(questions: widget.questions, answers: _answers)));
      }
    }
    controller.text = _answers[_currentIndex] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    Question question = widget.questions[_currentIndex];
    // final List<dynamic> answer = question.answer.split(' ');
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _key,
        appBar: AppBar(
          title: Text("${typeValues.reverse[question.type]} ${_currentIndex + 1}/${widget.questions.length}"),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  value: _currentIndex / widget.questions.length,
                ),
                ClipPath(
                  clipper: WaveClipperTwo(),
                  child: Container(
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                    height: 200,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                direction: bBigSize(context) ? Axis.horizontal : Axis.vertical,
                children: [
                  Flexible(
                    child: Row(
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
                            style: bBigSize(context) ? _questionStyle.copyWith(fontSize: 30.0) : _questionStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  bBigSize(context) ? Container() : SizedBox(height: 16.0),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Form(
                                key: formKey,
                                autovalidateMode: AutovalidateMode.disabled,
                                child: TextFormField(
                                  decoration: const InputDecoration(labelText: '作答'),
                                  keyboardType: TextInputType.text,
                                  onSaved: (value) {
                                    setState(() {
                                      _answers[_currentIndex] = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return '请作答';
                                    }
                                    return null;
                                  },
                                  controller: controller,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              !showResult || _answers[_currentIndex] == null
                                  ? Container()
                                  : Column(
                                      children: [
                                        Text(
                                          _answers[_currentIndex],
                                          style: TextStyle(color: question.answer == _answers[_currentIndex] ? Colors.green : Colors.red, fontSize: 18.0, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5.0),
                                        Text.rich(
                                          TextSpan(children: [TextSpan(text: "答案："), TextSpan(text: question.answer, style: TextStyle(fontWeight: FontWeight.w500))]),
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: _submit,
          child: Icon(Icons.search_rounded),
          tooltip: '检查',
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Theme.of(context).primaryColor,
          notchMargin: 5,
          child: SizedBox(
            height: bBigSize(context) ? 64 : null,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: IconButton(
                    // padding: calPadding(context),
                    onPressed: _prevSubmit,
                    tooltip: '上一题',
                    icon: Icon(
                      Icons.chevron_left_rounded,
                      color: Theme.of(context).buttonColor,
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    // padding: calPadding(context),
                    onPressed: _nextSubmit,
                    tooltip: _currentIndex == (widget.questions.length - 1) ? '提交' : '下一题',
                    icon: Icon(
                      _currentIndex == (widget.questions.length - 1) ? Icons.done_outlined : Icons.chevron_right_rounded,
                      color: Theme.of(context).buttonColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
