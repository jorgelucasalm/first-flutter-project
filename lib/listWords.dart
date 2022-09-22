import 'dart:io';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

enum ViewType { grid, list }

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class Words {
  List<String> _words = [];

  List getAllWords() {
    _words = [
      'Flutter',
      'CSS',
      'HTML',
      'C',
      'C+',
      'C++',
      'C#',
      'PHP',
      'Java',
      'Javascript',
      'ReactJS',
      'React Native',
      'Jack',
      'Assembly',
      'Vue JS',
      'Ruby',
      'Python',
      'TypeScript',
      'Visual Studio',
      'Intellij',
    ];
    return _words;
  }
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <String>[];
  final _saved = <String>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  int _crossAxisCount = 2;
  ViewType _viewType = ViewType.grid;
  final _word = Words().getAllWords();

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

    // return Column(
    //   children: _word.asMap().entries.map((text) {
    //     if (text.key.isOdd && _viewType == ViewType.list) {
    //       return const Divider();
    //     }

    //     final int index = text.key;
    //     index == 20 ? index - 1 : index;

    //     final alreadySaved = _saved.contains(_word[index]);
    //     return _buildRowCollumns(_word[index], alreadySaved);
    //   }).toList(),
    // );

    return GridView.builder(
        itemCount: _word.length,
        padding: const EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _crossAxisCount,
          childAspectRatio: _viewType == ViewType.grid ? 1 : 10,
        ),
        itemBuilder: (BuildContext _context, int i) {
          final int index = i;
          index == 20 ? index - 1 : index;
          final alreadySaved = _saved.contains(_word[index]);

          return _buildRowCollumns(_word[index], alreadySaved);
        });
  }

  Widget _buildRowCollumns(pair, alreadySaved) {
    // final largura = MediaQuery.of(context).size.width;
    if (_viewType == ViewType.grid) {
      return Card(
        margin: const EdgeInsets.all(16),
        child: Column(children: [
          Text(
            pair,
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            pair,
            style: _biggerFont,
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.delete,
                ),
                onPressed: () {
                  setState(() {
                    _word.removeWhere((item) => item == pair);
                  });
                },
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
            ],
          )
        ],
      );

      // ListTile(
      //   title: Text(
      //     pair,
      //     style: _biggerFont,
      //   ),
      //   trailing: Icon(
      //     alreadySaved ? Icons.favorite : Icons.favorite_border,
      //     color: alreadySaved ? Colors.purple : null,
      //     semanticLabel: alreadySaved ? 'Removido' : 'Salvo',
      //   ),
      //   onTap: () {
      //     setState(() {
      //       //lógica da troca de estado
      //       if (alreadySaved) {
      //         _saved.remove(pair);
      //       } else {
      //         _saved.add(pair);
      //       }
      //     });
      //   },
      // );
    }
  }
}
