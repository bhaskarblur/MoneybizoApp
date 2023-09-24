import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/providers/home_screen_provider.dart';
import 'package:money_bizo/providers/product_provider.dart';
import 'package:money_bizo/screens/tab_screens/home_screens/companies_screen.dart';
import 'package:money_bizo/screens/tab_screens/home_screens/search_screen.dart';
import 'package:money_bizo/screens/tab_screens/home_screens/see_all_companies_products.dart';
import 'package:money_bizo/screens/tab_screens/home_screens/upcoming_payment_screens.dart';
import 'package:money_bizo/screens/tab_screens/saved_screens/saved_screen.dart';
import 'package:money_bizo/widget/navigator.dart';
import 'package:provider/provider.dart';
import '../../../app_config/colors.dart';
import '../../../providers/profile_provider.dart';
import '../../../widget/sahared_prefs.dart';
import '../../../widget/widgets.dart';
import '../../authentication/login_screen.dart';
import '../../authentication/register_screens/payement_schedule.dart';
import 'scan_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class IconModel {
  String? title;
  IconData? icon;
  Color? color;
  Color? iconColor;

  IconModel({
    this.title,
    this.icon,
    this.color,
    this.iconColor,
  });
}

class _HomePageState extends State<HomePage> {
  final ApiServices _apiServices = ApiServices();
  final TextEditingController _search = TextEditingController();

  bool com = false;

  final List<String> _images = [
    'assets/images/demo_images/Group 1000002455.png',
    'assets/images/demo_images/Group 1000002507.png',
    'assets/images/demo_images/Group 1000002508.png',
  ];

  final List<IconModel> _icons = [
    IconModel(
      title: 'Total Balance',
      icon: FontAwesomeIcons.dollarSign,
      color: Colors.purple.shade50,
      iconColor: Colors.purple,
    ),
    IconModel(
      title: 'Transactions',
      icon: Icons.swipe,
      color: Colors.green.shade50,
      iconColor: Colors.green,
    ),
    IconModel(
      title: 'Favorites',
      icon: FontAwesomeIcons.heart,
      color: Colors.red.shade50,
      iconColor: Colors.red,
    ),
    IconModel(
      title: 'Payment Setup',
      icon: FontAwesomeIcons.mobile,
      color: Colors.orange.shade50,
      iconColor: Colors.orange,
    ),
    IconModel(
      title: 'Upcoming Payments',
      icon: FontAwesomeIcons.noteSticky,
      color: Colors.yellow.shade50,
      iconColor: Colors.yellow,
    ),
    IconModel(
      title: 'Search',
      icon: FontAwesomeIcons.search,
      color: Colors.blue.shade50,
      iconColor: Colors.blue,
    ),
  ];

  @override
  void initState() {
    getData();
    getCategories();
    super.initState();
  }

  getCategories() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: FutureBuilder(
            future: Prefs.getToken(),
            builder: (context, snapshot) {
              return Padding(
                  padding: const EdgeInsets.all(10),
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
                        Consumer<ProfileProvider>(
                            builder: (context, profileProvider, _) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  profileProvider.profile == null
                                      ? 'Hello There!'
                                      : "Welcome ${profileProvider.company ? profileProvider.profile['gen_company_name'] : profileProvider.profile['firstname']}!",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                              profileProvider.profile == null
                                  ? TextButton(
                                      onPressed: () {
                                        Nav.push(context, const LoginScreen());
                                      },
                                      child: const Text('Login',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue)))
                                  : InkWell(
                                      onTap: () {
                                        Nav.push(context, const ScanPage());
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xFF033482),
                                            borderRadius:
                                                BorderRadius.circular(90)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 9),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                  'assets/icons/scan.png'),
                                              horGap(5),
                                              const Text('Scan',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 16))
                                            ],
                                          ),
                                        ),
                                      ))
                            ],
                          );
                        }),
                        gap(10),
                        if (snapshot.data != null)
                          Consumer<ProfileProvider>(
                              builder: (context, provider, _) {
                            if (provider.balance != null) {
                              return provider.company
                                  ? gap(0)
                                  : Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            final homeProvider =
                                                Provider.of<HomeScreenProvider>(
                                                    context,
                                                    listen: false);
                                            homeProvider.changeSelectedIndex(3);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.blue),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(children: [
                                                Expanded(
                                                  child: Column(children: [
                                                    const Text('Balance',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    if (provider.balance[
                                                            'user_balances'] !=
                                                        null)
                                                      Text(
                                                          '\$${provider.balance['user_balances']['total_available_spendings']}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white)),
                                                  ]),
                                                ),
                                                Container(
                                                    height: 60,
                                                    width: 1,
                                                    color: Colors.white),
                                                Expanded(
                                                  child: Column(children: [
                                                    const Text('Spending',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    Text(
                                                        '\$${provider.balance['user_balances']['user_total_spendings'] ?? 0.00}',
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white)),
                                                  ]),
                                                ),
                                                Container(
                                                    height: 60,
                                                    width: 1,
                                                    color: Colors.white),
                                                Expanded(
                                                  child: Column(children: [
                                                    const Text('Reward',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    Text(
                                                        '\$${provider.balance['user_balances']['general_reward'] ?? 0.00}',
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white)),
                                                  ]),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                            } else {
                              return gap(0);
                            }
                          }),
                        gap(20),
                        TextFormField(
                          controller: _search,
                          decoration: InputDecoration(
                              hintText: 'Search',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.grey.shade300,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10))),
                          onTap: () {
                            Nav.push(context, const SearchScreen());
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an amount';
                            } else {
                              return null;
                            }
                          },
                        ),
                        gap(20),
                        Image.asset('assets/images/homeImage.png',
                            width: double.infinity, fit: BoxFit.cover),
                        gap(20),
                        SizedBox(
                          height: 40,
                          child: Consumer<ProductProvider>(
                              builder: (context, provider, _) {
                            return provider.categories == null
                                ? gap(0)
                                : ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: provider.categories.length,
                                    separatorBuilder: (context, index) {
                                      return horGap(10);
                                    },
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                          onTap: () {
                                            Nav.push(
                                                context,
                                                CompanyScreen(
                                                    categoryName: provider
                                                            .categories[index]
                                                        ['cat_name']));
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                  child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 30,
                                                          vertical: 10),
                                                      child: Text(
                                                          provider.categories[index]
                                                              ['cat_name'],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 16))))));
                                    },
                                  );
                          }),
                        ),
                        // if (snapshot.data == null)
                        gap(20),
                        // if (snapshot.data == null)
                        Row(children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Nav.push(
                                    context,
                                    const SeeAllCompaniesOrProducts(
                                        searchType: 'company'));
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue),
                                child: const Center(
                                  child: Text('See all companies',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                          ),
                          horGap(10),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Nav.push(
                                    context,
                                    const SeeAllCompaniesOrProducts(
                                        searchType: 'product'));
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black),
                                child: const Center(
                                  child: Text('See all products',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                          )
                        ]),
                        if (snapshot.data != null) gap(20),
                        if (snapshot.data != null)
                          const Text('Quick access',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        if (snapshot.data != null) gap(20),
                        if (snapshot.data != null)
                          GridView.builder(
                            shrinkWrap: true,
                            itemCount: _icons.length,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: .9,
                                    crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  final homeProvider =
                                      Provider.of<HomeScreenProvider>(context,
                                          listen: false);
                                  if (index == 0) {
                                    homeProvider.changeSelectedIndex(3);
                                  }
                                  if (index == 1) {
                                    homeProvider.changeSelectedIndex(1);
                                  }
                                  if (index == 2) {
                                    Nav.push(context, const SavedScreen());
                                  }
                                  if (index == 3) {
                                    Nav.push(
                                        context,
                                        const PaymentSchedule(
                                            pageName: 'home'));
                                  }
                                  if (index == 4) {
                                    Nav.push(context,
                                        const UpcomingPaymentsScreen());
                                  }
                                  if (index == 5) {
                                    Nav.push(context, const SearchScreen());
                                  }
                                },
                                child: Column(children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: _icons[index].color,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: index == 1
                                          ? SvgPicture.asset(
                                              'assets/transaction.svg')
                                          : index == 3
                                              ? SvgPicture.asset(
                                                  'assets/paymentsetup.svg')
                                              : index == 4
                                                  ? SvgPicture.asset(
                                                      'assets/upcomingpayments.svg')
                                                  : Icon(_icons[index].icon,
                                                      color: _icons[index]
                                                          .iconColor),
                                    ),
                                  ),
                                  gap(20),
                                  Expanded(
                                      child: Text(_icons[index].title!,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )))
                                ]),
                              );
                            },
                          ),

                        if (!snapshot.hasData) gap(20),
                        if (!snapshot.hasData)
                          const Text(
                              'Join moneybizo users across the Country,and get rewarded as you shop. We reward you with Cash, not points.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        if (!snapshot.hasData) gap(20),
                        if (!snapshot.hasData)
                          const Text('Our Best Selling Collections',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        if (!snapshot.hasData) gap(20),
                        if (!snapshot.hasData)
                          GridView.builder(
                              shrinkWrap: true,
                              itemCount: _images.length,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (context, index) {
                                return Image.asset(_images[index]);
                              }),
                        gap(40)
                      ])));
            }));
  }

  getData() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    Prefs.getBool('company').then((company) {
      provider.changeCompany(company!);
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getToken().then((token) {
          if (token != null) {
            _apiServices
                .post(
                    context: context,
                    endpoint: company ? 'clientBankEdit.php' : 'indexPDF.php',
                    body: company
                        ? {
                            "fem_company_login_id": loginId,
                            "type": "company",
                            "mode": "mobile",
                            "action": 'getAccountDetails',
                            "access_token": token
                          }
                        : {
                            "fem_user_login_id": loginId,
                            "type": "user",
                            "mode": "mobile",
                            "action": 'getAccountDetails',
                            "access_token": token
                          },
                    progressBar: false)
                .then((value) {
              provider.changeBankDetails(value['bank_details']);
            });

            // _apiServices
            //     .post(
            //         context: context,
            //         endpoint: company
            //             ? 'ClientPayment_withdraw.php'
            //             : 'userBalance.php',
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
            //               },
            //         progressBar: false)
            //     .then((value) {
            //   provider.changeBalance(value);
            // });
          } else {
            // showYesNoButton(context, 'You have to login first.', () {
            //   Nav.pop(context);
            // }, () {
            //   Nav.pop(context);
            //   Nav.push(context, const LoginScreen());
            // }, button1: 'Cancel', button2: 'Login');
          }
        });
      });
    });
  }
}
