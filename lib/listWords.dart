import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_teste/editionText.dart';

enum ViewType { grid, list }

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class Words {
  List<String> _words = [];

  List<String> getAllWords() {
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
  List<String> _word = Words().getAllWords();

  static dynamic fromJson(Map<String, dynamic> json) =>
      {'name': json['name'], 'id': json['id']};

  Stream<List<dynamic>> readUsers() => FirebaseFirestore.instance
      .collection('languages')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listagem de Linguagem de programação'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditionText(
                      words: '',
                      index: '',
                      isEdit: false,
                    ),
                  )).then((_) => setState(() {}));
            },
            icon: Icon(Icons.add),
          )
        ],
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
    return StreamBuilder<List<dynamic>>(
      stream: readUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final languages = snapshot.data!;
          print(languages);
          return GridView.builder(
              itemCount: languages.length,
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _crossAxisCount,
                childAspectRatio: _viewType == ViewType.grid ? 1 : 10,
              ),
              itemBuilder: (BuildContext _context, int i) {
                final int index = i;
                index == 20 ? index - 1 : index;
                final alreadySaved = _saved.contains(languages[index]['name']);
                return _buildRowCollumns(languages[index]['name'], alreadySaved,
                    languages[index]['id']);
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    //
  }

  Widget _buildRowCollumns(pair, alreadySaved, index) {
    // final largura = MediaQuery.of(context).size.width;
    if (_viewType == ViewType.grid) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditionText(
                  words: pair,
                  index: index,
                  isEdit: true,
                ),
              )).then((_) => setState(() {}));
        },
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Column(children: [
            Text(
              pair,
              style: _biggerFont,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () {
                final docLanguage = FirebaseFirestore.instance
                    .collection('languages')
                    .doc(index);
                docLanguage.delete();
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
          ]),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              child: Text(
                pair,
                style: _biggerFont,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditionText(
                        words: pair,
                        index: index,
                        isEdit: true,
                      ),
                    )).then((_) => setState(() {}));
              },
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.delete,
                ),
                onPressed: () {
                  final docLanguage = FirebaseFirestore.instance
                      .collection('languages')
                      .doc(index);
                  docLanguage.delete();
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
    }
  }
}
