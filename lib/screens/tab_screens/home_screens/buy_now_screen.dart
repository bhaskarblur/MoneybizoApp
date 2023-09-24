import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/app_config/app_details.dart';
import 'package:money_bizo/models/city.dart';
import 'package:money_bizo/models/product.dart';
import 'package:money_bizo/models/suburb.dart';
import 'package:money_bizo/providers/cart_provider.dart';
import 'package:money_bizo/providers/home_screen_provider.dart';
import 'package:money_bizo/providers/product_provider.dart';
import 'package:money_bizo/widget/sahared_prefs.dart';
import 'package:provider/provider.dart';

import '../../../app_config/colors.dart';
import '../../../providers/city_suburb_provider.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';

class BuyNowScreen extends StatefulWidget {
  final String companyId;
  final String companyName;
  const BuyNowScreen(
      {super.key, required this.companyId, required this.companyName});

  @override
  State<BuyNowScreen> createState() => _BuyNowScreenState();
}

class _BuyNowScreenState extends State<BuyNowScreen> {
  final ApiServices _apiServices = ApiServices();
  final TextEditingController _search = TextEditingController();

  City city = City();
  Suburb suburb = Suburb();

  @override
  void initState() {
    super.initState();

    final filterProvider =
        Provider.of<CitySuburbProvider>(context, listen: false);
    city = filterProvider.city[0];
    suburb = filterProvider.suburb[0];

    getData();
  }

  getData() {
    final provider = Provider.of<ProductProvider>(context, listen: false);

    _apiServices
        .post(context: context, endpoint: 'viewProducts_mob.php', body: {
      "mode": "mobile",
      "ClientID": widget.companyId,
      if (suburb.cityName != 'Select Suburb') "suburb": suburb.cityName,
      if (city.cityName != 'Select City') "city": city.cityName,
      if (_search.text.isNotEmpty) "findem": _search.text,
    }).then((value) {
      if (value == null) {
        provider.changeProducts([]);
      } else {
        provider.changeProducts(value['company_products']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Consumer<ProductProvider>(builder: (context, provider, _) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        statusBar(context),
                        Center(
                            child: SizedBox(
                                width: 100,
                                child: Image.asset(
                                    'assets/icons/banner_icon.png'))),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Nav.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back)),
                            Text(widget.companyName,
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        serachBar(_search, () {},
                            onChanged: (value) {},
                            onEditingComplete: () {},
                            filter: false),
                        gap(10),
                        Consumer<CitySuburbProvider>(
                            builder: (context, csProvider, _) {
                          return Row(
                            children: [
                              Expanded(
                                child: dd(csProvider.suburb, suburb, (value) {
                                  suburb = value!;
                                  setState(() {});
                                }),
                              ),
                              horGap(10),
                              Expanded(
                                child: dd(csProvider.city, city, (value) {
                                  city = value!;
                                  setState(() {});
                                }),
                              ),
                            ],
                          );
                        }),
                        gap(15),
                        Row(
                          children: [
                            fullWidthButton(
                                buttonName: 'Go',
                                onTap: () {
                                  getData();
                                },
                                width: 100,
                                height: 40),
                            if (_search.text.isNotEmpty ||
                                city.cityName != 'Select City' ||
                                suburb.cityName != 'Select Suburb')
                              fullWidthButton(
                                  buttonName: 'Clear Filter',
                                  onTap: () {
                                    final citySuburb =
                                        Provider.of<CitySuburbProvider>(context,
                                            listen: false);
                                    city = citySuburb.city[0];
                                    suburb = citySuburb.suburb[0];
                                    _search.clear();
                                    setState(() {});
                                    getData();
                                  },
                                  width: 120,
                                  height: 40),
                          ],
                        ),
                        gap(20),
                        provider.products == null
                            ? gap(0)
                            : provider.products.length == 0
                                ? emptyMessage('Products')
                                : ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: provider.products.length,
                                    separatorBuilder: (context, index) {
                                      return gap(10);
                                    },
                                    itemBuilder: (context, index) {
                                      return ProductCard(
                                          data: provider.products[index]);
                                    },
                                  ),
                        gap(20),
                      ],
                    ),
                  ),
                ),
              ),
              Consumer<CartProvider>(builder: (context, provider, _) {
                return provider.cartProducts.isEmpty
                    ? gap(0)
                    : InkWell(
                        onTap: () {
                          Nav.pop(context);
                          Nav.pop(context);
                          final homeProvider = Provider.of<HomeScreenProvider>(
                              context,
                              listen: false);
                          homeProvider.changeSelectedIndex(2);
                        },
                        child: Container(
                          width: double.infinity,
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${provider.cartProducts.length.toString()} Products in cart',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    Text('\$${provider.getTotal()}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white)),
                                  ],
                                ),
                                const Text('View cart',
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                          ),
                        ),
                      );
              })
            ],
          );
        }));
  }

  Widget dd(
      List<dynamic> items, dynamic bvalue, void Function(dynamic)? onChanged) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey.shade300)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: DropdownButton<dynamic>(
            isExpanded: true,
            underline: gap(0),
            value: bvalue,
            items: items.map((dynamic value) {
              return DropdownMenuItem<dynamic>(
                value: value,
                child: Text(value.cityName),
              );
            }).toList(),
            onChanged: onChanged),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final dynamic data;
  const ProductCard({super.key, this.data});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final ApiServices _apiServices = ApiServices();

  @override
  Widget build(BuildContext context) {
    int counter = 0;

    return FutureBuilder(
        future: _apiServices.post(
            context: context,
            endpoint: 'product_info_mobile.php',
            body: {"mode": "mobile", "products_id": widget.data['products_id']},
            progressBar: false),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data['product_info'];
            return Consumer<CartProvider>(builder: (context, provider, _) {
              counter = provider.returnQuantity(data['products_id']);

              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                baseUrl +
                                    'images/' +
                                    data['products_image_main'],
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (c, v, b) {
                                  return Image.asset('assets/images/food.png');
                                },
                              ),
                              horGap(10),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(data['products_name'].toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        toBeginningOfSentenceCase(
                                            data['products_description'])!,
                                        maxLines: 2,
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                    Text(data['ptype'] ?? ''.toString(),
                                        style:
                                            const TextStyle(color: Colors.grey))
                                  ])),
                            ]),
                      ),
                      dottedDivder(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Row(
                          children: [
                            const Text("Price: ",
                                style: TextStyle(color: Colors.black54)),
                            Text(
                                "\$${double.parse(data['products_price']).toStringAsFixed(2)}",
                                style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      dottedDivder(),
                      FutureBuilder(
                          future: Prefs.getBool('company'),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data == null) {
                                return gap(0);
                              } else {
                                if (snapshot.data == true) {
                                  return gap(0);
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: counter == 0
                                        ? InkWell(
                                            onTap: () {
                                              if (provider
                                                  .cartProducts.isEmpty) {
                                                setState(() {
                                                  counter = 1;
                                                });
                                              } else {
                                                if (provider
                                                        .cartProducts[0].id ==
                                                    data['products_id']) {
                                                  setState(() {
                                                    counter++;
                                                  });
                                                }
                                              }

                                              provider.addToCart(
                                                  context,
                                                  Product(
                                                      id: data['products_id'],
                                                      name:
                                                          data['products_name'],
                                                      model: data[
                                                          'products_model'],
                                                      ptype:
                                                          widget.data['ptype'],
                                                      productsQuantityUser: '0',
                                                      manufacturersId:
                                                          data[
                                                              'manufacturers_id'],
                                                      price: double.parse(data[
                                                          'products_price']),
                                                      quantity: 1,
                                                      weight: '1',
                                                      finalPrice: (counter *
                                                              double.parse(data[
                                                                  'products_price']))
                                                          .toString(),
                                                      attributes:
                                                          data['products_attributes']
                                                              .toString(),
                                                      image: widget.data[
                                                          'image_filename'],
                                                      description: data[
                                                          'products_description']));
                                              provider.saveCartProducts();
                                            },
                                            child: const Text("Add to Cart",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          )
                                        : Container(
                                            height: 30,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                color: primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3),
                                              child: Row(children: [
                                                Expanded(
                                                    child: InkWell(
                                                  onTap: () {
                                                    if (counter > 0) {
                                                      setState(() {
                                                        counter--;
                                                      });
                                                      provider.removeFromCart(Product(
                                                          id: data[
                                                              'products_id'],
                                                          name: data[
                                                              'products_name'],
                                                          model: data[
                                                              'products_model'],
                                                          ptype: widget
                                                              .data['ptype'],
                                                          productsQuantityUser:
                                                              '0',
                                                          manufacturersId: data[
                                                              'manufacturers_id'],
                                                          price: double.parse(data[
                                                              'products_price']),
                                                          quantity: 1,
                                                          weight: '1',
                                                          finalPrice:
                                                              (counter * double.parse(data['products_price']))
                                                                  .toString(),
                                                          attributes:
                                                              data['products_attributes']
                                                                  .toString(),
                                                          image: widget.data[
                                                              'image_filename'],
                                                          description: data[
                                                              'products_description']));
                                                      provider
                                                          .saveCartProducts();
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.white),
                                                    child: const Icon(
                                                        Icons.remove,
                                                        color: Colors.black),
                                                  ),
                                                )),
                                                Expanded(
                                                    child: Center(
                                                        child: Text(
                                                            counter.toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)))),
                                                Expanded(
                                                    child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      counter++;
                                                    });
                                                    provider.addToCart(
                                                        context,
                                                        Product(
                                                            id: data[
                                                                'products_id'],
                                                            name: data[
                                                                'products_name'],
                                                            model: data[
                                                                'products_model'],
                                                            ptype: widget
                                                                .data['ptype'],
                                                            productsQuantityUser:
                                                                '0',
                                                            manufacturersId: data[
                                                                'manufacturers_id'],
                                                            price: double.parse(
                                                                data[
                                                                    'products_price']),
                                                            quantity: 1,
                                                            weight: '1',
                                                            finalPrice:
                                                                (counter * double.parse(data['products_price']))
                                                                    .toString(),
                                                            attributes: data[
                                                                    'products_attributes']
                                                                .toString(),
                                                            image: widget.data[
                                                                'image_filename'],
                                                            description: data[
                                                                'products_description']));
                                                    provider.saveCartProducts();
                                                  },
                                                  child: Container(
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.white),
                                                    child: const Icon(Icons.add,
                                                        color: Colors.black),
                                                  ),
                                                )),
                                              ]),
                                            )),
                                  );
                                }
                              }
                            } else {
                              print(7);
                              return gap(20);
                            }
                          }),
                    ]),
              );
            });
          } else {
            return gap(100);
          }
        });
  }
}
