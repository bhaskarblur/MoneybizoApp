import 'dart:io';
import 'package:flutter/material.dart';
import 'package:money_bizo/screens/tab_screens/home_screens/pay_screen.dart';
import 'package:money_bizo/widget/navigator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
          Positioned(
              top: 60,
              child: IconButton(
                  onPressed: () {
                    Nav.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back,
                      size: 30, color: Colors.grey)))
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (result == null) {
        print(scanData.code);
        result = scanData;
        Nav.push(context, PayScreen(qr: scanData.code));
      }
    }).onDone(() {
      print('done');
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
