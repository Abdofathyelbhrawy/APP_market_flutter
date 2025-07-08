import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_info_screen.dart';
import 'package:market/core/firebase.dart';

class ProductsScreen extends StatefulWidget {
  final dynamic user;
  const ProductsScreen({super.key, required this.user});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final FirebaseService firebaseService = FirebaseService();
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Apple',
      'desc': 'Fresh red apple',
      'image': 'assets/images/apple.jpeg',
      'price': 2.99,
      'quantity': 1,
    },
    {
      'name': 'Banana',
      'desc': 'Organic banana',
      'image': 'assets/images/banana.jpg',
      'price': 1.99,
      'quantity': 1,
    },
    {
      'name': 'Orange',
      'desc': 'Juicy orange',
      'image': 'assets/images/orange.jpeg',
      'price': 1.49,
      'quantity': 1,
    },
    {
      'name': 'Milk',
      'desc': 'Low fat milk',
      'image': 'assets/images/milk.jpg',
      'price': 3.99,
      'quantity': 1,
    },
    {
      'name': 'Bread',
      'desc': 'Whole grain bread',
      'image': 'assets/images/bread.jpeg',
      'price': 2.49,
      'quantity': 1,
    },
  ];
  List<bool> isLoading = List.filled(5, false);
  List<Map<String, dynamic>> cartItems = [];
  double total = 0.0;

  void _calculateTotal() {
    total = cartItems.fold(
      0.0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  void _showBill() {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'الفاتورة',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'المنتج',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'الكمية',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'السعر',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'الإجمالي',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...cartItems
                            .map(
                              (item) => Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        item['name'],
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${item['quantity']}',
                                        style: const TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '\$${item['price'].toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            ,
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'الإجمالي النهائي:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('إغلاق'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Get.to(() => UserInfoScreen(user: widget.user));
            },
          ),
        ],
      ),
      floatingActionButton:
          cartItems.isNotEmpty
              ? FloatingActionButton.extended(
                onPressed: _showBill,
                label: Text('\$${total.toStringAsFixed(2)}'),
                icon: const Icon(Icons.receipt_long),
              )
              : null,
      body: ListView.builder(
        itemCount: products.length,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        product['image']!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product['name']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['desc']!,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product['price'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (product['quantity'] > 1) {
                              product['quantity']--;
                            }
                          });
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.grey[700],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${product['quantity']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            product['quantity']++;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child:
                        isLoading[index]
                            ? const SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading[index] = true;
                                });
                                print(
                                  'Buy button pressed for ${product['name']}',
                                );
                                try {
                                  final userId = widget.user.uid;
                                  final userData =
                                      await firebaseService.getUserData(
                                        userId,
                                      ) ??
                                      {};
                                  final List<dynamic> orders = List.from(
                                    userData['orders'] ?? [],
                                  );

                                  // Add to cart
                                  final existingItemIndex = cartItems
                                      .indexWhere(
                                        (item) =>
                                            item['name'] == product['name'],
                                      );

                                  if (existingItemIndex != -1) {
                                    cartItems[existingItemIndex]['quantity'] +=
                                        product['quantity'];
                                  } else {
                                    cartItems.add({
                                      'name': product['name'],
                                      'desc': product['desc'],
                                      'image': product['image'],
                                      'price': product['price'],
                                      'quantity': product['quantity'],
                                    });
                                  }

                                  _calculateTotal();

                                  // Add to orders with total
                                  orders.add({
                                    'name': product['name'],
                                    'desc': product['desc'],
                                    'image': product['image'],
                                    'price': product['price'],
                                    'quantity': product['quantity'],
                                    'total': total,
                                    'items': cartItems,
                                    'date': DateTime.now().toIso8601String(),
                                  });
                                  await firebaseService.updateUserOrders(
                                    userId,
                                    orders,
                                  );
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${product['name']} added to your cart!',
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  print('Error buying product: $e');
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      isLoading[index] = false;
                                    });
                                  }
                                }
                              },
                              child: const Text('Buy'),
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
