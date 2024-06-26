import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
import 'home_index.dart';

class CurvedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    // Blue background paint
    Path bluePath = Path();
    bluePath.moveTo(0, 0);
    bluePath.lineTo(0, size.height * 0.5);
    bluePath.quadraticBezierTo(
      size.width / 2,
      size.height * 3,
      size.width,
      size.height * 0.5,
    );
    bluePath.lineTo(size.width, 0);
    bluePath.close();
    paint.color = AppColor.secondaryColor;
    canvas.drawPath(bluePath, paint);

    // Beige curved background paint
    Path beigePath = Path();
    beigePath.moveTo(0, size.height * 0.5);
    beigePath.quadraticBezierTo(
      size.width / 2,
      size.height * 0.3,
      size.width,
      size.height * 0.5,
    );
    beigePath.lineTo(size.width, size.height);
    beigePath.lineTo(0, size.height);
    beigePath.close();
    paint.color = const Color(0xFFF3E9E9);
    canvas.drawPath(beigePath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(size.width - 25, 3); // Start point
    path.lineTo(20, 35); // End point

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedService = '';

  // Example list of images (you can replace this with your actual data structure)
  List<String> serviceImages = [
    'assets/images/groomingdog.png',
    'assets/images/walking.png',
    'assets/images/sitting.png',
    'assets/images/training.png',
    'assets/images/add.png',
    // Add more images as needed
  ];

  void _onSearchPressed() {
    // Handle search button press here
    print('Search button pressed');
    // You can navigate to a search screen or show a search dialog here
  }

  void _onServiceImagePressed(int index) {
    // Handle image button press based on the index
    setState(() {
      switch (index) {
        case 0:
          selectedService = 'grooming';
          break;
        case 1:
          selectedService = 'walking';
          break;
        case 2:
          selectedService = 'sitting';
          break;
        case 3:
          selectedService = 'training';
          break;
        case 4:
          selectedService = 'add'; // Change this to handle the last image
          break;
        default:
          selectedService = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Custom painted background
          CustomPaint(
            size: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height,
            ),
            painter: CurvedBackgroundPainter(),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "FurFriends",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 33,
                        fontFamily: 'Silence Rocken',
                      ),
                    ),
                    GestureDetector(
                      onTap: _onSearchPressed,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            right: 5,
                            top: 16,
                            child: CustomPaint(
                              size: const Size(9, 9),
                              painter: DiagonalLinePainter(),
                            ),
                          ),
                          ClipOval(
                            child: Container(
                              width: 38,
                              height: 38,
                              color: Colors.transparent,
                              child: Image.asset(
                                'assets/images/logo_bg.png', // Replace with your image asset path
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Image.asset(
                  'assets/images/polaroids.png', // Replace with your image asset path
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 110),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Choose",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Quicksand",
                        fontSize: 30,
                      ),
                    ),
                    const Text(
                      "your service",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Quicksand",
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // ListView.builder for dynamic list of images
                    if (serviceImages.length <= 5)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                          serviceImages.length,
                          (index) => GestureDetector(
                            onTap: () => _onServiceImagePressed(index),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 14.0),
                              child: Image.asset(
                                serviceImages[index],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (serviceImages.length > 5)
                      Container(
                        height: 150, // Adjust height as needed
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: serviceImages.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _onServiceImagePressed(index),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Image.asset(
                                  serviceImages[index],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (selectedService.isNotEmpty)
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            selectedService,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Safety",
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            "/ˈɡruːmɪŋ/",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Doulos SIL",
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}
