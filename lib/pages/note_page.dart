import 'package:flutter/material.dart';


class Data extends StatelessWidget {
  const Data({super.key, required this.pet});
  final Map<String, dynamic> pet;



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
              Image.network(pet["image_url"], width: 580, height: 320, fit: BoxFit.fill, 
              loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return const Center(
      child: CircularProgressIndicator(),
    );
  },
  errorBuilder: (context, error, stackTrace) {
    return const Center(
      child: Icon(
        Icons.broken_image,
        size: 50,
        color: Colors.grey,
      ),
    );
  },
),  
              const SizedBox(height: 30),
              Text(pet["data"], style: const TextStyle(color: Color.fromARGB(255, 62, 61, 61),fontSize: 26),),
            ],
          ),
        ),
      ),
      
    );
  }
}