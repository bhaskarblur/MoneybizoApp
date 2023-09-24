import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_config/colors.dart';
import '../../../providers/home_screen_provider.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';
import '../tab_screen.dart';

class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({super.key});

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              statusBar(context),
              Center(
                  child: SizedBox(
                      width: 100,
                      child: Image.asset('assets/icons/banner_icon.png'))),
              gap(10),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Order Placced Successfully',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      gap(20),
                      Image.asset('assets/images/thank_you.png'),
                      gap(20),
                      fullWidthButton(
                          buttonName: 'Back',
                          onTap: () {
                            final provider = Provider.of<HomeScreenProvider>(
                                context,
                                listen: false);
                            // Nav.pop(context);
                            provider.changeSelectedIndex(0);
                            Nav.pushAndRemoveAll(context, const TabScreen());
                          })
                    ]),
              )
            ])));
  }
}
