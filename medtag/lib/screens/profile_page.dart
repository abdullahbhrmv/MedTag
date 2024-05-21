import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medtag/screens/signin_page.dart';
import 'package:medtag/screens/drug_search_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SigninPage()),
    );
  }

  Future<void> _showSignOutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Çıkış Yap',
            style: TextStyle(
              fontFamily: "Brand-Regular",
              fontWeight: FontWeight.w100,
              color: Color(0xFF67b8de),
            ),
          ),
          content: const Text(
            'Çıkış yapmak istediğinizden emin misiniz?',
            style: TextStyle(
              fontFamily: "Brand-Regular",
              fontSize: 15,
              color: Color(0xFF67b8de),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'İptal',
                style: TextStyle(
                  fontFamily: "Brand-Regular",
                  color: Color(0xFF67b8de),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _signOut(context);
              },
              child: const Text(
                'Çıkış Yap',
                style: TextStyle(
                  fontFamily: "Brand-Regular",
                  color: Color(0xFF67b8de),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToDrugSearchPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DrugSearchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFfe8f8ff),
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(
            fontFamily: "Brand-regular",
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF67b8de),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(
              radius: 50,
              // Profil resmi buraya eklenebilir
              // backgroundImage: NetworkImage('URL'),
            ),
            const SizedBox(height: 20),
            Text(
              user!.email ?? 'E-posta Bulunamadı',
              style: const TextStyle(
                fontSize: 24,
                fontFamily: "Brand-Regular",
              ),
              textAlign: TextAlign.center,
            ),
            const Divider(
              height: 40,
              thickness: 2,
            ),
            ListTile(
              title: const Text(
                'Çıkış Yap',
                style: TextStyle(
                  fontFamily: "Brand-Regular",
                ),
              ),
              leading: const Icon(Icons.logout_outlined),
              onTap: () {
                _showSignOutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
