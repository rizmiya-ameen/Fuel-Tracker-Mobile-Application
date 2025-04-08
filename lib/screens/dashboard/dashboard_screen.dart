import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'runtime_tab.dart';
import 'fuel_tab.dart';
import '../generators/generator_list_screen.dart';
import '../report/report_screen.dart';
import '../about/about_screen.dart'; // ✅ Add this

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    _MainTabsScreen(), // Runtime & Fuel tabs
    GeneratorListScreen(), // Generator list
    ReportScreen(), // Final report screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: "Generators",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Report"),
        ],
      ),
    );
  }
}

class _MainTabsScreen extends StatefulWidget {
  const _MainTabsScreen();

  @override
  State<_MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<_MainTabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6FF),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 32, width: 32),
            const SizedBox(width: 8),
            Text(
              'Fuel Tracker',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black87,
              indicator: BoxDecoration(
                color: const Color(0xFFB2A4FF),
                borderRadius: BorderRadius.circular(25),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [Tab(text: 'Runtime'), Tab(text: 'Fuel')],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [RuntimeTab(), FuelTab()],
            ),
          ),
        ],
      ),
    );
  }
}
