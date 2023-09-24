import 'package:flutter/material.dart';
import 'package:money_bizo/app_config/app_details.dart';
import 'package:money_bizo/providers/city_suburb_provider.dart';
import 'package:money_bizo/widget/navigator.dart';
import 'package:provider/provider.dart';
import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

class QRScreen extends StatefulWidget {
  final dynamic data;
  const QRScreen({super.key, this.data});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Consumer<CitySuburbProvider>(builder: (context, provider, _) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  const Text('QR Code',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
              gap(50),
              Center(
                child: Column(children: [
                  Text(widget.data['lable'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  gap(2),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2)),
                    child: Image.network(baseUrl + widget.data['url'],
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width / 1.3),
                  ),
                ]),
              ),
            ]));
      }),
    );
  }
}
