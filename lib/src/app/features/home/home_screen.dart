import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/src/app/features/authentication/bloc/auth_bloc.dart';
import 'package:shopping_app/src/app/features/authentication/bloc/auth_event.dart';
import 'package:shopping_app/src/app/features/authentication/bloc/auth_state.dart';
import 'package:shopping_app/src/app/features/authentication/views/login_screen.dart';
import 'package:shopping_app/src/app/features/home/add_product_screen.dart';
import 'package:shopping_app/src/app/features/home/model/product_model.dart';
import 'package:shopping_app/src/app/features/home/repository/product_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> products = [];
  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(AuthLogoutEvent());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitialState) {
            return navigateToLoginScreen();
          }
        },
        child: RefreshIndicator(
          onRefresh: fetchProduct,
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final name = product.productName;
              final mrp = product.mrp;
              final description = product.productDescription;
              final offerPrice = product.offerPrice;
              return Card(
                child: Row(
                  children: [
                    Container(
                      height: 150,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name),
                          Text(description),
                          Text('$mrp'),
                          Text('$offerPrice'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddProduct,
        label: const Text('Add Product'),
      ),
    );
  }

  Future<void> fetchProduct() async {
    final response = await ProductRepository().fetchProduct();
    setState(() {
      products = response;
    });
  }

  void navigateToAddProduct() {
    final route = MaterialPageRoute(
      builder: (context) => const AddProductScreen(),
    );
    Navigator.push(context, route);
  }

  void navigateToLoginScreen() {
    final route = MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }
}
