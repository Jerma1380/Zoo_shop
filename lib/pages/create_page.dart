  import 'package:flutter/material.dart';
  import 'package:pks3/pages/home_page.dart';
  import 'package:pks3/components/item_note.dart';
  import 'dart:io';
  import 'package:image_picker/image_picker.dart';
  import 'package:file_picker/file_picker.dart';
  
  class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePage();
}

class _CreatePage extends State<CreatePage> {

  
  
  final TextEditingController _titleState = TextEditingController();
  final TextEditingController _dataState = TextEditingController();
  final TextEditingController _imageState = TextEditingController();

 void _addNote() {
    if (_titleState.text.isNotEmpty &&
        _dataState.text.isNotEmpty &&
        _imageState.text.isNotEmpty) {
      setState(() {
        titleNotes.add(_titleState.text);
        data.add(_dataState.text);
        picture.add(_imageState.text); 
      });

      _titleState.clear();
      _dataState.clear();
      _imageState.clear(); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Заполните все поля'),
        ),
      );
    }
  }

  
  void _removeNoteAt(int index) {
    setState(() {
      titleNotes.removeAt(index);
      data.removeAt(index);
      picture.removeAt(index);
    });
  }
 
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Каталог',
          textAlign: TextAlign.left,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35), 
        ), 
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: titleNotes.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: ItemNote(
                    title: titleNotes[index],
                    data: data[index],
                    picture: picture[index],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                _confirmRemoval(index); 
              },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(decoration: BoxDecoration(color: const Color.fromARGB(255, 143, 218, 255), borderRadius: BorderRadius.circular(12.0)),
              child: Column(
                children: [
                  TextField(
                    controller: _titleState,
                    decoration: const InputDecoration(labelText: 'Название товара', labelStyle: TextStyle(color: Color.fromARGB(255, 62, 61, 61))),
                  ),
                  TextField(
                    controller: _dataState,
                    decoration: const InputDecoration(labelText: 'Описание', labelStyle: TextStyle(color: Color.fromARGB(255, 62, 61, 61))),
                  ),
                  const SizedBox(height: 10),
                
                 
                  TextField(
                    controller: _imageState,
                    decoration: const InputDecoration(
                      labelText: 'Ссылка на изображение',
                      labelStyle: TextStyle(color: Color.fromARGB(255, 62, 61, 61)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _addNote,
                      child: const Text('Добавить запись', style: TextStyle(color: Color.fromARGB(255, 62, 61, 61)),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

void _confirmRemoval(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтвердите удаление', style: TextStyle(color: Color.fromARGB(255, 62, 61, 61))),
          content: const Text('Вы уверены, что хотите удалить эту запись?', style: TextStyle(color: Color.fromARGB(255, 62, 61, 61))),
          actions: [
            TextButton(
              child: const Text('Отмена', style: TextStyle(color: Color.fromARGB(255, 62, 61, 61))),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
              onPressed: () {
                
                setState(() {
                  titleNotes.removeAt(index);
                  data.removeAt(index);
                  picture.removeAt(index);
                });
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }
  
}