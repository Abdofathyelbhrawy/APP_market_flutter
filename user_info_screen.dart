import 'package:flutter/material.dart';
import 'package:market/core/firebase.dart';
import 'package:get/get.dart';
import 'user_orders_screen.dart';

class UserInfoScreen extends StatefulWidget {
  final dynamic user;
  const UserInfoScreen({super.key, required this.user});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<Map<String, dynamic>?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _firebaseService.getUserData(widget.user.uid);
  }

  Future<List<dynamic>> _fetchOrders() async {
    // Example: orders are stored as a list in the user document under 'orders'
    final userData = await _firebaseService.getUserData(widget.user.uid);
    return userData?['orders'] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading orders...'),
                        ],
                      ),
                    ),
              );
              final orders = await _fetchOrders();
              if (mounted) Navigator.of(context).pop();
              Get.to(() => UserOrdersScreen(orders: orders));
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user data found.'));
          }
          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Email: ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      data['email'] ?? "Unknown",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'First Name: ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      data['firstName'] ?? "Not available",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'Last Name: ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      data['lastName'] ?? "Not available",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                // Add more user info if needed
              ],
            ),
          );
        },
      ),
    );
  }
}
