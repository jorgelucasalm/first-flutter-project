import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

enum ViewType { grid, list }

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  int _crossAxisCount = 2;
  ViewType _viewType = ViewType.grid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(_viewType == ViewType.list ? Icons.list : Icons.grid_view),
        onPressed: () {
          if (_viewType == ViewType.list) {
            _crossAxisCount = 2;
            _viewType = ViewType.grid;
          } else {
            _crossAxisCount = 1;
            _viewType = ViewType.list;
          }
          setState(() {});
        },
      ),
      body: Container(
        child: _buildCard(),
      ),
    );
  }

  Widget _buildCard() {
    // final largura = MediaQuery.of(context).size.width;

    return GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _crossAxisCount,
          childAspectRatio: _viewType == ViewType.grid ? 1 : 10,
        ),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd && _viewType == ViewType.list) {
            return const Divider();
          }

          final int index = i ~/ 2;

          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRowCollumns(_suggestions[index]);
        });
  }

  Widget _buildRowCollumns(WordPair pair) {
    // final largura = MediaQuery.of(context).size.width;
    if (_viewType == ViewType.grid) {
      return Card(
        margin: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        ),
      );
    } else {
      return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
      );
    }
  }
}
