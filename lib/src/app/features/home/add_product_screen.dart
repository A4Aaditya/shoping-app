import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_app/src/app/features/home/repository/product_repository.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _globalKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mrpController = TextEditingController();
  final _offerPriceController = TextEditingController();
  File? productImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Form(
        key: _globalKey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            TextButton(
              onPressed: selectImage,
              child: const Text('Select Image'),
            ),
            productImage == null ? const SizedBox() : Image.file(productImage!),
            const SizedBox(height: 20),
            // product name
            TextFormField(
              controller: _productNameController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => validateProductName(value),
              decoration: const InputDecoration(
                hintText: 'Product Name',
                filled: true,
                fillColor: Color.fromARGB(255, 212, 212, 212),
              ),
            ),
            const SizedBox(height: 20),
            // product description
            TextFormField(
              controller: _descriptionController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => productDescriptionValidate(value),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Product Description',
                filled: true,
                fillColor: Color.fromARGB(255, 212, 212, 212),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _mrpController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => mrpValidate(value),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'MRP',
                filled: true,
                fillColor: Color.fromARGB(255, 212, 212, 212),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _offerPriceController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => offerPriceValidate(value),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Offer Price',
                filled: true,
                fillColor: Color.fromARGB(255, 212, 212, 212),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addProductPressed,
              child: const Text('Add Product'),
            )
          ],
        ),
      ),
    );
  }

  void resetScreen() {
    _productNameController.text = '';
    _descriptionController.text = '';
    _mrpController.text = '';
    _offerPriceController.text = '';
  }

  String? offerPriceValidate(String? value) {
    if (value != null && value.isEmpty) {
      return 'enter offer price';
    }
    return null;
  }

  String? mrpValidate(String? value) {
    if (value != null && value.isEmpty) {
      return 'enter mrp';
    }
    return null;
  }

  String? productDescriptionValidate(String? value) {
    if (value != null && value.isEmpty) {
      return 'enter description';
    } else if (value != null && value.length < 6) {
      return 'product description should be more than 6';
    }
    return null;
  }

  String? validateProductName(String? value) {
    if (value != null && value.isEmpty) {
      return 'enter product name';
    } else if (value != null && value.length < 3) {
      return 'product name should be more than 3';
    }
    return null;
  }

  void addProductPressed() async {
    log('addProductPressed');
    // validation
    if (_globalKey.currentState?.validate() == true) {
      try {
        await ProductRepository().addProduct(body);
        resetScreen();
        successSnackBar();
      } catch (e) {
        errorSnackBar(e.toString());
      }
    }
  }

  void errorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void successSnackBar() {
    const snackBar = SnackBar(
      content: Text('Product Added'),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Map<String, dynamic> get body {
    final prouctName = _productNameController.text.trim();
    final productDescription = _descriptionController.text.trim();
    final mrp = double.parse(_mrpController.text.trim());
    final offerPrice = double.parse(_offerPriceController.text.trim());
    return {
      'product_name': prouctName,
      'product_description': productDescription,
      'mrp': mrp,
      'offer_price': offerPrice,
    };
  }

  Future<void> selectImage() async {
    final image = await ImagePicker.platform.getImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      productImage = File(image.path);
    }
  }
}
