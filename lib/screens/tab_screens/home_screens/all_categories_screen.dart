import 'package:flutter/material.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/models/city.dart';
import 'package:money_bizo/models/suburb.dart';
import 'package:money_bizo/providers/product_provider.dart';
import 'package:money_bizo/screens/tab_screens/home_screens/companies_screen.dart';
import 'package:money_bizo/widget/navigator.dart';
import 'package:provider/provider.dart';
import '../../../app_config/colors.dart';
import '../../../providers/city_suburb_provider.dart';
import '../../../widget/widgets.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    getData();
    getCitySuburb();
    super.initState();
  }

  getData() {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    _apiServices.post(
        context: context,
        endpoint: 'getCategory.php',
        body: {"profile_keywords": _search.text}).then((value) {
      if (value['return'] == 'success') {
        productProvider.clearCategories();
        productProvider.changeCategories(value['category_arr']);
      } else {
        dialog(context, value['message'], () {
          Nav.pop(context);
        });
      }
    });
  }

  getCitySuburb() {
    final provider = Provider.of<CitySuburbProvider>(context, listen: false);

    provider.clearCity();
    provider.clearsuburb();
    provider.addToCity(City(cityName: 'Select City', cityId: '00'));
    provider.addToSuburb(Suburb(cityName: 'Select Suburb', cityId: '00'));

    _apiServices
        .post(
            context: context,
            endpoint: 'getCity.php',
            progressBar: false,
            internetCheck: false)
        .then((value) {
      for (int i = 0; i < value['city_list'].length; i++) {
        provider.addToCity(City.fromJson(value['city_list'][i]));
      }
      provider.notify();
      print(provider.city.length);
    });

    _apiServices
        .post(
            context: context,
            endpoint: 'getSuburb.php',
            progressBar: false,
            internetCheck: false)
        .then((value) {
      for (int i = 0; i < value['suburb_list'].length; i++) {
        provider.addToSuburb(Suburb.fromJson(value['suburb_list'][i]));
      }
      provider.notify();
      print(provider.suburb.length);
    });

    // Prefs.getToken().then((token) {
    //   Prefs.getPrefs('loginId').then((loginId) {
    //     if (token != null) {
    //       _apiServices
    //           .post(
    //               context: context,
    //               endpoint: 'indexProfileEdit.php',
    //               body: {
    //                 "fem_user_login_id": loginId,
    //                 "type": "user",
    //                 "mode": "mobile",
    //                 "access_token": token
    //               },
    //               progressBar: false,
    //               internetCheck: false)
    //           .then((value) {
    //         final pProvider =
    //             Provider.of<ProfileProvider>(context, listen: false);
    //         pProvider.changeProfile(value['user_profile']);
    //       });
    //     }
    //   });
    // });
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
                        const Text('Home',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    gap(10),
                    serachBar(_search, () {}, onChanged: (value) {
                      if (value.isEmpty) {
                        provider.clearSearchedCategories();
                      }
                    }, onEditingComplete: () {
                      // getData();
                      provider.changeSearchedCategories(_search.text);
                    }, filter: false),
                    gap(20),
                    if (provider.categories != null)
                      provider.searchedCategories != null
                          ? ListView.separated(
                              shrinkWrap: true,
                              itemCount: provider.searchedCategories.length,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) {
                                return gap(10);
                              },
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    final provider =
                                        Provider.of<ProductProvider>(context,
                                            listen: false);
                                    provider.changeCompanies(null);
                                    Nav.push(
                                        context,
                                        CompanyScreen(
                                          categoryName:
                                              provider.searchedCategories[index]
                                                  ['cat_name'],
                                        ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Colors.grey.shade400)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                          provider.searchedCategories[index]
                                              ['cat_name'],
                                          style: const TextStyle(
                                              decoration:
                                                  TextDecoration.underline)),
                                    ),
                                  ),
                                );
                              },
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: provider.categories.length,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) {
                                return gap(10);
                              },
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    final provider =
                                        Provider.of<ProductProvider>(context,
                                            listen: false);
                                    provider.changeCompanies(null);
                                    Nav.push(
                                        context,
                                        CompanyScreen(
                                          categoryName: provider
                                              .categories[index]['cat_name'],
                                        ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Colors.grey.shade400)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                          provider.categories[index]
                                              ['cat_name'],
                                          style: const TextStyle(
                                              decoration:
                                                  TextDecoration.underline)),
                                    ),
                                  ),
                                );
                              },
                            )
                  ]);
            }))));
  }
}
