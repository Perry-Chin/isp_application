import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isp_application/screens/home/allservices.dart';
import 'package:isp_application/screens/home/searchresults.dart';
import 'package:isp_application/screens/request/request_index.dart';

import '../../common/values/values.dart';
import '../../screens/home/home_list.dart';
import 'home_controller.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final bool showSuffixIcon;

  const SearchBox({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.showSuffixIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Center(
        child: TextField(
          style: GoogleFonts.poppins(),
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            prefixIcon: const Icon(
              Icons.search,
              color: AppColor.secondaryColor,
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: showSuffixIcon
                ? IconButton(
                    icon: const Icon(
                      Icons.filter_list,
                      color: AppColor.secondaryColor,
                    ),
                    onPressed: () {
                      Get.toNamed('/filterHome');
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
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
  String selectedService = '';
  String selectedServicePronun = '';
  String desc = '';
  String definition = '';
  final TextEditingController _searchController = TextEditingController();
  late HomeController controller;

  static const List<String> serviceImages = [
    'assets/images/groomingdog.png',
    'assets/images/walking.png',
    'assets/images/sitting.png',
    'assets/images/training.png',
    'assets/images/add.png',
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.put(HomeController());
  }

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
          Get.to(const RequestPage());
          return;
        default:
          selectedService = '';
      }

      if (controller.state.serviceList.isEmpty) {
        selectedService = '';
        selectedServicePronun = '';
        desc = '';
        definition = 'no services available';
      }
    });
  }

  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      Get.to(() => SearchedService(selectedService: value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const CurvedBackgroundPainter(),
          SafeArea(
            child: Column(
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
                        controller: _searchController,
                        onChanged: (value) {
                          selectedService = value;
                        },
                        onSubmitted: _onSearchSubmitted,
                        showSuffixIcon: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              selectedService,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Safety",
                                                fontSize: 22,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
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
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.to(() => AllServicesPage(selectedService: selectedService));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColor.secondaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: const Text(
                                          "Show All",
                                          style: TextStyle(color: Colors.white),
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
                                  SizedBox(
                                    height: 200,
                                    child: HomeList(
                                      selectedService: selectedService,
                                      maxItems: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CurvedBackgroundPainter extends StatelessWidget {
  const CurvedBackgroundPainter({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CurvedBackgroundPainter(),
      size: Size.infinite,
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