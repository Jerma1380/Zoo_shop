import 'package:flutter/material.dart';
import 'package:pks3/pages/create_page.dart';
import 'favorites_page.dart'; 
import 'profile_page.dart'; 
import 'cart_page.dart'; 
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List pets = [];
  List<Map<String, dynamic>> favorites = []; 
  List<Map<String, dynamic>> cart = []; 
  int _currentIndex = 0; 

  Future<void> readJson() async {
    String contents = await rootBundle.loadString('lib/components/products.json');
    Map<String, dynamic> jsonFileContent = await jsonDecode(contents);
    setState(() {
      pets = jsonFileContent["pets"];
    });
  }

  Future<void> addNewData(Map<String, dynamic> result) async {
    final file = File('lib/components/products.json');
    String contents = await file.readAsString();
    Map<String, dynamic> jsonFileContent = await jsonDecode(contents);
    pets.add(result);
    jsonFileContent['pets'] = pets;
    await file.writeAsString(jsonEncode(jsonFileContent));
    setState(() {});
  }

  Future<void> removePet(int index) async {
    final file = File('lib/components/products.json');
    String contents = await file.readAsString();

    Map<String, dynamic> jsonFileContent = jsonDecode(contents);

    pets.removeAt(index);
    jsonFileContent['pets'] = pets;

    await file.writeAsString(jsonEncode(jsonFileContent));

    setState(() {});
  }

  void _navigateToAddPetScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatePage()),
    );

    if (result != null && result.isNotEmpty) {
      addNewData(result);
    }
  }

  void toggleFavorite(Map<String, dynamic> pet) {
    setState(() {
      if (favorites.contains(pet)) {
        favorites.remove(pet);
      } else {
        favorites.add(pet);
      }
    });
  }

  void addToCart(Map<String, dynamic> pet) {
    setState(() {
      final petIndex = pets.indexOf(pet);
      if (petIndex == -1) return;
      pet['id'] = petIndex;
      final existingItemIndex = cart.indexWhere((item) => item['id'] == pet['id']);
      if (existingItemIndex != -1) {
        cart[existingItemIndex]['quantity'] += 1;
      } else {
        cart.add({
          'id': pet['id'],
          'title': pet['title'],
          'price': pet['price'],
          'quantity': 1,
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${pet['title']} добавлен в корзину!"),
          duration: const Duration(seconds: 1),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  void removeFromCart(Map<String, dynamic> item) {
    setState(() {
      cart.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildMainPage(),
      
      CartPage(
        cart: cart,
        onRemove: (item) {
          removeFromCart(item);
        },
      ),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }

  Widget _buildMainPage() {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Каталог услуг',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    ),
    body: pets.isEmpty
        ? const Center(
            child: Text(
              'Товаров пока нет!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: pets.length,
            itemBuilder: (context, index) {
              return Card(
               
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300), // Легкая граница
                    borderRadius: BorderRadius.circular(12.0), // Закругленные углы
                    color: Colors.white, // Белый фон (меняем только фон здесь)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        pets[index]["title"],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Duration (hardcoded example)
                      Text(
                        '${pets[index]["duration"] ?? "1 день"}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Price
                      Text(
                        '${pets[index]["price"]} ₽', // Ruble sign
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Button aligned right
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            addToCart(pets[index]);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue, // Button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                          ),
                          child: const Text(
                            'Добавить',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
  );
}

}
