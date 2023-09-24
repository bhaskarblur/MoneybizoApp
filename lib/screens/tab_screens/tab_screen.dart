import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/screens/tab_screens/home_screens/home_screen.dart';
import 'package:money_bizo/widget/sahared_prefs.dart';
import '../../models/city.dart';
import '../../models/suburb.dart';
import '../../providers/cart_provider.dart';
import '../../providers/city_suburb_provider.dart';
import '../../providers/profile_provider.dart';
import '/providers/home_screen_provider.dart';
import 'my_balance_screen/my_balance_screen.dart';
import 'profile_screens/settings_screen.dart';
import 'cart_screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../app_config/colors.dart';
import 'history_screens/history_screen.dart';
import 'package:http/http.dart' as http;

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final ApiServices _apiServices = ApiServices();

  List<Widget> _screens = [];

  bool com = true;

  @override
  void initState() {
    super.initState();
    functionCall();

    // getProfile();

    Prefs.getBool('company').then((value) {
      value == null ? com = false : com = value;

      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.getSavedCartProduct(context);

      setState(() {});
    });

    final provider = Provider.of<ProfileProvider>(context, listen: false);

    Prefs.getBool('company').then((company) {
      if (company == null) {
        com = false;
      } else {
        com = company;
      }

      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getToken().then((token) {
          _apiServices
              .post(
                  context: context,
                  endpoint: company! ? 'clientBankEdit.php' : 'indexPDF.php',
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
                        })
              .then((value) {
            provider.changeBankDetails(value['bank_details']);
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
          // } else {
          //   showYesNoButton(context, 'You have to login first.', () {
          //     Nav.pop(context);
          //   }, () {
          //     Nav.pop(context);
          //     Nav.push(context, const LoginScreen());
          //   }, button1: 'Cancel', button2: 'Login');
          // }
        });
      });
    });
    getCitySuburb();
  }

  @override
  Widget build(BuildContext context) {
    _screens = [
      // const AllCategoriesScreen(),
      const HomePage(),
      const TxHistoryScreen(),
      if (!com) const CartScreen(),
      const MyBalanceScreen(),
      const ProfileScreen()
    ];

    return Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: false,
        body: Consumer<HomeScreenProvider>(builder: (context, provider, _) {
          return Column(
            children: [
              Expanded(child: _screens[provider.selectedIndex]),
              menu(provider)
            ],
          );
        }));
  }

  Widget menu(HomeScreenProvider provider) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                  onTap: () {
                    provider.changeSelectedIndex(0);
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                          provider.selectedIndex == 0
                              ? 'assets/icons/home_icon_2/home_blue.svg'
                              : 'assets/icons/home_icon_2/home_white.svg',
                          height: 26,
                          width: 26),
                      Text('Home',
                          style: TextStyle(
                              fontSize: 12,
                              color: provider.selectedIndex == 0
                                  ? Colors.blue
                                  : Colors.grey,
                              fontWeight: FontWeight.bold))
                    ],
                  )),
            ),
            Expanded(
              child: InkWell(
                  onTap: () {
                    provider.changeSelectedIndex(1);
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                          provider.selectedIndex == 1
                              ? 'assets/icons/home_icon_2/chart_blue.svg'
                              : 'assets/icons/home_icon_2/chart_white.svg',
                          height: 26,
                          width: 26),
                      Text('Tx History',
                          style: TextStyle(
                              fontSize: 12,
                              color: provider.selectedIndex == 1
                                  ? Colors.blue
                                  : Colors.grey,
                              fontWeight: FontWeight.bold))
                    ],
                  )),
            ),
            if (!com)
              Expanded(
                child: InkWell(
                    onTap: () {
                      provider.changeSelectedIndex(2);
                    },
                    child: Column(
                      children: [
                        SvgPicture.asset(
                            provider.selectedIndex == 2
                                ? 'assets/icons/home_icon_2/cart_blue.svg'
                                : 'assets/icons/home_icon_2/cart_white.svg',
                            height: 26,
                            width: 26),
                        Text('Cart',
                            style: TextStyle(
                                fontSize: 12,
                                color: provider.selectedIndex == 2
                                    ? Colors.blue
                                    : Colors.grey,
                                fontWeight: FontWeight.bold))
                      ],
                    )),
              ),
            Expanded(
              child: InkWell(
                  onTap: () {
                    if (com) {
                      provider.changeSelectedIndex(2);
                    } else {
                      provider.changeSelectedIndex(3);
                    }
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                          com
                              ? provider.selectedIndex == 2
                                  ? 'assets/icons/home_icon_2/WalletmyBalance_blue.svg'
                                  : 'assets/icons/home_icon_2/wallet_white.svg'
                              : provider.selectedIndex == 3
                                  ? 'assets/icons/home_icon_2/WalletmyBalance_blue.svg'
                                  : 'assets/icons/home_icon_2/wallet_white.svg',
                          height: 26,
                          width: 26),
                      Text('My Balances',
                          style: TextStyle(
                              fontSize: 12,
                              color: com
                                  ? provider.selectedIndex == 2
                                      ? Colors.blue
                                      : Colors.grey
                                  : provider.selectedIndex == 3
                                      ? Colors.blue
                                      : Colors.grey,
                              fontWeight: FontWeight.bold))
                    ],
                  )),
            ),
            Expanded(
              child: InkWell(
                  onTap: () {
                    if (com) {
                      provider.changeSelectedIndex(3);
                    } else {
                      provider.changeSelectedIndex(4);
                    }
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                          com
                              ? provider.selectedIndex == 3
                                  ? 'assets/icons/home_icon_2/profile_blue.svg'
                                  : 'assets/icons/home_icon_2/profile_grey.svg'
                              : provider.selectedIndex == 4
                                  ? 'assets/icons/home_icon_2/profile_blue.svg'
                                  : 'assets/icons/home_icon_2/profile_grey.svg',
                          height: 26,
                          width: 26),
                      Text('Profile',
                          style: TextStyle(
                              fontSize: 12,
                              color: com
                                  ? provider.selectedIndex == 3
                                      ? Colors.blue
                                      : Colors.grey
                                  : provider.selectedIndex == 4
                                      ? Colors.blue
                                      : Colors.grey,
                              fontWeight: FontWeight.bold))
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void functionCall() async {
    var envelope = '''
                  <?xml version="1.0" encoding="utf-8"?>
                    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cen="http://centrix.co.nz">
                      <soapenv:Header/>
                      <soapenv:Body>
                        <cen:GetCreditReportProducts>
                          <cen:CreditReportProductsRequest>
                            <cen:Credentials>
                              <cen:SubscriberID>OPIW</cen:SubscriberID>
                              <cen:UserID>opiwb2buser</cen:UserID>
                              <cen:UserKey>TpyE7QJXP3DKPxTWDjhAmxGh</cen:UserKey>
                            </cen:Credentials>
                            <cen:ServiceProducts>
                              <cen:ServiceProduct>
                                <cen:ProductCode>SmartID</cen:ProductCode>
                              </cen:ServiceProduct>
                            </cen:ServiceProducts>
                            <cen:RequestDetails>
                              <cen:EnquiryReason>IDVF</cen:EnquiryReason>
                              <cen:SubscriberReference>DIA1</cen:SubscriberReference>
                            </cen:RequestDetails>
                            <cen:DriverLicence>
                              <cen:DriverLicenceNumber>BB494022</cen:DriverLicenceNumber> 
                              <cen:DriverLicenceVersion>111</cen:DriverLicenceVersion> 
                            </cen:DriverLicence>
                            <cen:ConsumerData>
                              <cen:Personal>
                                <cen:Surname>ROWLINGS</cen:Surname> 
                                <cen:FirstName>MARK</cen:FirstName>
                                <cen:MiddleName>BRIAN</cen:MiddleName>
                                <cen:DateOfBirth>1975-11-03</cen:DateOfBirth>
                          <cen:Gender>Male</cen:Gender> 
                              </cen:Personal>
                              <cen:Addresses>
                                <cen:Address>
                                  <cen:AddressType>AV</cen:AddressType> 
                                  <cen:AddressLine1>24</cen:AddressLine1>
                                  <cen:AddressLine2>Montgomery</cen:AddressLine2>
                                  <cen:Suburb>Karori</cen:Suburb>
                                  <cen:City>WELLINGTON</cen:City>
                                  <cen:Country>NZL</cen:Country>
                                  <cen:Postcode></cen:Postcode>
                                </cen:Address>
                              </cen:Addresses>
                              <cen:Passport>
                                <cen:PassportNumber>LH123456</cen:PassportNumber> 
                                <cen:Expiry>2026-11-04</cen:Expiry> 
                              </cen:Passport>
                            </cen:ConsumerData>
                            <cen:Consents>
                              <cen:Consent>
                                <cen:Name>DIAPassportVerification</cen:Name>
                                <cen:ConsentGiven>1</cen:ConsentGiven>
                              </cen:Consent>
                            </cen:Consents>
                          </cen:CreditReportProductsRequest>
                        </cen:GetCreditReportProducts>
                      </soapenv:Body>
                    </soapenv:Envelope>
                  ''';

    http.Response response = await http.post(
        Uri.parse('https://test2.centrix.co.nz/v16/Consumers.svc?singlewsdl='),
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          // "SOAPAction": "https://test2.centrix.co.nz",
          "Host": "https://test2.centrix.co.nz/",
          // "Accept": "text/xml"
        },
        body: envelope);

    // var rawXmlResponse = response.body;

    // Use the xml package's 'parse' method to parse the response.
    // xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);

    print("DATAResult=" + response.body);
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

    Prefs.getToken().then((token) {
      Prefs.getBool('company').then((company) {
        Prefs.getPrefs('loginId').then((loginId) {
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
                          },
                    progressBar: false)
                .then((value) {
              final pProvider =
                  Provider.of<ProfileProvider>(context, listen: false);
              pProvider.changeProfile(
                  company ? value['company_detail'] : value['user_profile']);
            });
          }
        });
      });
    });
  }
}
