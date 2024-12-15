import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final List<Map<String, dynamic>> favorites;

  const FavoritesPage({Key? key, required this.favorites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Избранное")),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'Ваше избранное пусто.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final pet = favorites[index];
                return ListTile(
                  
                    leading: SizedBox(width: 50, height: 50,
                      child: Image.network(pet["image_url"], height: 30, width: 30, fit: BoxFit.cover, loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 10,
                              color: Colors.grey,
                            ),
                          );
                        },),
                    ), 
                    title: Text(pet["title"]),
                  
                );
              },
            ),
    );
    
  }
  
}

