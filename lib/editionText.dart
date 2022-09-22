import 'dart:io';

import 'package:flutter/material.dart';

class EditionText extends StatefulWidget {
  List<String> words;
  int index;
  bool isEdit;

  EditionText({required this.words, required this.index, required this.isEdit});

  @override
  _EditionText createState() => _EditionText();
}

class _EditionText extends State<EditionText> {
  List<String> words = [];
  String initialWord = '';
  int index = 0;
  bool isEdit = false;
  final txtController = TextEditingController(text: '');

  void initState() {
    super.initState();
    words = widget.words;
    index = widget.index;
    isEdit = widget.isEdit;
    initialWord = widget.isEdit ? words[widget.index] : '';
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
                if (isEdit) {
                  words[index] = txtController.text;
                } else {
                  words.add(txtController.text);
                  Navigator.pop(context);
                }
              },
              child: Text(isEdit ? 'Salvar' : 'Criar'),
            ),
          ],
        )
      ],
    );
  }
}
