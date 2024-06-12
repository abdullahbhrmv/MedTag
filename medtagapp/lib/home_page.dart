import 'package:flutter/material.dart';
import 'package:medtagapp/screens/drug_search_page.dart';
import 'package:medtagapp/screens/profile_page.dart';
import 'package:medtagapp/screens/reminder_page.dart';
import 'package:medtagapp/screens/qr_scan_page.dart'; // QR tarama sayfasını ekledik
import 'package:medtagapp/screens/health_resources_page.dart'; // Sağlık Kaynakları sayfasını ekledik

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const DrugSearchPage(),
    const ReminderPage(),
    const QRScanPage(), // QR tarama sayfasını ekledik
    const HealthResourcesPage(), // Sağlık Kaynakları sayfasını ekledik
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
          color: Color(0xFFd98555),
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
                icon: Icon(Icons.qr_code_scanner), // QR tarama ikonu
                label: 'QR Tarayıcı', // QR tarama başlığı
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.healing), // Sağlık Kaynakları ikonu
                label: 'MT Bot', // Sağlık Kaynakları başlığı
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFF67b8de),
            unselectedItemColor: Colors.grey,
          ),
        ),
      ),
    );
  }
}
