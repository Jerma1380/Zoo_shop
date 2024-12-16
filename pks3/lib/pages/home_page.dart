import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pks3/pages/chat_page.dart';
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
  List<dynamic> filteredPets = []; // List after applying filters
  List<Map<String, dynamic>> favorites = [];
  List<Map<String, dynamic>> cart = [];
  int _currentIndex = 0;

  String searchQuery = ''; // User input for searching
  String priceFilter = 'Все'; // Selected filter for sorting

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // Fetch products from the API
  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8080/products'));
      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedResponse);
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse['pets'] is List) {
          setState(() {
            pets = jsonResponse['pets'];
            filteredPets = pets; // Initialize filteredPets with all products
          });
        }
      }
    } catch (e) {
      print("Error loading products: $e");
    }
  }

  // Update filtered list based on search query and filters
  void _filterProducts() {
    setState(() {
      // Start with search query filter
      filteredPets = pets
          .where((pet) => pet['title']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();

      // Apply sorting if needed
      if (priceFilter == 'По возрастанию цены') {
        filteredPets.sort((a, b) => (a['price'] as num).compareTo(b['price']));
      } else if (priceFilter == 'По убыванию цены') {
        filteredPets.sort((a, b) => (b['price'] as num).compareTo(a['price']));
      }
    });
  }

  // Add to cart functionality
  void addToCart(Map<String, dynamic> pet) {
    setState(() {
      final petIndex = pets.indexOf(pet);
      if (petIndex == -1) return;

      pet['id'] = petIndex;
      final existingItemIndex =
          cart.indexWhere((item) => item['id'] == pet['id']);
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

  // UI: Search and dropdown filter widget
  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Search input field
          Expanded(
            flex: 2,
            child: TextField(
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                  _filterProducts();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Поиск по названию',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 6),

          // Dropdown for price filtering
          Expanded(
            flex: 1,
            child: DropdownButtonFormField<String>(
              value: priceFilter,
              items: const [
                DropdownMenuItem(value: 'Все', child: Text('Все')),
                DropdownMenuItem(value: 'По возрастанию цены', child: Text('По возрастанию цены')),
                DropdownMenuItem(value: 'По убыванию цены', child: Text('По убыванию цены')),
              ],
              onChanged: (value) {
                setState(() {
                  priceFilter = value!;
                  _filterProducts();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Цена',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    final List<Widget> pages = [
      _buildMainPage(),
      FavoritesPage(favorites: favorites),
      CartPage(cart: cart, onRemove: removeFromCart, ),
      _buildProfilePage(user),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Зоо-магазин'),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blueGrey,
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

  // Main Catalog Page with search and price filters
  Widget _buildMainPage() {
    return Column(
      children: [
        _buildFilterSection(), // Search and Filter Section
        Expanded(
          child: filteredPets.isEmpty
              ? const Center(child: Text("Товаров пока нет!"))
              : ListView.builder(
                  itemCount: filteredPets.length,
                  itemBuilder: (context, index) {
                    final pet = filteredPets[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.network(pet['image_url'] ?? '',
                              height: 150, fit: BoxFit.cover),
                          Text(pet['title'] ?? "Название неизвестно"),
                          Text('${pet['price']} рублей'),
                          ElevatedButton(
                            onPressed: () => addToCart(pet),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.black
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
        ),
      ],
    );
  }

  // Profile Page
    // Profile Page
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
        crossAxisAlignment: CrossAxisAlignment.start, // Align to left
        children: [
          Text('Email: ${user.email}', style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/orders'), // Navigate to OrdersPage
            child: const Text('Мои заказы'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ChatPage(receiverId: 'bb3ce76c-a548-44a1-a99a-00c7264c582d',), // Replace with actual receiver's ID
    ),
  ),
  child: const Text('Чат'),
), const SizedBox(height: 10,),
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

}


