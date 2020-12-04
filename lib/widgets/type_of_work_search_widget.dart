import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'screen_size_widget.dart';
import 'type_of_work_card_widget.dart';

class MySearchDelegate extends SearchDelegate<String> {
  List<String> _allTypes;
  List<String> _history;

  MySearchDelegate(List<String> types)
      : _allTypes = types,
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

    return SuggestionList(
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

class SuggestionList extends StatelessWidget {
  const SuggestionList({this.suggestions, this.query, this.onSelected});

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
