import 'package:flutter/material.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/models/city.dart';
import 'package:money_bizo/models/suburb.dart';
import 'package:money_bizo/providers/city_suburb_provider.dart';
import 'package:money_bizo/widget/navigator.dart';
import 'package:provider/provider.dart';
import '../../../app_config/colors.dart';
import '../../../widget/sahared_prefs.dart';
import '../../../widget/widgets.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _house = TextEditingController();
  final TextEditingController _street = TextEditingController();
  final TextEditingController _postCode = TextEditingController();

  City? city;
  Suburb? suburb;

  @override
  void initState() {
    final provider = Provider.of<CitySuburbProvider>(context, listen: false);

    city = provider.city[0];
    suburb = provider.suburb[0];

    Prefs.getPrefs('loginId').then((loginId) {
      Prefs.getToken().then((token) {
        _apiServices.post(
            context: context,
            endpoint: 'shopping/checkout_shipping_address_mob.php',
            body: {
              "fem_user_login_id": loginId,
              "type": "user",
              "mode": "mobile",
              "access_token": token,
              "task": "getAddress"
            }).then((value) {
          city = provider.city
              .where((element) =>
                  element.cityId == value['address_data']['c_ship_city'])
              .first;
          suburb = provider.suburb
              .where((element) =>
                  element.cityId == value['address_data']['c_ship_suburb'])
              .first;

          _house.text = value['address_data']['c_ship_name'];
          _street.text = value['address_data']['c_ship_street_address'];
          _postCode.text = value['address_data']['c_ship_postcode'];
          setState(() {});
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Consumer<CitySuburbProvider>(builder: (context, provider, _) {
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
                          child: Image.asset('assets/icons/banner_icon.png'))),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Nav.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back)),
                      const Text('Delivery Address',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  gap(20),
                  Column(children: [
                    tf(_house, 'House/building name'),
                    gap(10),
                    tf(_street, 'Street address'),
                    if (provider.city.isNotEmpty) gap(10),
                    if (provider.city.isNotEmpty)
                      dd(provider.city, city, (value) {
                        setState(() {
                          city = value;
                        });
                      }),
                    if (provider.suburb.isNotEmpty) gap(10),
                    if (provider.suburb.isNotEmpty)
                      dd(provider.suburb, suburb, (value) {
                        setState(() {
                          suburb = value;
                        });
                      }),
                    gap(10),
                    tf(_postCode, 'Postal Code'),
                  ]),
                ])));
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fullWidthButton(
          buttonName: 'Submit',
          onTap: () {
            if (city == '') {
              dialog(context, 'Enter City', () {
                Nav.pop(context);
              });
            } else {
              if (suburb == '') {
                dialog(context, 'Enter Suburb', () {
                  Nav.pop(context);
                });
              } else {
                Prefs.getPrefs('loginId').then((loginId) {
                  Prefs.getToken().then((token) {
                    _apiServices.post(
                        context: context,
                        endpoint: 'shopping/checkout_shipping_address_mob.php',
                        body: {
                          "fem_user_login_id": loginId,
                          "type": "user",
                          "mode": "mobile",
                          "access_token": token,
                          "c_ship_name": _house.text,
                          "c_ship_street_address": _street.text,
                          "c_ship_city": city!.cityId,
                          "c_ship_suburb": suburb!.cityId,
                          "c_ship_postcode": _postCode.text,
                          "c_ship_country_id": "1",
                        }).then((value) {
                      dialog(context, value['message'], () {
                        Nav.pop(context);
                      });
                    });
                  });
                });
              }
            }
          }),
    );
  }

  TextField tf(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200))),
    );
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
