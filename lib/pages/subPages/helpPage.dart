// HelpPage
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tpm_tugas3/pages/loginPage.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Bantuan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'Pilih menu di bawah untuk mendapatkan bantuan lebih lanjut.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Card(
            child: ListTile(
              title: Text('Stopwatch'),
              trailing: Icon(Icons.help),
              onTap: () {
                // Add your about action here
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Stopwatch'),
                        content: Text(
                            'Masukan angka dalam detik, lalu tekan tombol start untuk memulai stopwatch.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Number Type'),
              trailing: Icon(Icons.help),
              onTap: () {
                // Add your about action here
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Number Type'),
                        content: Text(
                            'Masukan angka dalam bilangan bulat, lalu tekan tombol check untuk memeriksa jenis bilangan.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('LBS Traking'),
              trailing: Icon(Icons.help),
              onTap: () {
                // Add your about action here
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('LBS Traking'),
                        content: Text(
                            'Aktifkan GPS pada perangkat Anda, lalu tekan tombol start untuk memulai pelacakan lokasi.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Time Converter'),
              trailing: Icon(Icons.help),
              onTap: () {
                // Add your about action here
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Time Converter'),
                        content: Text(
                          'Di sini ada 3 buah form yang masing-masing memiliki kegunaannya tersendiri. Masukan nilai waktu yang ingin dikonversi sesuai dengan form yang tersedia. Nantinya hasil konversi akan langsung menghasilkan hasil konversi di form yang lain. \n\nJika ingin lanjut untuk mengkonversi jenis waktu yang lain, anda perlu menekan tombol refresh untuk bisa mulai mengganti mode konversi!',
                          textAlign: TextAlign.justify,
                        ),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Web Recommendation'),
              trailing: Icon(Icons.help),
              onTap: () {
                // Add your about action here
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Web Recommendation'),
                        content: Text(
                            'Pilih kategori yang diinginkan, lalu tekan tombol recommend untuk mendapatkan rekomendasi situs web.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
          SizedBox(height: 20),
          Text('Login sebagai ${FirebaseAuth.instance.currentUser?.email}'),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
