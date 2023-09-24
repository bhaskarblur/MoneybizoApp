import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:money_bizo/providers/cart_provider.dart';
import 'package:money_bizo/providers/profile_provider.dart';
import 'package:money_bizo/screens/tab_screens/cart_screens/confirm_order_screen.dart';
import 'package:money_bizo/widget/sahared_prefs.dart';
import 'package:provider/provider.dart';
import '../../../api_services.dart';
import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';
import '../home_screens/payment_success_screen.dart';
import '../profile_screens/delivery_address_screen.dart';

class PinScreen extends StatefulWidget {
  final String? pageName;
  final String? qr;
  final String? email;
  final String? amount;
  final String? companyName;
  final bool? canShop;

  const PinScreen({
    super.key,
    this.qr,
    this.email,
    this.amount,
    this.companyName,
    this.pageName,
    this.canShop,
  });

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final ApiServices _apiServices = ApiServices();

  List<String> pin = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
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
                  gap(10),
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Nav.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            size: 26,
                          )),
                      horGap(10),
                      const Text('Enter Pin',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  gap(60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      numberTile(0),
                      horGap(10),
                      numberTile(1),
                      horGap(10),
                      numberTile(2),
                      horGap(10),
                      numberTile(3),
                    ],
                  ),
                  gap(50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: GridView.builder(
                        itemCount: 12,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 7,
                                crossAxisSpacing: 7,
                                childAspectRatio: 1.8),
                        itemBuilder: (context, index) {
                          return index == 11
                              ? InkWell(
                                  onTap: () {
                                    pin.clear();
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black),
                                    child: const Icon(Icons.backspace_outlined,
                                        color: Colors.white, size: 30),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    if (pin.length < 4) {
                                      if (index == 10) {
                                        pin.add('0');
                                      } else if (index == 9) {
                                        pin.add('.');
                                      } else {
                                        pin.add((index + 1).toString());
                                      }
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey.shade100),
                                      child: Center(
                                          child: Text(
                                              index == 10
                                                  ? '0'
                                                  : index == 9
                                                      ? '.'
                                                      : (index + 1).toString(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.bold)))),
                                );
                        }),
                  ),
                  gap(40),
                  Center(
                      child: fullWidthButton(
                          buttonName: 'Submit',
                          onTap: () {
                            final provider = Provider.of<ProfileProvider>(
                                context,
                                listen: false);
                            Prefs.getBool('company').then((value) {
                              if (widget.pageName == 'cart') {
                                if (value!) {
                                  placeOrder();
                                } else {
                                  print(provider.profile['PIN']);
                                  if (provider.profile['PIN'] ==
                                      pin.join().toString()) {
                                    placeOrder();
                                  } else {
                                    dialog(context, 'Pin Does not match.', () {
                                      Nav.pop(context);
                                    });
                                  }
                                }
                              }
                              if (widget.pageName == 'pay') {
                                if (value!) {
                                  pay();
                                } else {
                                  print(provider.profile['PIN']);
                                  if (provider.profile['PIN'] ==
                                      pin.join().toString()) {
                                    pay();
                                  } else {
                                    dialog(context, 'Pin Does not match.', () {
                                      Nav.pop(context);
                                    });
                                  }
                                }
                              }
                            });
                          },
                          width: 150))
                ]))));
  }

  placeOrder() {
    if (widget.canShop!) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);

      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      if (profileProvider.profile['gene_city'] == '' &&
          profileProvider.profile['gene_suburb']) {
        Nav.push(context, const DeliveryAddressScreen());
      } else {
        List<dynamic> prod = [];
        cartProvider.cartProducts.forEach((element) {
          prod.add(element.toJson());
        });
        Prefs.getToken().then((token) {
          Prefs.getPrefs('loginId').then((loginId) {
            _apiServices.post(
                context: context,
                endpoint: 'shopping/checkout_process_mob.php',
                body: {
                  "fem_user_login_id": loginId,
                  "type": "user",
                  "mode": "mobile",
                  "access_token": token,
                  "comments": "",
                  "chkoutType": "2",
                  "products": jsonEncode(prod),
                }).then((value) {
              if (value['return'] == 'success') {
                Prefs.deleteData('cart');
                cartProvider.clearCart();
                Nav.pushAndRemoveAll(context, const ConfirmOrderScreen());
              } else {
                dialog(context, value['message'], () {
                  Nav.pop(context);
                });
              }
            });
          });
        });
      }
    } else {
      dialog(context,
          'You cannot place order, either you are not verified or you dont have funds.',
          () {
        Nav.pop(context);
      });
    }
  }

  pay() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    Prefs.getBool('company').then((company) {
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getToken().then((token) {
          _apiServices
              .post(
            context: context,
            endpoint: 'qrcode_terminal.php',
            body: company!
                ? {
                    "fem_company_login_id": loginId,
                    "access_token": token,
                    "qr_code": widget.qr,
                    "qr_email": company
                        ? provider.profile['mymy_loggme']
                        : provider.profile['the_loggme'],
                    "amount": widget.amount,
                    "submit_transaction": "Submit",
                    "type": "company",
                    "mode": "mobile",
                  }
                : {
                    "fem_user_login_id": loginId,
                    "access_token": token,
                    "qr_code": widget.qr,
                    "qr_email": company
                        ? provider.profile['mymy_loggme']
                        : provider.profile['the_loggme'],
                    "amount": widget.amount,
                    "submit_transaction": "Submit",
                    "type": "user",
                    "mode": "mobile",
                  },
          )
              .then((value) {
            if (value['return'] != 'error') {
              Nav.pushAndRemoveAll(
                  context,
                  PaymentSuccessScreen(
                      companyName: widget.companyName ?? value['company_data']['gen_company_name'],
                      code: value['secret_code']));
            } else {
              dialog(context, value['message'][0], () {
                Nav.pop(context);
              });
            }
          });
        });
      });
    });
  }

  Widget numberTile(int index) {
    return Container(
        height: 50,
        width: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.black26),
        child: Center(
            child: Text(pin.length > (index) ? pin[index] : '',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20))));
  }
}
