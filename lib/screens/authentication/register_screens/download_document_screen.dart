import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:money_bizo/screens/authentication/register_screens/upload_documents.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';

class DownloadDocument extends StatefulWidget {
  const DownloadDocument({super.key});

  @override
  State<DownloadDocument> createState() => _DownloadDocumentState();
}

class _DownloadDocumentState extends State<DownloadDocument> {
  String selectedValue = '';

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
                        child: Image.asset('assets/icons/banner_icon.png')),
                  ),
                  gap(10),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Nav.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back, size: 30)),
                      const Text('Download Document',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  gap(10),
                  DottedBorder(
                    color: Colors.grey.shade600,
                    strokeWidth: 1,
                    dashPattern: const [10, 10],
                    child: InkWell(
                      onTap: () async {
                        progressLoader(context);
                        downloadFile(
                            'https://testingprowze.prowzer.co.nz/print_file.php');
                      },
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            children: [
                              Icon(Icons.download, size: 50),
                              Text('Download Document',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  gap(30),
                  fullWidthButton(
                      buttonName: 'Next',
                      onTap: () {
                        Nav.push(context, const UploadDocument());
                      }),
                ]))));
  }

  Widget radioTile(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        clipBehavior: Clip.none,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 3,
                  spreadRadius: 3,
                  offset: const Offset(0, 2))
            ]),
        child: RadioListTile(
          groupValue: selectedValue,
          value: title,
          title: Text(title),
          activeColor: primaryColor,
          onChanged: (value) {
            selectedValue = value!;
            print(value);
            setState(() {});
          },
        ),
      ),
    );
  }

  progressLoader(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: primaryColor,
            contentPadding: const EdgeInsets.all(15),
            content: const Row(
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(width: 20),
                Text('Downloading...',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))
              ],
            ),
          );
        });
  }

  downloadFile(String url) async {
    print('download');

    final status = await Permission.storage.request();

    print('download1');

    if (status.isGranted) {
      print('download2');

      final storage = Platform.isAndroid
          ? Directory('/storage/emulated/0/Download') //FOR ANDROID
          : await getApplicationDocumentsDirectory(); //FOR iOS

      print(storage.path);

      print('....');
      await Dio()
          .download(url, '${storage.path}/bankFile.pdf',
              onReceiveProgress: (total, fraction) {})
          .then((value) {
        Nav.pop(context);
        if (value.statusCode == 200) {
          dialog(context, 'Download Complete\n${storage.path}', () {
            Nav.pop(context);
          });
        } else {
          dialog(context, 'Something went wrong', () {
            Nav.pop(context);
          });
        }
        // Nav.push(context, const UploadDocument());
      });
    } else {
      print('download3');
      print('No permission');
    }
    print('download4');
  }
}
