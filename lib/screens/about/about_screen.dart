import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: Stack(
        children: [
          // 🔻 Watermark anchored to bottom-right
          Positioned(
            bottom: -100,
            right: -100,
            child: Opacity(
              opacity: 0.06,
              child: Image.asset(
                'assets/logo.png',
                width: 350,
                height: 350,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔼 Actual content fills whole screen
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Fuel Tracker",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2BB6A3),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Fuel Tracker is a mobile app designed to manage generator fuel usage efficiently.\n\n"
                  "Track your fuel logs, runtime logs, and generate insightful reports to help with energy optimization and cost tracking.",
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                const SizedBox(height: 30),
                Text(
                  "Developed by",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Rizmiya NAPF\nMSc AI, NIBM,URFU",
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                const Spacer(), // pushes copyright to bottom
                Center(
                  child: Text(
                    "© 2025 Fuel Tracker",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[500],
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
