import 'package:flutter/material.dart';
import 'package:pks3/pages/create_page.dart';
import 'package:pks3/pages/note_page.dart';
import 'favorites_page.dart'; // Новая страница избранного
import 'profile_page.dart'; // Новая страница профиля
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
  List<Map<String, dynamic>> favorites = []; // Список избранного
  int _currentIndex = 0; // Текущий индекс нижнего меню

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

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildMainPage(),
      FavoritesPage(favorites: favorites), // Новая страница избранного
      const ProfilePage(), // Новая страница профиля
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
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
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }

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
              'Редактирование товаров',
              style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 62, 61, 61)),
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
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Data(pet: pets[index]),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 143, 218, 255),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.network(
                            pets[index]["image_url"],
                            width: 240,
                            height: 120,
                            fit: BoxFit.fill,
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
                          Text(
                            pets[index]["title"],
                            style: const TextStyle(
                              color: Color.fromARGB(255, 62, 61, 61),
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Data(pet: pets[index]),
                                ),
                              );
                            },
                            child: const Text("Подробнее"),
                          ),
                          IconButton(
                            icon: favorites.contains(pets[index])
                                ? const Icon(Icons.favorite, color: Colors.red)
                                : const Icon(Icons.favorite_border),
                            onPressed: () {
                              toggleFavorite(pets[index]);
                            },
                          ),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Внимание!"),
                                      content: const Text(
                                          "Вы уверены, что хотите удалить данный товар?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            removePet(index);
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Да",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed:
                                              Navigator.of(context).pop,
                                          child: const Text(
                                            "Нет",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Color.fromARGB(255, 234, 27, 27),
                              ),
                      ),],
                      ),
                    ),
                  ),
                );
                
              },
            ),
    );
  }
}