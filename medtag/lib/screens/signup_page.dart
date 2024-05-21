import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:medtag/home_page.dart';
import 'signin_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  DateTime? selectedDate;

  Future<void> signUp(
    BuildContext context,
    String name,
    String email,
    DateTime birthDate,
    String password,
    String confirmPassword,
  ) async {
    try {
      // ProgressDialog'u göster
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Şifre ve şifre onayı kontrolü
      if (password != confirmPassword) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Hata'),
              content: const Text('Şifreler uyuşmuyor.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Tamam'),
                ),
              ],
            );
          },
        );
        return;
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Firestore'a kullanıcı bilgilerini kaydet
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'birthDate': birthDate,
      });

      // ProgressDialog'u kapat
      Navigator.pop(context);

      // Kullanıcı kaydı başarılıysa ana ekranı aç
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // ProgressDialog'u kapat
      Navigator.pop(context);

      if (e.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Hata'),
              content: const Text('Bu e-posta adresi zaten kullanılıyor.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Tamam'),
                ),
              ],
            );
          },
        );
      } else {
        print('Error while signing up: ${e.code}');
      }
    } catch (e) {
      print('Error while signing up: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 35),
              const Image(
                image: AssetImage("assets/images/medtaglogo.png"),
                width: 400,
                height: 250,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Kayıt Ol",
                style: TextStyle(fontFamily: "Brand Bold", fontSize: 24),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Ad Soyad",
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: "Brand-Regular",
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: "Brand-Regular",
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(selectedDate != null
                          ? selectedDate!.toString().split(' ')[0]
                          : 'Doğum Tarihi Seç'),
                      onTap: () async {
                        final selected = await DatePicker.showSimpleDatePicker(
                          context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          dateFormat: "dd-MMMM-yyyy",
                          locale: DateTimePickerLocale.tr,
                          looping: true,
                        );

                        if (selected != null) {
                          // Kullanıcı bir tarih seçtiğinde, seçilen tarihi güncelle
                          setState(() {
                            selectedDate = selected;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Şifre",
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: "Brand-Regular",
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Şifre Onayı",
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: "Brand-Regular",
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF67b8de),
                      ),
                      onPressed: () {
                        signUp(
                          context,
                          nameController.text,
                          emailController.text,
                          selectedDate!,
                          passwordController.text,
                          confirmPasswordController.text,
                        );
                      },
                      child: const Text(
                        'Kayıt Ol',
                        style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SigninPage()),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Zaten bir hesabınız var mı? ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Brand-Regular",
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Giriş yap',
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily: "Brand-Regular",
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
