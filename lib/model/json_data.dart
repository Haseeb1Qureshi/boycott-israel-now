class Categoryy {
  final String category;
  final String image;
  final List<Product> products;
  final List<Alternative> alternatives;

  Categoryy({
    required this.category,
    required this.image,
    required this.products,
    required this.alternatives,
  });

  factory Categoryy.fromJson(Map<String, dynamic> json) {
    var productsList = json['products'] as List;
    var alternativesList = json['Alternatives'] as List;

    List<Product> productObjs =
        productsList.map((item) => Product.fromJson(item)).toList();
    List<Alternative> alternativeObjs =
        alternativesList.map((item) => Alternative.fromJson(item)).toList();

    return Categoryy(
      category: json['category'],
      image: json['image'],
      products: productObjs,
      alternatives: alternativeObjs,
    );
  }
}

class Product {
  final String productName;
  final String productImage;

  Product({required this.productName, required this.productImage});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json['productName'],
      productImage: json['productImage'],
    );
  }
}

class Alternative {
  final String alternativeName;
  final String alternativeImage;

  Alternative({required this.alternativeName, required this.alternativeImage});

  factory Alternative.fromJson(Map<String, dynamic> json) {
    return Alternative(
      alternativeName: json['alternativeName'],
      alternativeImage: json['alternativeImage'],
    );
  }
}
