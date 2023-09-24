import 'package:flutter/material.dart';
import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';
import '../tab_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String? code;
  final String? companyName;
  const PaymentSuccessScreen({super.key, this.code, this.companyName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            statusBar(context),
            Center(
                child: SizedBox(
                    width: 100,
                    child: Image.asset('assets/icons/banner_icon.png'))),
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/pay_success.png'),
                    gap(20),
                    const Text('Payment Successful',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    gap(10),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          const TextSpan(
                              text: 'Your payment to ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          TextSpan(
                              text: companyName,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const TextSpan(
                              text: ' has been successfully done.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                        ])),
                    gap(40),
                    const Text('Verification code',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    gap(20),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFEBF0F8),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          code!,
                          style: const TextStyle(
                              color: Color(0xFF5A92ED),
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                      ),
                    ),
                    gap(20),
                  ]),
            )
          ])),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: fullWidthButton(
            buttonName: 'Back to home',
            onTap: () {
              Nav.pushAndRemoveAll(context, const TabScreen());
            }),
      ),
    );
  }
}
