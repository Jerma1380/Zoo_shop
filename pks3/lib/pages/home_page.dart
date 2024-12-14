import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pks3/pages/cart_page.dart';
import 'package:pks3/pages/favorites_page.dart';
import 'package:pks3/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> pets = []; // Массив товаров
  List<Map<String, dynamic>> favorites = []; // Избранное.
  List<Map<String, dynamic>> cart = []; // Корзина.
  int _currentIndex = 0; // Индекс выбранной страницы.

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Загружаем данные из сервера при старте
  }

  // Получение данных с сервера.
  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/products')); // Убедитесь, что сервер работает

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedResponse); // Декодируем ответ

        setState(() {
          // Сохраняем список товаров
          pets = jsonResponse['pets'];
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print("Error loading products: $e");
    }
  }

  // Добавление нового товара.
  Future<void> addNewData(Map<String, dynamic> result) async {
    pets.add(result);
    setState(() {});
  }

  // Удаление товара.
  Future<void> removePet(int index) async {
    pets.removeAt(index);
    setState(() {});
  }

  void _navigateToAddPetScreen(BuildContext context) async {
    // Реализация навигации для добавления нового товара (если необходимо)
  }

  // Изменение состояния избранного товара.
  void toggleFavorite(Map<String, dynamic> pet) {
    setState(() {
      if (favorites.contains(pet)) {
        favorites.remove(pet);
      } else {
        favorites.add(pet);
      }
    });
  }

  // Добавление товара в корзину
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

  // Удаление товара из корзины
  void removeFromCart(Map<String, dynamic> item) {
    setState(() {
      cart.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildMainPage(),
      FavoritesPage(favorites: favorites),
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
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }

  // Строим главный экран с товарами.
  Widget _buildMainPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Каталог',
          textAlign: TextAlign.left,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _navigateToAddPetScreen(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 143, 218, 255),
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
            ),
            child: const Text(
              '+',
              style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 62, 61, 61)),
            ),
          ),
        ],
      ),
      body: pets.isEmpty
          ? const Center(
              child: Text(
                'Товаров пока нет!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 143, 218, 255),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          pet["image_url"], // Загружаем изображение товара
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        pet["title"], // Название товара
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        pet["data"] ?? 'Описание отсутствует', // Описание товара
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${pet["price"]} рублей', // Цена товара
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Кнопка добавления в корзину
                      ElevatedButton(
  onPressed: () {
    addToCart(pet);
  },
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.blue), // Цвет фона
    foregroundColor: MaterialStateProperty.all(Colors.white), // Цвет текста
  ),
  child: const Text('В корзину'),
),
                      // Кнопка добавления в избранное
                      IconButton(
                        onPressed: () {
                          toggleFavorite(pet);
                        },
                        icon: Icon(
                          favorites.contains(pet)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
