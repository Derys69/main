import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Product {
  final String title;
  final double price;

  Product({
    required this.title,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      price: (json['price'] as num).toDouble(),
    );
  }
}

class Api {
  static const String apiUrl = "https://fakestoreapi.com/products";

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Error");
    }
  }
}

void sortProducts(List<Product> products, int sortType, bool byPrice) {
  if (byPrice) {
    products.sort((a, b) => sortType == 1 ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
  } else {
    products.sort((a, b) => sortType == 1 ? a.title.compareTo(b.title) : b.title.compareTo(a.title));
  }
}

void main() async {
  final api = Api();
  List<Product> products = await api.fetchProducts();

  print("\nDaftar Produk:");
  for (var product in products) {
    print("${product.title} - \$${product.price}");
  }

  print("\nPilih metode pengurutan:");
  print("1 - Urutkan berdasarkan Nama (A-Z)");
  print("2 - Urutkan berdasarkan Nama (Z-A)");
  print("3 - Urutkan berdasarkan Harga (Termurah)");
  print("4 - Urutkan berdasarkan Harga (Termahal)");

  stdout.write("Masukkan pilihan Anda (1-4): ");
  String? input = stdin.readLineSync();

  try {
    int choice = int.parse(input!);

    if (choice >= 1 && choice <= 4) {
      bool byPrice = choice >= 3; // True jika memilih opsi harga
      int sortType = (choice % 2 == 1) ? 1 : 2; // 1 untuk ascending, 2 untuk descending

      sortProducts(products, sortType, byPrice);

      print("\nProduk setelah diurutkan:");
      for (var product in products) {
        print("${product.title} - \$${product.price}");
      }
    } else {
      print("Kesalahan. Silakan jalankan ulang program.");
    }
  } catch (e) {
    print("Masukkan hanya angka antara 1 hingga 4.");
  }
}
