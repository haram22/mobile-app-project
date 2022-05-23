import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String name;
  String course;
  String pricecount;
  int count;

  Product({required this.name, required this.course, required this.pricecount, required this.count});

  factory Product.fromDs(DocumentSnapshot data) {
    return Product(
      name: data['name'] ?? '',
      course: data['course'] ?? '',
      pricecount: data['price'] ?? '',
      count: data['count'] ?? 0,

    );
  }
}