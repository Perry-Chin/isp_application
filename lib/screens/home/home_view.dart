import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
import '../../common/widgets/searchbox_bar.dart';
import 'home_list.dart';

class CurvedBackgroundPainter extends CustomPainter {
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
        Rect.fromLTRB(0, size.height * 0.35, size.width, size.height), paint);

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

  static const List<Map<String, dynamic>> serviceCards = [
    {
      'name': 'Username',
      'date': 'January 2024 • 5:00 pm',
      'location': 'Illinois',
      'price': '\$100',
    },
    {
      'name': 'Username',
      'date': 'January 2024 • 5:00 pm',
      'location': 'Illinois',
      'price': '\$100',
    },
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
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Positioned.fill(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 40, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 30),
                  SearchBoxBar(
                    controller: _searchController,
                    onChanged: (value) {
                      // Call function to filter service list based on username
                      _filterServiceList(value);
                    },
                    showSuffixIcon: true,
                  ),
                  const SizedBox(height: 180),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
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
                                    padding:
                                        const EdgeInsets.only(right: 14.0),
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
                            SizedBox(
                              height: 150, // Adjust height as needed
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: serviceImages.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () =>
                                        _onServiceImagePressed(index),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
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
                          if (selectedService.isNotEmpty) ...[
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  selectedService,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Safety",
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(width: 20),
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
                            const SizedBox(height: 8),
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
                            SizedBox(
                              height: 470,
                              child: HomeList(
                                selectedService: selectedService,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _filterServiceList(String value) {
    // Implement your logic here to filter the service list
    print('Filtering service list with value: $value');
    // You can update state variables or call methods to update the UI based on the search value
  }
}

void main() {
  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}