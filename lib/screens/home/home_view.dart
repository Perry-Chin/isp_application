import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
import '../../screens/home/home_list.dart';

class CurvedBackgroundPainter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CurvedBackgroundPainter(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}

class _CurvedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // Blue background paint
    final Path bluePath = Path();
    bluePath.moveTo(0, 0);
    bluePath.lineTo(0, size.height * 0.35);
    bluePath.quadraticBezierTo(
      size.width / 2,
      size.height * 0.25,
      size.width,
      size.height * 0.35,
    );
    bluePath.lineTo(size.width, 0);
    bluePath.close();
    paint.color = AppColor.secondaryColor;
    canvas.drawPath(bluePath, paint);

    // Beige background paint
    paint.color = const Color(0xFFF3E9E9);
    canvas.drawRect(
      Rect.fromLTRB(0, size.height * 0.35, size.width, size.height),
      paint,
    );

    // Filling the gap
    final Path beigePath = Path();
    beigePath.moveTo(0, size.height * 0.35);
    beigePath.quadraticBezierTo(
      size.width / 2,
      size.height * 0.25,
      size.width,
      size.height * 0.35,
    );
    beigePath.lineTo(size.width, size.height);
    beigePath.lineTo(0, size.height);
    beigePath.close();
    canvas.drawPath(beigePath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedService = '';
  String selectedServicePronun = '';
  String desc = '';
  String definition = '';
  final TextEditingController _searchController = TextEditingController();

  static const List<String> serviceImages = [
    'assets/images/groomingdog.png',
    'assets/images/walking.png',
    'assets/images/sitting.png',
    'assets/images/training.png',
    'assets/images/add.png',
  ];

  void _onServiceImagePressed(int index) {
    setState(() {
      switch (index) {
        case 0:
          selectedService = 'Grooming';
          selectedServicePronun = '/ˈɡruːmɪŋ/';
          desc = 'noun';
          definition = 'hygienic care for your precious furfriend';
          break;
        case 1:
          selectedService = 'Walking';
          selectedServicePronun = '/wɔːk/';
          desc = 'verb';
          definition =
              "a tail-wagging exploration through your furfriend's neighbourhood";
          break;
        case 2:
          selectedService = 'Sitting';
          selectedServicePronun = '/ˈsɪtɪŋ/';
          desc = 'noun';
          definition = 'temporary care and companionship for your furry friend';
          break;
        case 3:
          selectedService = 'Training';
          selectedServicePronun = '/ˈtreɪnɪŋ/';
          desc = 'noun';
          definition =
              'the fine art of turning chaos into harmony, one pawshake at a time.';
          break;
        case 4:
          selectedService = 'add';
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
          CurvedBackgroundPainter(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 35),
                  const Text(
                    "FurFriends",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 33,
                      fontFamily: 'Silence Rocken',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for a service',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    // onChanged:
                  ),
                  const SizedBox(height: 80),
                  const Text(
                    "Choose",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Quicksand",
                      fontSize: 30,
                    ),
                  ),
                  const Text(
                    "your service!",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Quicksand",
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      serviceImages.length,
                      (index) => GestureDetector(
                        onTap: () => _onServiceImagePressed(index),
                        child: Image.asset(
                          serviceImages[index],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (selectedService.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                selectedService,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Safety",
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                selectedServicePronun,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Doulos SIL",
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            desc,
                            style: const TextStyle(
                              fontFamily: 'Times New Roman',
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            definition,
                            style: const TextStyle(
                              fontFamily: 'Times New Roman',
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: HomeList(selectedService: selectedService),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
