import 'package:flutter/material.dart';
import 'package:medtag/screens/drug_search_page.dart';
import 'package:medtag/screens/profile_page.dart';
import 'package:medtag/screens/reminder_page.dart';
import 'package:medtag/screens/qr_scan_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const DrugSearchPage(),
    const ReminderPage(),
    // const QRScanPage(), // QR kod tarayıcıyı ekleyin
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFd98555), // Arka plan rengini turuncu yapın
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'İlaçlar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.alarm),
                label: 'Hatırlatıcı',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner),
                label: 'QR Tarayıcı', // QR kod tarayıcı
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
            backgroundColor: Colors.transparent,
            selectedItemColor: Color(0xFFd98555),
            unselectedItemColor: Colors.grey,
          ),
        ),
      ),
    );
  }
}
