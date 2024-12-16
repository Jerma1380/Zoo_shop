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
      widget.onRemove(item); // Notify the parent to remove the item
    });
  }

  double _calculateTotal() {
    return widget.cart.fold(
      0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  void _checkout() {
    setState(() {
      widget.cart.clear(); // Clear the cart
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Покупка совершена!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = _calculateTotal();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: widget.cart.isEmpty
          ? const Center(
              child: Text(
                'Ваша корзина пуста',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
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
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          child: ListTile(
                            title: Text(item['title']),
                            subtitle: Text('Цена: ${item['price']} руб.'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _decreaseQuantity(item),
                                  icon: const Icon(Icons.remove),
                                ),
                                Text('${item['quantity']}'),
                                IconButton(
                                  onPressed: () => _increaseQuantity(item),
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Итоговая сумма:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$total руб.',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _checkout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Оформить заказ'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
