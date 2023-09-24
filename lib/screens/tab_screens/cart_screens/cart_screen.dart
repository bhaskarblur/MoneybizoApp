import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/app_config/app_details.dart';
import 'package:money_bizo/models/product.dart';
import 'package:money_bizo/providers/cart_provider.dart';
import 'package:money_bizo/providers/home_screen_provider.dart';
import 'package:money_bizo/screens/authentication/register_screens/cart_login_screens/get_started_screen.dart';
import 'package:money_bizo/screens/tab_screens/cart_screens/pin_screen.dart';
import 'package:money_bizo/widget/navigator.dart';
import 'package:money_bizo/widget/sahared_prefs.dart';
import 'package:provider/provider.dart';
import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';
import '../../authentication/login_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ApiServices _apiServices = ApiServices();

  // final TextEditingController _search = TextEditingController();
  var canShop = false;

  @override
  void initState() {
    super.initState();

    Prefs.getBool('company').then((company) {
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getToken().then((token) {
          if (token != null) {
            // _apiServices
            //     .post(
            //         context: context,
            //         endpoint:
            //             company! ? 'viewClient.php' : 'indexProfileEdit.php',
            //         body: company
            //             ? {
            //                 "fem_company_login_id": loginId,
            //                 "type": "user",
            //                 "mode": "mobile",
            //                 "access_token": token
            //               }
            //             : {
            //                 "fem_user_login_id": loginId,
            //                 "type": "user",
            //                 "mode": "mobile",
            //                 "access_token": token
            //               })
            //     .then((value) {});

            _apiServices
                .post(
                    context: context,
                    endpoint: company!
                        ? 'ClientPayment_withdraw.php'
                        : 'userBalance.php',
                    body: company
                        ? {
                            "fem_company_login_id": loginId,
                            "type": "user",
                            "mode": "mobile",
                            "access_token": token
                          }
                        : {
                            "fem_user_login_id": loginId,
                            "type": "user",
                            "mode": "mobile",
                            "access_token": token
                          },
                    progressBar: false)
                .then((value) {
              var balance = value['user_balances']['total_available_spendings']
                  .toString()
                  .replaceAll(',', '');
              print(double.parse(balance));
              if (double.parse(balance) > 0) {
                canShop = true;
              } else {
                canShop = false;
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

    Prefs.getToken().then((value) {
      if (value == null) {
        // if (!provider.loggedIn) {
        Future.delayed(const Duration(milliseconds: 100), () {
          cartModalBottomSheet();
        });
        // }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Consumer<CartProvider>(builder: (context, cartProvider, _) {
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
                    const Text('Shopping Cart',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    gap(10),
                    // serachBar(_search, () {}),
                    cartProvider.cartProducts.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Total: \$${cartProvider.getTotal().toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              gap(10),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(0),
                                itemCount: cartProvider.cartProducts.length,
                                separatorBuilder: (context, index) {
                                  return gap(10);
                                },
                                itemBuilder: (context, index) {
                                  return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        card(cartProvider.cartProducts[index]),
                                      ]);
                                },
                              ),
                              gap(20),
                              fullWidthButton(
                                  buttonName: 'Place Order',
                                  onTap: () {
                                    Nav.push(
                                        context,
                                        PinScreen(
                                          canShop: canShop,
                                          pageName: 'cart',
                                        ));
                                  })
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                const Row(children: []),
                                gap(100),
                                SvgPicture.asset('assets/images/cart.svg'),
                                gap(30),
                                const Text('Your shopping cart is empty!',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                gap(15),
                                const Text('There is no products',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                              ]),
                  ])));
        }));
  }

  card(Product product) {
    final provider = Provider.of<CartProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                height: 60,
                width: 60,
                child: product.image == null || product.image == ''
                    ? Image.asset('assets/images/food.png', fit: BoxFit.cover)
                    : Image.network(baseUrl + product.image!,
                        fit: BoxFit.cover)),
            horGap(10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(product.name!,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(product.description.toString(),
                      maxLines: 3, style: const TextStyle(color: Colors.grey)),
                ])),
          ]),
        ),
        dottedDivder(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Product Price: \$${product.price!.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.black54)),
              Row(children: [
                const Text("Qty: ", style: TextStyle(color: Colors.black54)),
                horGap(5),
                Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Row(children: [
                      InkWell(
                        onTap: () {
                          provider.removeFromCart(product);
                          provider.saveCartProducts();
                        },
                        child: Container(
                            color: Colors.white,
                            child: const Icon(Icons.remove)),
                      ),
                      SizedBox(
                        width: 26,
                        child: Center(
                          child: Text(product.quantity.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          provider.addToCart(context, product);
                          provider.saveCartProducts();
                        },
                        child: Container(
                            color: Colors.white, child: const Icon(Icons.add)),
                      ),
                    ]),
                  ),
                )
              ])
            ],
          ),
        ),
        dottedDivder(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
              "Sub Total: \$${(product.price! * product.quantity!).toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.black54)),
        ),
      ]),
    );
  }

  cartModalBottomSheet() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height / 1.3,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        statusBar(context),
                        Center(
                            child: SizedBox(
                                width: 100,
                                child: Image.asset(
                                    'assets/icons/banner_icon.png'))),
                        gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Items / Information',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            InkWell(
                              onTap: () {
                                Nav.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Icon(FontAwesomeIcons.xmark,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        const Text('You\'ll need to register',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blue)),
                        gap(10),
                        requirementTile('Your Mobile No.'),
                        gap(10),
                        requirementTile('Your Email Address'),
                        gap(10),
                        requirementTile('Your Valid New Zealand  Address'),
                        gap(10),
                        requirementTile(
                            'New Zealand Passport Or Driving License'),
                        gap(10),
                        requirementTile(
                            'A copy or picture of a bank statement showing account name and account number'),
                        gap(20),
                        const Text('Are you ready?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        gap(5),
                        const Text('Please click any of button below.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        gap(20),
                        Row(
                          children: [
                            Expanded(
                                child: fullWidthButton(
                                    buttonName: 'Okay I’m Ready',
                                    onTap: () {
                                      Nav.push(
                                          context, const GetStartedScreen());
                                    })),
                            Expanded(
                              child: borderedButton(
                                  buttonName: 'I’ll come back later',
                                  onTap: () {
                                    Nav.pop(context);
                                    final provider =
                                        Provider.of<HomeScreenProvider>(context,
                                            listen: false);
                                    provider.changeSelectedIndex(0);
                                  }),
                            ),
                          ],
                        ),
                      ]),
                ),
              ));
        });
  }

  requirementTile(String text) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                offset: const Offset(0, 2),
                blurRadius: 2,
                spreadRadius: 2)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(text, style: const TextStyle(color: Colors.black87)),
      ),
    );
  }
}
