import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medtagapp/screens/signin_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  String? profileImageUrl;
  String? username;
  final TextEditingController _usernameController = TextEditingController();
  bool _isEditingUsername = true; // boolean değişkeni ekliyoruz

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadUsername();
  }

  Future<void> _loadProfileImage() async {
    if (user == null) return; // Kullanıcı kontrolü
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child('${user!.uid}.jpg');
    try {
      final url = await ref.getDownloadURL();
      setState(() {
        profileImageUrl = url;
      });
    } catch (e) {
      print('Profile resmi bulunamadı: $e');
    }
  }

  Future<void> _loadUsername() async {
    if (user == null) return; // Kullanıcı kontrolü
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      setState(() {
        username = userDoc.get('username');
        _usernameController.text = username ?? '';
      });
    } catch (e) {
      print('Kullanıcı adı yüklenemedi: $e');
    }
  }

  Future<void> _saveUsername() async {
    if (user == null) return; // Kullanıcı kontrolü
    try {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'username': _usernameController.text,
      });
      setState(() {
        username = _usernameController.text;
        _isEditingUsername = false; // Kaydedildikten sonra TextField'ı gizle
      });
    } catch (e) {
      print('Kullanıcı adı kaydedilemedi: $e');
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && user != null) {
      // Kullanıcı kontrolü
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user!.uid}.jpg');
      try {
        await ref.putFile(File(pickedFile.path));
        _loadProfileImage();
      } catch (e) {
        print('Profil resmi yüklenemedi: $e');
      }
    }
  }

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
            CircleAvatar(
              radius: 50,
              backgroundImage: profileImageUrl != null
                  ? NetworkImage(profileImageUrl!)
                  : null,
              child: profileImageUrl == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _pickAndUploadImage,
              child: const Text(
                'Profil Resmi Değiştir',
                style: TextStyle(
                  fontFamily: "Brand-Regular",
                  color: Color(0xFF67b8de),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isEditingUsername) // TextField'ın görünürlüğü
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  labelStyle: TextStyle(
                    fontFamily: "Brand-Regular",
                    color: Color(0xFF67b8de),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            if (_isEditingUsername) const SizedBox(height: 20),
            if (_isEditingUsername)
              ElevatedButton(
                onPressed: _saveUsername,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF67b8de),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Kullanıcı Adını Kaydet',
                  style: TextStyle(
                    fontFamily: "Brand-Regular",
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              username ?? 'Kullanıcı Adı Bulunamadı',
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
                'Kullanıcı Adını Güncelle',
                style: TextStyle(
                  fontFamily: "Brand-Regular",
                ),
              ),
              leading: const Icon(Icons.edit_outlined),
              onTap: () {
                setState(() {
                  _isEditingUsername =
                      true; // Kullanıcı adını güncelleme moduna geç
                });
              },
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
