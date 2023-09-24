import 'package:flutter/material.dart';
import 'package:money_bizo/models/suburb.dart';
import 'package:money_bizo/screens/authentication/login_screen.dart';
import 'package:provider/provider.dart';
import '../../../api_services.dart';
import '../../../app_config/colors.dart';
import '../../../models/city.dart';
import '../../../providers/city_suburb_provider.dart';
import '../../../providers/saved_provider.dart';
import '../../../widget/navigator.dart';
import '../../../widget/sahared_prefs.dart';
import '../../../widget/widgets.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _search = TextEditingController();

  City? city;
  Suburb? suburb;

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
    final provider = Provider.of<SavedProvider>(context, listen: false);
    Prefs.getBool("company").then((company) {
      Prefs.getPrefs("loginId").then((loginId) {
        Prefs.getToken().then((token) {
          if (token != null) {
            _apiServices
                .post(
                    context: context,
                    endpoint: company! ? 'favoriteCompany.php' : 'favorite.php',
                    body: company
                        ? {
                            "fem_company_login_id": loginId,
                            // "type": "user",
                            "mode": "mobile",
                            "access_token": token,
                            if (_search.text.isNotEmpty) "findem": _search.text,

                            "suburb": suburb!.cityName == 'Select Suburb'
                                ? ''
                                : suburb!.cityName,
                            "city": city!.cityName == 'Select City'
                                ? ''
                                : city!.cityName,
                          }
                        : {
                            "fem_user_login_id": loginId,
                            "type": "user",
                            "mode": "mobile",
                            "access_token": token,
                            if (_search.text.isNotEmpty) "findem": _search.text,
                            "suburb": suburb!.cityName == 'Select Suburb'
                                ? ''
                                : suburb!.cityName,
                            "city": city!.cityName == 'Select City'
                                ? ''
                                : city!.cityName,
                          })
                .then((value) {
              if (value['message'] == '') {
                provider.changeFavorites([]);
                dialog(context, 'No saved companies.', () {
                  Nav.pop(context);
                });
              } else {
                provider.changeFavorites(value['companies_list']);
              }
            });
          } else {
            showYesNoButton(context, 'You have to login first.', () {
              Nav.pop(context);
            }, () {
              Nav.pop(context);
              Nav.push(context, const LoginScreen());
            }, button1: 'Cancel', button2: 'Login');
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Consumer<SavedProvider>(builder: (context, provider, _) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    statusBar(context),
                    Center(
                        child: SizedBox(
                            width: 100,
                            child:
                                Image.asset('assets/icons/banner_icon.png'))),
                    gap(10),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Nav.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back)),
                        horGap(10),
                        const Text('Saved',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    gap(10),
                    FutureBuilder(
                        future: Prefs.getToken(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data != null) {
                              return Column(children: [
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
                                        child: dd(csProvider.suburb, suburb,
                                            (value) {
                                          suburb = value!;
                                          setState(() {});
                                        }),
                                      ),
                                      horGap(10),
                                      Expanded(
                                        child:
                                            dd(csProvider.city, city, (value) {
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
                                        city!.cityName != 'Select City' ||
                                        suburb!.cityName != 'Select Suburb')
                                      fullWidthButton(
                                          buttonName: 'Clear Filter',
                                          onTap: () {
                                            final citySuburb =
                                                Provider.of<CitySuburbProvider>(
                                                    context,
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
                                provider.saved == null
                                    ? gap(0)
                                    : provider.saved.length < 1
                                        ? emptyMessage('Favorites')
                                        : ListView.separated(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: 10,
                                            separatorBuilder: (context, index) {
                                              return gap(10);
                                            },
                                            itemBuilder: (context, index) {
                                              return customCard('asd');
                                            },
                                          )
                              ]);
                            } else {
                              return gap(0);
                            }
                          } else {
                            return gap(0);
                          }
                        }),
                  ])));
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
