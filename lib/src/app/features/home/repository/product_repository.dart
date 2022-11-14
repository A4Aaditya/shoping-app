import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/src/app/features/home/model/product_model.dart';

class ProductRepository {
  final fireStore = FirebaseFirestore.instance;
  final collectionPath = 'products';

  Future<bool?> addProduct(Map<String, dynamic> body) async {
    try {
      await fireStore.collection(collectionPath).add(body);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
    return true;
  }

  Future<List<ProductModel>> fetchProduct() async {
    try {
      final response = await fireStore.collection(collectionPath).get();
      final item = response.docs;
      return item.map((e) {
        final id = e.id;
        final data = e.data();
        return ProductModel.fromMap(data, id: id);
      }).toList();
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }
}
