import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quiz_app/widgets/screen_size_widget.dart';
import 'package:quiz_app/widgets/type_of_work_card_widget.dart';
import 'package:quiz_app/widgets/type_of_work_search_widget.dart';

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
    MySearchDelegate _delegate = MySearchDelegate(typeOfWork, widget.data);

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
