import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_navkit/flutter_animated_navkit.dart';
import 'package:flutter_animated_navkit/model/bottom_nav_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animated NavKit Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: 5,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.notifications),
        title: Text('Notification ${index + 1}'),
      ),
    ),
    ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: 5,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.person),
        title: Text('Profile Info ${index + 1}'),
      ),
    ),
    ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: 5,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.person),
        title: Text('Profile Info ${index + 1}'),
      ),
    ),
    ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: 5,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.person),
        title: Text('Profile Info ${index + 1}'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(bottom: false, child: _pages[_currentIndex]),
      bottomNavigationBar: AnimatedBottomNavkit(
        menuExpandDuration: Duration(milliseconds: 500),
        middleHexagonIconSize: 25,
        middleHexagonElevation: 15,
        expandedMenuIconSpacing: 25,
        expandedMenuIcons: [
          MenuIconItem(
            onTap: () {},
            widget: Icon(
              CupertinoIcons.camera,
              color: Colors.white,
              size: 25,
            ),
          ),
          MenuIconItem(
            onTap: () {},
            widget: Icon(
              CupertinoIcons.mic,
              color: Colors.white,
              size: 25,
            ),
          ),
          MenuIconItem(
            onTap: () {},
            widget: Icon(
              CupertinoIcons.play,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
        items: [
          BottomNavItem(
            icon: CupertinoIcons.home,
          ),
          BottomNavItem(
            icon: CupertinoIcons.search,
          ),
          BottomNavItem(
            icon: CupertinoIcons.person,
          ),
          BottomNavItem(
            icon: CupertinoIcons.settings,
          ),
        ],
        middleHexagonSize: 50,
        showMiddleNotch: true,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
