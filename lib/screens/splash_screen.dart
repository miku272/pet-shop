import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // child: Icon(
        //   Icons.pets,
        //   size: 200,
        //   color: boxShadowColor,
        // ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.pets,
              size: 100,
              color: boxShadowColor,
            ),
            const SizedBox(width: 10),
            Text(
              'Paw Pals',
              textAlign: TextAlign.center,
              style: GoogleFonts.acme().copyWith(
                fontSize: 50,
                letterSpacing: 1.5,
                color: grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
