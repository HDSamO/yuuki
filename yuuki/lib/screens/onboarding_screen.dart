import 'package:flutter/material.dart';
import 'package:yuuki/screens/login_screen.dart';
import 'package:yuuki/models/onboarding_items.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:yuuki/screens/signup_screen.dart';
import 'package:yuuki/widgets/customs/custom_login_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = OnboardingItems();
  final pageController = PageController();

  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: isLastPage ? getStarted() : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Skip Button
            TextButton(
                onPressed: () =>
                    pageController.jumpToPage(controller.items.length - 1),
                child: const Text("Skip", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),)),

            //Indicator
            SmoothPageIndicator(
              controller: pageController,
              count: controller.items.length,
              onDotClicked: (index) =>
                  pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeIn),
              effect: const WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                activeDotColor: Colors.blue,
              ),
            ),

            //Next Button
            TextButton(
                onPressed: () =>
                    pageController.nextPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeIn),
                child: const Text("Next", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),)),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/onboarding/img_background.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: PageView.builder(
            onPageChanged: (index) =>
                setState(() =>
                isLastPage = controller.items.length - 1 == index),
            itemCount: controller.items.length,
            controller: pageController,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(controller.items[index].image),
                  const SizedBox(height: 15),
                  Text(controller.items[index].title,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Jua"
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget getStarted() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomLoginButton(
          onPressed: () async {
            final pres = await SharedPreferences.getInstance();
            pres.setBool("onboarding", true);

            //After we press get started button this onboarding value become true
            // same key
            if (!mounted) return;
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
          text: "I have an account",
          width: double.infinity,
          height: 54,
        ),
        const SizedBox(height: 20,),
        CustomLoginButton(
          onPressed: () async {
            final pres = await SharedPreferences.getInstance();
            pres.setBool("onboarding", true);

            //After we press get started button this onboarding value become true
            // same key
            if (!mounted) return;
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          text: "Get Started",
          width: double.infinity,
          height: 54,
        ),
      ],
    );
  }

}
