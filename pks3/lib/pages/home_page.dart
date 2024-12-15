import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pks3/pages/cart_page.dart';
import 'package:pks3/pages/favorites_page.dart';
import 'package:pks3/pages/create_page.dart'; // CreatePage
import 'package:pks3/pages/profile_page.dart'; // Just an import if any other specific UI is needed for profile

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> pets = [];
  List<Map<String, dynamic>> favorites = [];
  List<Map<String, dynamic>> cart = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // Fetch products from the API
  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/products'));
      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedResponse);
        if (jsonResponse is Map<String, dynamic> && jsonResponse['pets'] is List) {
          setState(() {
            pets = jsonResponse['pets']; // Fetching the 'pets' list from response
          });
        }
      }
    } catch (e) {
      print("Error loading products: $e");
    }
  }

  // Add to cart functionality
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

  // Toggle favorite functionality
  void toggleFavorite(Map<String, dynamic> pet) {
    setState(() {
      if (favorites.contains(pet)) {
        favorites.remove(pet);
      } else {
        favorites.add(pet);
      }
    });
  }

  // Remove item from cart
  void removeFromCart(Map<String, dynamic> item) {
    setState(() {
      cart.remove(item);
    });
  }

  // Profile page with conditional login/logout options
  Widget _buildProfilePage(user) {
    if (user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Вы не вошли в систему', style: TextStyle(fontSize: 20)),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Вход'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: const Text('Регистрация'),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Email: ${user.email}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Выйти из аккаунта'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    final List<Widget> pages = [
      _buildMainPage(), // Main catalog page
      FavoritesPage(favorites: favorites),
      CartPage(cart: cart, onRemove: removeFromCart),
      _buildProfilePage(user), // Profile embedded here in HomePage
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue, // Blue color for selected items
        unselectedItemColor: Colors.blueGrey, // Grey color for unselected items
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Избранное'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Корзина'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }

  // Catalog main page displaying products
  Widget _buildMainPage() {
    return Scaffold(
      appBar: AppBar(title: const Text('Каталог')),
      body: pets.isEmpty
          ? const Center(child: Text("Товаров пока нет!"))
          : ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Image.network(pet['image_url'] ?? '', height: 150, fit: BoxFit.cover),
                      Text(pet['title'] ?? "Название неизвестно"),
                      Text('${pet['price']} руб'),
                      ElevatedButton(
                        onPressed: () => addToCart(pet),
                        style: ElevatedButton.styleFrom(
                          iconColor: Colors.blue, // Set button background color to blue
                        ),
                        child: const Text('Добавить в корзину'),
                      ),
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
