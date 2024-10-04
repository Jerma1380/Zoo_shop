import 'package:flutter/material.dart';


class NotePage extends StatelessWidget {
  const NotePage({super.key, required this.picture, required this.data});

 final String picture;
 final String data;

  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: const Color.fromARGB(255, 143, 218, 255),
      
      appBar: AppBar(title: const Text('Описание'),
      ),
      
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Image.network(picture, width: 580, height: 320, fit: BoxFit.fill),
              const SizedBox(height: 30),
              Text(data, style: const TextStyle(color: Color.fromARGB(255, 62, 61, 61),fontSize: 26),),
            ],
          ),
        ),
      ),
      
    );
  }
}