import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';

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
      'name': 'Grooming Service',
      'date': 'January 2024 • 5:00 pm',
      'location': 'Illinois',
      'price': '\$100',
      'service_name': 'Grooming',
    },
    {
      'name': 'Walking Service',
      'date': 'January 2024 • 5:00 pm',
      'location': 'Illinois',
      'price': '\$100',
      'service_name': 'Walking',
    },
  ];

  List<Map<String, dynamic>> filteredServiceCards = [];

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

      filteredServiceCards = serviceCards
          .where((card) => card['service_name'] == selectedService)
          .toList();
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
          child: CustomPaint(
            painter: CurvedBackgroundPainter(),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
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
                      onChanged: (value) => _filterServiceList(value),
                    ),
                    const SizedBox(height: 100),
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
                    const SizedBox(height: 20),
                    if (selectedService.isNotEmpty) ...[
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
                      if (filteredServiceCards.isNotEmpty)
                        Container(
                          height: 300, // Set a specific height
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: filteredServiceCards.length,
                            itemBuilder: (context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(15)),
                                        child: Image.asset(
                                          'assets/images/groomingdog.png',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            filteredServiceCards[index]['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            filteredServiceCards[index]['date'],
                                            style: const TextStyle(
                                                color: Colors.grey, fontSize: 12),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on,
                                                  color: Colors.grey, size: 16),
                                              const SizedBox(width: 2),
                                              Text(
                                                  filteredServiceCards[index]
                                                      ['location'],
                                                  style: const TextStyle(
                                                      fontSize: 12)),
                                              const Spacer(),
                                              Text(
                                                filteredServiceCards[index]['price'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _filterServiceList(String value) {
    setState(() {
      filteredServiceCards = serviceCards
          .where((card) =>
              card['service_name'] == selectedService &&
              card['name'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
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
