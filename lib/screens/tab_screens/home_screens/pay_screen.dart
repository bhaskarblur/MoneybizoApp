import 'package:flutter/material.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/screens/tab_screens/cart_screens/pin_screen.dart';
import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/sahared_prefs.dart';
import '../../../widget/widgets.dart';

class PayScreen extends StatefulWidget {
  const PayScreen(
      {super.key,
      this.qr,
      this.email,
      this.companyName,
      this.companyDescription,
      this.amount});
  final String? qr;
  final String? email;
  final String? companyName;
  final String? companyDescription;
  final String? amount;

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _amount = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool company = false;

  String companyName = '';
  String companyDescription = '';
  String companyEmail = '';

  @override
  void initState() {
    if (widget.qr != null) {
      Prefs.getPrefs("loginId").then((loginId) {
        Prefs.getToken().then((token) {
          _apiServices
              .post(context: context, endpoint: 'qr_company_detail.php', body: {
            "fem_user_login_id": loginId,
            "type": "user",
            "mode": "mobile",
            "access_token": token,
            "qr_code": widget.qr
          }).then((value) {
            companyName = value['company_data']['gen_company_name'];
            companyEmail = value['company_data']['mymy_loggme'];
            companyDescription =
                '${value['company_data']['gen_street']}, ${value['company_data']['gen_suburb']}, ${value['company_data']['gen_city']}, ${value['company_data']['gen_postal']}, ${value['company_data']['gen_country']}';
            setState(() {});
          });
        });
      });
    }

    if (widget.companyName != null) {
      companyName = widget.companyName!;
      companyDescription = widget.companyDescription!;
      if (widget.amount != null) {
        _amount.text = widget.amount!;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          SingleChildScrollView(
              child: Column(children: [
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
                    icon: const Icon(Icons.arrow_back, size: 30)),
              ],
            ),
            gap(50),
            Image.asset('assets/shopimage.png', height: 120, width: 120),
            gap(20),
            const Text('Pay To',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            gap(20),
            Text(companyName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            gap(20),
            Text(companyDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey)),
            gap(20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: IntrinsicWidth(
                    child: TextFormField(
                      controller: _amount,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.text,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                          prefixText: "\$",
                          hintText: '0',
                          filled: true,
                          fillColor: Colors.transparent,
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an amount';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            gap(20),
          ]))
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                Nav.push(
                    context,
                    PinScreen(
                        pageName: 'pay',
                        qr: widget.qr,
                        email: companyEmail,
                        companyName: widget.companyName,
                        amount: _amount.text));
              }
            },
            child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue),
                child: const Center(
                  child: Text('Continue to make payment',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                )),
          ),
        ),
      ),
    );
  }
}
