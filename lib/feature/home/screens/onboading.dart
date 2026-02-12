import 'package:flutter/material.dart';
import 'package:tasky_app/feature/auth/screen/login_screem.dart';
import 'package:tasky_app/feature/home/data/onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final data = OnboardingData.onboardingData[currentIndex];
    int len = OnboardingData.onboardingData.length;

    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 150,),
            Column(
              children: [
                Image.asset(data["image"]!, fit: BoxFit.contain),
                SizedBox(height: 50),
                Text(
                  data["title"]!,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff404147),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  data["description"]!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffB0AEB8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (currentIndex <
                          len - 1) {
                        currentIndex++;
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  LoginScreen(),
                          ),
                        );
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Color(0xff5F33E1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(currentIndex == len - 1 ? "Get Started": "Next",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 64,),
          ],
        ),
      ),
    );
  }
}
