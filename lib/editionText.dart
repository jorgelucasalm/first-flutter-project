import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditionText extends StatefulWidget {
  String words;
  String index;
  bool isEdit;

  EditionText({required this.words, required this.index, required this.isEdit});

  @override
  _EditionText createState() => _EditionText();
}

class _EditionText extends State<EditionText> {
  String words = '';
  String initialWord = '';
  String index = '';
  bool isEdit = false;
  final txtController = TextEditingController(text: '');

  void initState() {
    super.initState();
    words = widget.words;
    index = widget.index;
    isEdit = widget.isEdit;
    initialWord = widget.isEdit ? words : '';
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
                  final docLanguage = FirebaseFirestore.instance
                      .collection('languages')
                      .doc(index);
                  docLanguage.update({
                    'name': txtController.text,
                  });
                  Navigator.pop(context);
                } else {
                  createLanguage(name: txtController.text);
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

  Future createLanguage({required String name}) async {
    final docLanguage =
        FirebaseFirestore.instance.collection('languages').doc();
    final language = {'name': name, 'id': docLanguage.id};

    await docLanguage.set(language);
  }
}
