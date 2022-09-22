import 'dart:io';

import 'package:flutter/material.dart';

class EditionText extends StatefulWidget {
  List<String> words;
  int index;

  EditionText({required this.words, required this.index});

  @override
  _EditionText createState() => _EditionText();
}

class _EditionText extends State<EditionText> {
  List<String> words = [];
  String initialWord = '';
  int index = 0;
  final txtController = TextEditingController(text: '');

  void initState() {
    super.initState();
    words = widget.words;
    index = widget.index;
    initialWord = words[widget.index];
    txtController.text = initialWord;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerador de Nomes'),
      ),
      body: Container(
        child: _buildCard(),
      ),
    );
  }

  Widget _buildCard() {
    return Column(
      children: [
        Padding(
          padding: new EdgeInsets.all(10.0),
          child: TextFormField(
            controller: txtController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              child: const Text('Voltar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 15),
            ElevatedButton(
              onPressed: () {
                words[index] = txtController.text;
              },
              child: const Text('Salvar'),
            ),
          ],
        )
      ],
    );
  }
}
