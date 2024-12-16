import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  // Данные всех заказов с фотографиями
  final List<Map<String, dynamic>> allOrders = [
    {
      'orderNumber': 1,
      'items': [
        {
          'title': 'Кот',
          'price': 1200,
          'quantity': 2,
          'image':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bb/%D0%9A%D0%BE%D1%82.jpg/220px-%D0%9A%D0%BE%D1%82.jpg',
        },
        {
          'title': 'Собака',
          'price': 670,
          'quantity': 1,
          'image':
              'https://cdnn21.img.ria.ru/images/07e5/05/11/1732647541_0:200:1920:1280_1920x0_80_0_0_dd4c418518310b9d20c8d8029948008a.jpg',
        },
      ],
    },
    {
      'orderNumber': 2,
      'items': [
        {
          'title': 'Хомяк',
          'price': 100000,
          'quantity': 1,
          'image':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/Pearl_Winter_White_Russian_Dwarf_Hamster_-_Front.jpg/1200px-Pearl_Winter_White_Russian_Dwarf_Hamster_-_Front.jpg',
        },
        {
          'title': 'Птица',
          'price': 4000,
          'quantity': 1,
          'image':
              'https://upload.wikimedia.org/wikipedia/commons/1/16/Myophonus_caeruleus_-_Ang_Khang_edit1.jpg',
        },
        {
          'title': 'Собака',
          'price': 670,
          'quantity': 1,
          'image':
              'https://cdnn21.img.ria.ru/images/07e5/05/11/1732647541_0:200:1920:1280_1920x0_80_0_0_dd4c418518310b9d20c8d8029948008a.jpg',
        },
      ],
    },
    {
      'orderNumber': 3,
      'items': [
        {
          'title': 'Птица',
          'price': 4000,
          'quantity': 5,
          'image':
              'https://upload.wikimedia.org/wikipedia/commons/1/16/Myophonus_caeruleus_-_Ang_Khang_edit1.jpg',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заказы'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: allOrders.map((order) {
            int totalSum = order['items'].fold(0, (sum, item) {
              return sum + (item['price'] * item['quantity']);
            });

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок заказа
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Заказ № ${order['orderNumber']}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(),
                    // Список товаров с картинками
                    ...order['items'].map((item) {
                      return ListTile(
                        leading: Image.network(
                          item['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          item['title'],
                          style: const TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          'Цена: ${item['price']} руб.\nКоличество: ${item['quantity']}',
                        ),
                        trailing: Text(
                          '${item['price'] * item['quantity']} руб.',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    const Divider(),
                    // Итоговая сумма
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Итоговая сумма: $totalSum руб.',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
