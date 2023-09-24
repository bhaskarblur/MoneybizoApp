class Product {
  String? id;
  String? name;
  String? model;
  String? ptype;
  String? productsQuantityUser;
  String? manufacturersId;
  double? price;
  int? quantity;
  String? weight;
  String? finalPrice;
  String? attributes;
  String? image;
  String? description;

  Product(
      {required this.id,
      required this.name,
      required this.model,
      required this.ptype,
      required this.productsQuantityUser,
      required this.manufacturersId,
      required this.price,
      required this.quantity,
      required this.weight,
      required this.finalPrice,
      required this.attributes,
      this.image,
      this.description});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    model = json['model'];
    ptype = json['ptype'];
    productsQuantityUser = json['products_quantity_user'];
    manufacturersId = json['manufacturers_id'];
    price = json['price'];
    quantity = json['quantity'];
    weight = json['weight'];
    finalPrice = json['final_price'];
    attributes = json['attributes'];
    image = json['image'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['model'] = model;
    data['ptype'] = ptype;
    data['products_quantity_user'] = productsQuantityUser;
    data['manufacturers_id'] = manufacturersId;
    data['price'] = price;
    data['quantity'] = quantity;
    data['weight'] = weight;
    data['final_price'] = finalPrice;
    data['attributes'] = attributes;
    data['image'] = image;
    data['description'] = description;
    return data;
  }
}
