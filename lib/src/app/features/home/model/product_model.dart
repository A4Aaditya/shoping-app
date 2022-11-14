class ProductModel {
  final String id;
  final String productName;
  final String productDescription;
  final double mrp;
  final double offerPrice;

  ProductModel({
    required this.productName,
    required this.productDescription,
    required this.offerPrice,
    required this.mrp,
    required this.id,
  });

  factory ProductModel.fromMap(Map<String, dynamic> json, {String? id}) {
    return ProductModel(
      id: id ?? json['id'],
      productName: json['product_name'],
      productDescription: json['product_description'],
      mrp: double.parse('${json['mrp']}'),
      offerPrice: double.parse('${json['offer_price']}'),
    );
  }
}
