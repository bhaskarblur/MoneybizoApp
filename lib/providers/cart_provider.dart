import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:money_bizo/models/product.dart';
import 'package:money_bizo/widget/navigator.dart';
import 'package:money_bizo/widget/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_config/colors.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _cartProducts = [];
  List<Product> get cartProducts => _cartProducts;

  returnQuantity(String value) {
    print(value);
    int quantity = 0;

    for (int i = 0; i < _cartProducts.length; i++) {
      if (_cartProducts[i].id == value) {
        quantity = _cartProducts[i].quantity!;
      }
    }

    return quantity;
  }

  addToCart(BuildContext context, Product value) {
    var index = _cartProducts.indexWhere((element) => element.id == value.id);

    if (index == -1) {
      if (_cartProducts.isEmpty) {
        _cartProducts.add(value);
      } else {
        if (_cartProducts[0].id == value.id) {
          _cartProducts.add(value);
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.all(15),
                  title: Text('Clear Cart',
                      style: TextStyle(color: primaryTextColor)),
                  content: Text(
                      'You already have a product in cart from another shop, clear the cart to buy from this shop',
                      maxLines: 5,
                      style: TextStyle(color: primaryTextColor)),
                  actions: [
                    InkWell(
                      onTap: () {
                        _cartProducts.clear();
                        Nav.pop(context);
                        notifyListeners();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: primaryColor),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text('Clear',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: backgroundColor)),
                        ),
                      ),
                    ),
                    horGap(10),
                    InkWell(
                      onTap: () {
                        Nav.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: primaryColor),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text('Ok',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: backgroundColor)),
                        ),
                      ),
                    ),
                  ],
                );
              });
        }
      }
    } else {
      _cartProducts[index].quantity = _cartProducts[index].quantity! + 1;
    }
    notifyListeners();
  }

  removeFromCart(Product value) {
    var index = _cartProducts.indexWhere((element) => element.id == value.id);

    if (_cartProducts[index].quantity! < 2) {
      _cartProducts.removeAt(index);
    } else {
      _cartProducts[index].quantity = _cartProducts[index].quantity! - 1;
    }
    notifyListeners();
  }

  clearCart() {
    _cartProducts.clear();
    notifyListeners();
  }

  double getTotal() {
    double grandTotal = 0.0;
    for (int i = 0; i < _cartProducts.length; i++) {
      grandTotal =
          grandTotal + (_cartProducts[i].quantity! * _cartProducts[i].price!);
    }
    return grandTotal;
  }

  saveCartProducts() async {
    final prefs = await SharedPreferences.getInstance();

    List<dynamic> json = [];
    _cartProducts.forEach((element) {
      json.add(element.toJson());
    });
    prefs.setString('cart', jsonEncode(json));
  }

  getSavedCartProduct(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    var cart = prefs.getString('cart');

    if (cart != null) {
      List<dynamic> json = jsonDecode(cart);

      json.forEach((element) {
        addToCart(
            context,
            Product(
              id: element['id'],
              name: element['name'],
              model: element['model'],
              ptype: element['ptype'],
              productsQuantityUser: element['productsQuantityUser'],
              manufacturersId: element['manufacturersId'],
              price: element['price'],
              quantity: element['quantity'],
              weight: element['weight'],
              finalPrice: element['finalPrice'],
              attributes: element['attributes'],
              image: element['image'],
              description: element['description'],
            ));
        print(element);
      });
    }
  }
}
