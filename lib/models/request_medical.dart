// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RequestMedical {
  final String name;
  final int stock;
  final int price;
  final String description;

  RequestMedical(
    this.name,
    this.stock,
    this.price,
    this.description,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'stock': stock,
      'price': price,
      'description': description,
    };
  }

  factory RequestMedical.fromMap(Map<String, dynamic> map) {
    return RequestMedical(
      map['name'] as String,
      map['stock'] as int,
      map['price'] as int,
      map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RequestMedical.fromJson(String source) =>
      RequestMedical.fromMap(json.decode(source) as Map<String, dynamic>);
}
