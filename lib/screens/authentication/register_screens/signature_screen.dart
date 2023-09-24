import "dart:convert";
import "dart:typed_data";
import "dart:ui";
import "package:flutter/material.dart";
import "package:money_bizo/api_services.dart";
import "package:money_bizo/screens/tab_screens/tab_screen.dart";
import "package:money_bizo/widget/sahared_prefs.dart";
import "package:screenshot/screenshot.dart";
import "../../../app_config/colors.dart";
import "../../../widget/navigator.dart";
import "../../../widget/widgets.dart";

class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key});

  @override
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  final ApiServices _apiServices = ApiServices();

  final ScreenshotController _ss = ScreenshotController();

  GlobalKey previewContainer = GlobalKey();

  Color selectedColor = Colors.black;

  double strokeWidth = 4;

  Uint8List? uImage;

  List<dynamic> drawingPoints = [];

  List<Color> colors = [
    Colors.pink,
    Colors.red,
    Colors.black,
    Colors.yellow,
    Colors.amberAccent,
    Colors.purple,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey))),
                  gap(5),
                  const Text('Signature inside the box',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Screenshot(
                    controller: _ss,
                    child: ClipRect(
                      child: GestureDetector(
                        onPanStart: (details) {
                          setState(() {
                            drawingPoints.add(
                              DrawingPoint(
                                details.localPosition,
                                Paint()
                                  ..color = selectedColor
                                  ..isAntiAlias = true
                                  ..strokeWidth = strokeWidth
                                  ..strokeCap = StrokeCap.round,
                              ),
                            );
                          });
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            drawingPoints.add(
                              DrawingPoint(
                                details.localPosition,
                                Paint()
                                  ..color = selectedColor
                                  ..isAntiAlias = true
                                  ..strokeWidth = strokeWidth
                                  ..strokeCap = StrokeCap.round,
                              ),
                            );
                          });
                        },
                        onPanEnd: (details) {
                          setState(() {
                            drawingPoints.add(null);
                          });
                        },
                        child: CustomPaint(
                          painter: _DrawingPainter(drawingPoints),
                          child: const SizedBox(
                              height: 400, width: double.infinity),
                        ),
                      ),
                    ),
                  ),
                  gap(5),
                  const Text('Signature inside the box',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.transparent))
                ],
              ),
            ),
          ),
          // Positioned(
          //   top: 40,
          //   right: 30,
          //   child: Row(
          //     children: [
          // Slider(
          //     min: 0,
          //     max: 40,
          //     value: strokeWidth,
          //     onChanged: (val) => setState(() => strokeWidth = val)),
          // ElevatedButton.icon(
          //     onPressed: () => setState(() => drawingPoints = []),
          //     icon: const Icon(Icons.clear, size: 20),
          //     label: const Text("Clear", style: TextStyle(fontSize: 16)))
          //     ],
          //   ),
          // ),
          // if (uImage != null) Image.memory(uImage!)
        ],
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Container(
      //     color: Colors.grey[200],
      //     padding: const EdgeInsets.all(10),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: List.generate(
      //         colors.length,
      //         (index) => _buildColorChose(colors[index]),
      //       ),
      //     ),
      //   ),
      // ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
              onPressed: () async {
                setState(() => drawingPoints = []);
              },
              backgroundColor: errorColor,
              child: const Icon(Icons.clear)),
          horGap(10),
          FloatingActionButton(
              onPressed: () async {
                uImage = await _ss.capture();
                String base64String = base64Encode(uImage!);

                Prefs.getToken().then((token) {
                  Prefs.getPrefs('loginId').then((loginId) {
                    _apiServices.post(
                        context: context,
                        endpoint: 'upload_file.php',
                        body: {
                          "mode": "mobile",
                          "submit_bank": "Submit",
                          "fem_user_login_id": loginId,
                          "access_token": token,
                          "signature": base64String,
                          "type": "user",
                        }).then((value) {
                      if (value['return'] == 'success') {
                        Nav.push(context, const TabScreen());
                      } else {
                        dialog(context, value['message'], () {
                          Nav.pop(context);
                        });
                      }
                    });
                  });
                });
              },
              backgroundColor: primaryColor,
              child: const Icon(Icons.upload)),
        ],
      ),
    );
  }

  Widget _buildColorChose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        height: isSelected ? 47 : 40,
        width: isSelected ? 47 : 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<dynamic> drawingPoints;

  _DrawingPainter(this.drawingPoints);

  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        canvas.drawLine(drawingPoints[i].offset, drawingPoints[i + 1].offset,
            drawingPoints[i].paint);
      } else if (drawingPoints[i] != null && drawingPoints[i + 1] == null) {
        offsetsList.clear();
        offsetsList.add(drawingPoints[i].offset);

        canvas.drawPoints(
            PointMode.points, offsetsList, drawingPoints[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}
