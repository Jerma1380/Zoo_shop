import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
  
  
  class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePage();
}

class _CreatePage extends State<CreatePage> {

  List pets = [];

  

  


  
  
  
  final TextEditingController _titleState = TextEditingController();
  final TextEditingController _dataState = TextEditingController();
  final TextEditingController _imageState = TextEditingController();


 
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
                      onPressed: () {
                        Map<String, dynamic> newPet = {
                          "title": _titleState.text,
                          "data": _dataState.text,
                          "image_url": _imageState.text
                          };
                        if (newPet.isNotEmpty) {
                          Navigator.pop(context, newPet);

                        }
                      },
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


  
}