import 'package:flutter/material.dart';
import 'package:shield_command_center/constants/app_style.dart';
import 'package:shield_command_center/screens/api_screen.dart';
import 'package:shield_command_center/screens/missions_screen.dart';
import 'package:shield_command_center/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [ProfileScreen(), MissionsScreen(), ApiScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: _buildShieldBottomBar(),
    );
  }

  Widget _buildShieldBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.blueAccent, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: AppStyles.primaryColor,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'PROFILE'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'MISSIONS',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.storage), label: 'EXTRA'),
        ],
      ),
    );
  }
}
