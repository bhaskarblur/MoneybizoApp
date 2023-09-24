import 'package:provider/provider.dart';

import '../../../models/city.dart';
import '../../../models/suburb.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/city_suburb_provider.dart';
import '../../../providers/home_screen_provider.dart';
import '../../../widget/widgets.dart';
import 'package:flutter/material.dart';
import '../../../widget/navigator.dart';
import '../../../app_config/colors.dart';
import 'package:money_bizo/api_services.dart';

import 'buy_now_screen.dart';
import 'company_details.dart';

class SeeAllCompaniesOrProducts extends StatefulWidget {
  final String? searchType;
  const SeeAllCompaniesOrProducts({super.key, this.searchType});

  @override
  State<SeeAllCompaniesOrProducts> createState() =>
      _SeeAllCompaniesOrProductsState();
}

class _SeeAllCompaniesOrProductsState extends State<SeeAllCompaniesOrProducts> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _search = TextEditingController();

  dynamic companies;
  dynamic products;

  @override
  void initState() {
    final filterProvider =
        Provider.of<CitySuburbProvider>(context, listen: false);
    city = filterProvider.city[0];
    suburb = filterProvider.suburb[0];

    getData();
    super.initState();
  }

  getData() {
    if (widget.searchType == 'company') {
      _apiServices.post(context: context, endpoint: 'mostpopular.php', body: {
        "type": "user",
        "mode": "mobile",
        if (suburb!.cityName != 'Select Suburb') "suburb": suburb!.cityName,
        if (city!.cityName != 'Select City') "city": city!.cityName,
        if (_search.text.isNotEmpty) "findem": _search.text
      }).then((value) {
        companies = value['companies_list'];
        setState(() {});
      });
    }

    if (widget.searchType == 'product') {
      _apiServices
          .post(context: context, endpoint: 'viewProductsGallery.php', body: {
        "type": "company",
        "mode": "mobile",
        if (suburb!.cityName != 'Select Suburb') "suburb": suburb!.cityName,
        if (city!.cityName != 'Select City') "city": city!.cityName,
        if (_search.text.isNotEmpty) "findem": _search.text
      }).then((value) {
        products = value['product_list'];
        setState(() {});
      });
    }
  }

  City? city;
  Suburb? suburb;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    statusBar(context),
                    Center(
                        child: SizedBox(
                            width: 100,
                            child:
                                Image.asset('assets/icons/banner_icon.png'))),
                    gap(20),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Nav.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back, size: 30)),
                        const Text('Search',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold))
                      ],
                    ),
                    gap(20),
                    serachBar(_search, () {}, onChanged: (value) {},
                        onEditingComplete: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      getData();
                    }, filter: false),
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
                              // if (_search.text.isEmpty) {
                              getData();
                              // } else {
                              //   List<dynamic> list = [];
                              //   if (widget.searchType == 'company') {
                              //     for (int i = 0; i < companies.length; i++) {
                              //       if (companies[i]['gen_company_name']
                              //           .toLowerCase()
                              //           .contains(_search.text.toLowerCase())) {
                              //         list.add(companies[i]);
                              //       }
                              //     }
                              //     companies = list;
                              //   } else {
                              //     for (int i = 0; i < products.length; i++) {
                              //       if (products[i]['products_name']
                              //           .toLowerCase()
                              //           .contains(_search.text.toLowerCase())) {
                              //         list.add(products[i]);
                              //       }
                              //     }
                              //     products = list;
                              //   }
                              // }
                            },
                            width: 100,
                            height: 40),
                        if (_search.text.isNotEmpty ||
                            city!.cityName != 'Select City' ||
                            suburb!.cityName != 'Select Suburb')
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
                    Expanded(
                      child: SingleChildScrollView(
                          child: Column(children: [
                        if (widget.searchType == 'company')
                          if (companies != null)
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: companies.length,
                              separatorBuilder: (context, index) {
                                return gap(10);
                              },
                              itemBuilder: (context, index) {
                                return customCard(companies[index],
                                    gallery: false, byNowOnTap: () {
                                  Nav.push(
                                      context,
                                      BuyNowScreen(
                                          companyName: companies[index]
                                              ['gen_company_name'],
                                          companyId: companies[index]
                                              ['fem_company_login_id']));
                                }, ontapCompany: () {
                                  Nav.push(
                                      context,
                                      CompanyDetails(
                                          companyId: companies[index]
                                              ['fem_company_login_id']));
                                });
                              },
                            ),
                        if (widget.searchType == 'product')
                          if (products != null)
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: products.length,
                              separatorBuilder: (context, index) {
                                return gap(10);
                              },
                              itemBuilder: (context, index) {
                                return ProductCard(data: products[index][0]);
                              },
                            ),
                      ])),
                    ),
                  ])),
            ),
            Consumer<CartProvider>(builder: (context, provider, _) {
              return provider.cartProducts.isEmpty
                  ? gap(0)
                  : InkWell(
                      onTap: () {
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
                                      style:
                                          const TextStyle(color: Colors.white)),
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
            }),
          ],
        ));
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
