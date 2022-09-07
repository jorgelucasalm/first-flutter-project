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
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  int _crossAxisCount = 2;
  ViewType _viewType = ViewType.grid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerador de Nomes'),
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

          final int index = i ~/ 1;

          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          final alreadySaved = _saved.contains(_suggestions[index]);

          return _buildRowCollumns(_suggestions[index], alreadySaved);

          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
            trailing: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color:
                  alreadySaved ? const Color.fromARGB(255, 255, 115, 0) : null,
              semanticLabel: alreadySaved ? 'Removido' : 'Salvo',
            ),
            onTap: () {
              setState(() {
                //lógica da troca de estado
                if (alreadySaved) {
                  _saved.remove(_suggestions[index]);
                } else {
                  _saved.add(_suggestions[index]);
                }
              });
            },
          );
        });
  }

  Widget _buildRowCollumns(WordPair pair, alreadySaved) {
    // final largura = MediaQuery.of(context).size.width;
    if (_viewType == ViewType.grid) {
      return Card(
        margin: const EdgeInsets.all(16),
        child: Column(children: [
          Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
          IconButton(
            icon: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.purple : null,
              semanticLabel: alreadySaved ? 'Removido' : 'Salvo',
            ),
            onPressed: () {
              setState(() {
                //lógica da troca de estado
                if (alreadySaved) {
                  _saved.remove(pair);
                } else {
                  _saved.add(pair);
                }
              });
            },
          ),
        ]),
      );
    } else {
      return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.purple : null,
          semanticLabel: alreadySaved ? 'Removido' : 'Salvo',
        ),
        onTap: () {
          setState(() {
            //lógica da troca de estado
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
      );
    }
  }
}
