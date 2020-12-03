import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/pages/choice_type.dart';

Future<String> _loadFromAsset() async {
  return await rootBundle.loadString("assets/quiz.json");
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('主页'),
      ),
      body: Center(
        child: OutlineButton(
          child: Text('选择工种'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FutureBuilder(
                      future: _loadFromAsset(),
                      builder: (context, snapshot) {
                        return ChoiceTypePage(
                          data: snapshot.data,
                        );
                      }),
                ));
          },
        ),
      ),
    );
  }
}
