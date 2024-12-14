import 'dart:ffi';

import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final Function(Map<String, dynamic>) onRemove;

  const CartPage({required this.cart, required this.onRemove, Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _increaseQuantity(Map<String, dynamic> item) {
    setState(() {
      item['quantity'] += 1;
    });
  }

  void _decreaseQuantity(Map<String, dynamic> item) {
    setState(() {
      if (item['quantity'] > 1) {
        item['quantity'] -= 1;
      } else {
        _removeItem(item);
      }
    });
  }

  void _removeItem(Map<String, dynamic> item) {
    setState(() {
      widget.cart.remove(item);
      widget.onRemove(item);
    });
  }

  double _calculateTotal() {
    return widget.cart.fold(
      0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  String _getPatientText(int quantity) {
    // Если количество больше 1 и меньше 5, используем "пациента"
    // Если больше или равно 5, используем "пациентов"
    if (quantity > 1 && quantity < 5) {
      return 'пациента';
    } else if (quantity >= 5) {
      return 'пациентов';
    } else {
      return 'пациент';
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = _calculateTotal();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: widget.cart.isEmpty
                  ? const Center(
                      child: Text(
                        'Ваша корзина пуста',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      itemCount: widget.cart.length,
                      itemBuilder: (context, index) {
                        final item = widget.cart[index];

                        return Dismissible(
                          key: Key(item['id'].toString()),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (direction) {
                            _removeItem(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item['title']} удалён из корзины'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20.0),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            padding: const EdgeInsets.all(12.0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.white,
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      '${item['price']} Р',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      '${item['quantity']} ${_getPatientText(item['quantity'])}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                                // Кнопки "+" и "-"
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Row(
                                    children: [
                                      _buildOutlinedButton(Icons.remove, () => _decreaseQuantity(item)),
                                      const SizedBox(width: 6.0, height: 6.0,),
                                      _buildOutlinedButton(Icons.add, () => _increaseQuantity(item)),
                                    ],
                                  ),
                                ),
                                
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              margin: const EdgeInsets.only(bottom: 10.0, left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Сумма',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$total Р',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 16, right: 16),
              child: SizedBox(
                width: double.infinity,
                height: 48.0,
                child: ElevatedButton(
                  onPressed: () {
                    // Логика оформления заказа
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Перейти к оформлению заказа',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutlinedButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: Colors.grey.shade700),
        onPressed: onPressed,
      ),
    );
  }
}
