// Welcome View

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/values/values.dart';
import 'welcome_index.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SizedBox(
          width: 360.w,
          height: 780.w,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView(
                scrollDirection: Axis.horizontal,
                reverse: false,
                onPageChanged: (index){
                  controller.changePage(index);
                },
                controller: PageController(
                  initialPage: 0,
                  keepPage: false,
                  viewportFraction: 1
                ),
                pageSnapping: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  Container(
                    width: 140.sp,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(AppImage.welcomePage1)
                      )
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(AppImage.welcomePage2)
                      )
                    ),
                  ),
                  Container(
                    width: 200,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(AppImage.welcomePage3)
                      )
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned(
                          bottom: 90,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.handleLogin();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                              foregroundColor: MaterialStateProperty.all(Colors.black),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              )),
                              side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.white)
                              )
                            ),
                            child: const Text("Login"),
                          )                         
                        )
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 70,
                child: DotsIndicator(
                  position: controller.state.index.value.toInt(),
                  dotsCount: 3,
                  reversed: false,
                  mainAxisAlignment: MainAxisAlignment.center,
                  decorator: DotsDecorator(
                    size: const Size.square(9),
                    activeSize: const Size(18, 9),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                    )
                  ),
                )
              )
            ],
          ),
        )
      )
    );
  }
}