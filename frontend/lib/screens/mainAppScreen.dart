import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';     // Your HomeScreen file
import 'package:frontend/screens/history_screen.dart';   // Create this dummy or real later

final GlobalKey<HistoryScreenState> historyScreenKey = GlobalKey<HistoryScreenState>();

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body switches between pages based on _currentIndex
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(),
          HistoryScreen(key: historyScreenKey,),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabChange,
        backgroundColor: const Color.fromARGB(255, 0, 17, 77), // Dark blue like splash
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
