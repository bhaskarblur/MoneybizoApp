import 'package:flutter/material.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/providers/home_screen_provider.dart';
import 'package:money_bizo/screens/authentication/login_screen.dart';
import 'package:money_bizo/screens/authentication/register_screens/bank_details_screen.dart';
import 'package:money_bizo/screens/authentication/register_screens/payement_schedule.dart';
import 'package:money_bizo/screens/authentication/register_screens/setup_pin_screen.dart';
import 'package:money_bizo/screens/tab_screens/home_screens/upcoming_payment_screens.dart';
import 'package:money_bizo/screens/tab_screens/profile_screens/change_password_screen.dart';
import 'package:money_bizo/screens/tab_screens/profile_screens/qr_grid_screen.dart';
import 'package:money_bizo/widget/navigator.dart';
import 'package:money_bizo/widget/sahared_prefs.dart';
import 'package:provider/provider.dart';
import '../../../app_config/colors.dart';
import '../../../providers/profile_provider.dart';
import '../../../widget/widgets.dart';
import 'withdraw_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiServices _apiServices = ApiServices();

  bool? com;

  @override
  void initState() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    Prefs.getBool('company').then((company) {
      com = company;
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getToken().then((token) {
          if (token != null) {
            _apiServices
                .post(
                    context: context,
                    endpoint:
                        company! ? 'viewClient.php' : 'indexProfileEdit.php',
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
                          })
                .then((value) {
              provider.changeProfile(
                  company ? value['company_detail'] : value['user_profile']);
            });

            _apiServices
                .post(
                    context: context,
                    endpoint: company
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
              provider.changeBalance(value);
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Consumer<ProfileProvider>(builder: (context, provider, _) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: SingleChildScrollView(
                  child: provider.profile == null
                      ? gap(0)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              statusBar(context),
                              Center(
                                  child: SizedBox(
                                      width: 100,
                                      child: Image.asset(
                                          'assets/icons/banner_icon.png'))),
                              const Text('Settings',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              gap(10),
                              FutureBuilder(
                                  future: Prefs.getToken(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data != null) {
                                        return Column(children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black26,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                      height: 60,
                                                      width: 60,
                                                      child: Image.asset(
                                                          'assets/images/Avatar.png')),
                                                  horGap(10),
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            com!
                                                                ? provider
                                                                        .profile[
                                                                    'gen_company_name']
                                                                : '${provider.profile['firstname']} ${provider.profile['lastname']}',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16)),
                                                        Text(
                                                            com!
                                                                ? provider
                                                                        .profile[
                                                                    'mymy_loggme']
                                                                : provider
                                                                        .profile[
                                                                    'the_userme'],
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))
                                                      ]),
                                                ],
                                              ),
                                            ),
                                          ),
                                          gap(15),
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors
                                                            .grey.shade100,
                                                        spreadRadius: 2,
                                                        blurRadius: 2,
                                                        offset:
                                                            const Offset(1, 2))
                                                  ]),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text('Balance',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      if (provider.balance !=
                                                          null)
                                                        Text(
                                                            com!
                                                                ? '\$${provider.balance['available_balance_to_withdraw']}'
                                                                : '\$${provider.balance['user_balances']['total_available_spendings']}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      if (com!)
                                                        InkWell(
                                                          onTap: () {
                                                            Nav.push(context,
                                                                const WithdrawScreen());
                                                          },
                                                          child: const Text(
                                                              'Withdraw',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                    ]),
                                              )),
                                          gap(15),
                                          customTile('Change Payment Setup',
                                              () {
                                            Nav.push(
                                                context,
                                                const PaymentSchedule(
                                                    pageName: 'settings'));
                                          }),
                                          gap(15),
                                          customTile('Upcoming Payments', () {
                                            Nav.push(context,
                                                const UpcomingPaymentsScreen());
                                          }),
                                          gap(15),
                                          customTile('Change Purchase Pin', () {
                                            Nav.push(
                                                context,
                                                const SetupPinScreen(
                                                    pageName: 'settings'));
                                          }),
                                          gap(15),
                                          customTile('Change Password', () {
                                            Nav.push(context,
                                                const ChangePasswordScreen());
                                          }),
                                          // if (!com!) gap(15),
                                          // if (!com!)
                                          //   customTile('Delivery Address', () {
                                          //     Nav.push(context,
                                          //         const DeliveryAddressScreen());
                                          //   }),

                                          if (!com!) gap(15),
                                          if (!com!)
                                            customTile('Bank Details', () {
                                              Nav.push(
                                                  context,
                                                  const BankDetailsScreen(
                                                      pageName: 'settings'));
                                            }),
                                          if (com!) gap(15),
                                          if (com!)
                                            customTile('QR Code', () {
                                              Nav.push(context,
                                                  const QRGridScreen());
                                            }),
                                          gap(40),
                                          Center(
                                            child: fullWidthButton(
                                                buttonName: 'Logout',
                                                onTap: () {
                                                  final provider = Provider.of<
                                                          HomeScreenProvider>(
                                                      context,
                                                      listen: false);
                                                  Prefs.clearPrefs();
                                                  Nav.push(context,
                                                      const LoginScreen());
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 1), () {
                                                    provider
                                                        .changeSelectedIndex(0);
                                                  });
                                                },
                                                width: 200,
                                                height: 40),
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

  customTile(String text, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade100,
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(1, 2))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(text,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ]),
          )),
    );
  }
}
