import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isp_application/screens/home/filteredallservices.dart';
import 'package:isp_application/screens/home/limitedservices.dart';
import '../../common/values/values.dart';
import 'home_controller.dart';

class SearchBox extends StatelessWidget {
  final VoidCallback onTap;
  final bool showSuffixIcon;

  const SearchBox({
    required this.onTap,
    required this.showSuffixIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 1,
              offset: Offset(1.6, 1.6),
            ),
          ],
          color: AppColor.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColor.secondaryColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.search,
                color: AppColor.secondaryColor,
              ),
            ),
            Expanded(
              child: Text(
                'Search',
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeController controller;

  // Add titles for the services
  static const List<String> serviceImages = [
    'assets/images/groomingdog.png',
    'assets/images/walking.png',
    'assets/images/sitting.png',
    'assets/images/training.png',
  ];

  static const List<String> serviceTitles = [
    'Grooming',
    'Walking',
    'Sitting',
    'Training',
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.put(HomeController());
  }

  void _onServiceImagePressed(int index) {
    String selectedService;
    String selectedServicePronoun;
    String desc;
    String definition;

    switch (index) {
      case 0:
        selectedService = 'Grooming';
        selectedServicePronoun = '/ˈɡruːmɪŋ/';
        desc = 'noun';
        definition = 'hygienic care for your precious furfriend';
        break;
      case 1:
        selectedService = 'Walking';
        selectedServicePronoun = '/wɔːk/';
        desc = 'verb';
        definition =
            "a tail-wagging exploration through your furfriend's neighbourhood";
        break;
      case 2:
        selectedService = 'Sitting';
        selectedServicePronoun = '/ˈsɪtɪŋ/';
        desc = 'noun';
        definition = 'temporary care and companionship for your furry friend';
        break;
      case 3:
        selectedService = 'Training';
        selectedServicePronoun = '/ˈtreɪnɪŋ/';
        desc = 'noun';
        definition =
            'the fine art of turning chaos into harmony, one pawshake at a time.';
        break;
      default:
        return;
    }

    Get.to(() => FilteredAllServicesPage(
        selectedService: selectedService,
        selectedServicePronoun: selectedServicePronoun,
        desc: desc,
        definition: definition,
    ));
  }

  void _onSearchSubmitted() {
    Get.toNamed('/allServices');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: CustomPaint(
              painter: _CurvedBackgroundPainter(),
              size: Size.infinite,
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
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
                        SearchBox(
                          onTap: _onSearchSubmitted,
                          showSuffixIcon: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(
                        MediaQuery.of(context).size.width * 0.6,
                        50.0,
                      ),
                    ),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 40),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "Choose \nyour service!",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Quicksand",
                                fontSize: 30,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                serviceImages.length,
                                (index) => GestureDetector(
                                  onTap: () => _onServiceImagePressed(index),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        serviceImages[index],
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(height: 5), // Space between image and title
                                      Text(
                                        serviceTitles[index],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                          fontFamily: "Open Sans"
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // No fixed height here
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5, // Or any other height you prefer
                            child: const limitedservicespage(), // Use the new LimitedServicesPage widget
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
    paint.color = AppColor.secondaryColor;
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
