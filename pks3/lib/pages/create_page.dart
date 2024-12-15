import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePage();
}

class _CreatePage extends State<CreatePage> {
  final TextEditingController _titleState = TextEditingController();
  final TextEditingController _dataState = TextEditingController();
  final TextEditingController _imageState = TextEditingController();
  final TextEditingController _priceState = TextEditingController(); // Поле для цены

  Future<void> _submitData(BuildContext context) async {
    int price = int.tryParse(_priceState.text) ?? 0;

    // Формируем JSON-объект для отправки на сервер
    Map<String, dynamic> newPet = {
      "title": _titleState.text,
      "data": _dataState.text,
      "image_url": _imageState.text,
      "price": price,
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/add-product'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(newPet),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Закрываем страницу после успешной отправки
      } else {
        throw Exception('Ошибка добавления товара: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Добавление товара',
          textAlign: TextAlign.left,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 143, 218, 255),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _titleState,
                    decoration: const InputDecoration(
                      labelText: 'Название товара',
                      labelStyle: TextStyle(color: Color.fromARGB(255, 62, 61, 61)),
                    ),
                  ),
                  TextField(
                    controller: _dataState,
                    decoration: const InputDecoration(
                      labelText: 'Описание',
                      labelStyle: TextStyle(color: Color.fromARGB(255, 62, 61, 61)),
                    ),
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
                  TextField(
                    controller: _priceState,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Цена (в рублях)',
                      labelStyle: TextStyle(color: Color.fromARGB(255, 62, 61, 61)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => _submitData(context), // Отправляем данные
                      child: const Text(
                        'Добавить запись',
                        style: TextStyle(color: Color.fromARGB(255, 62, 61, 61)),
                      ),
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
