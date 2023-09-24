import 'package:flutter/material.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/models/city.dart';
import 'package:money_bizo/models/suburb.dart';
import 'package:money_bizo/providers/city_suburb_provider.dart';
import 'package:money_bizo/providers/product_provider.dart';
import 'package:money_bizo/screens/tab_screens/home_screens/company_details.dart';
import 'package:provider/provider.dart';

import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';
import 'buy_now_screen.dart';

class CompanyScreen extends StatefulWidget {
  final String categoryName;
  const CompanyScreen({super.key, required this.categoryName});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final ApiServices _apiServices = ApiServices();
  final TextEditingController _search = TextEditingController();

  City? city;
  Suburb? suburb;

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

    _apiServices.post(context: context, endpoint: 'mostpopular.php', body: {
      "mode": "mobile",
      "findem": widget.categoryName,
      "suburb": suburb!.cityName == 'Select Suburb' ? '' : suburb!.cityName,
      "city": city!.cityName == 'Select City' ? '' : city!.cityName,
    }).then((value) {
      if (value['companies_list'] == null) {
        provider.changeCompanies([]);
      } else {
        provider.changeCompanies(value['companies_list']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SingleChildScrollView(child:
                Consumer<ProductProvider>(builder: (context, provider, _) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    statusBar(context),
                    Center(
                        child: SizedBox(
                            width: 100,
                            child:
                                Image.asset('assets/icons/banner_icon.png'))),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Nav.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back)),
                        Text(widget.categoryName,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
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
                              if (_search.text.isEmpty) {
                                getData();
                              } else {
                                List<dynamic> list = [];
                                for (int i = 0;
                                    i < provider.companies.length;
                                    i++) {
                                  if (provider.companies[i]['gen_company_name']
                                      .toLowerCase()
                                      .contains(_search.text.toLowerCase())) {
                                    list.add(provider.companies[i]);
                                  }
                                }
                                provider.clearCompanies();
                                provider.changeCompanies(list);
                              }
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
                    provider.companies == null
                        ? gap(0)
                        : provider.companies.length == 0
                            ? emptyMessage('Companies')
                            : ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: provider.companies.length,
                                separatorBuilder: (context, index) {
                                  return gap(10);
                                },
                                itemBuilder: (context, index) {
                                  return customCard(provider.companies[index],
                                      gallery: false, byNowOnTap: () {
                                    provider.changeProducts(null);
                                    Nav.push(
                                        context,
                                        BuyNowScreen(
                                            companyName:
                                                provider.companies[index]
                                                    ['gen_company_name'],
                                            companyId: provider.companies[index]
                                                ['fem_company_login_id']));
                                  }, ontapCompany: () {
                                    Nav.push(
                                        context,
                                        CompanyDetails(
                                            companyId: provider.companies[index]
                                                ['fem_company_login_id']));
                                  });
                                },
                              )
                  ]);
            }))));
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
