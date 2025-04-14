// MenuPage
import 'package:flutter/material.dart';
import 'package:tpm_tugas3/pages/subPages/konversiWaktu.dart';
// import 'package:tpm_tugas3/pages/subPages/rekomendasiWeb.dart';

class MenuPage extends StatefulWidget {
  MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String paging = "main";

  @override
  Widget build(BuildContext context) {
    switch (paging) {
      case "konversiWaktu":
        return Konversiwaktu(onBack: () => { 
          setState(() {
          paging = "";
        })});
      case "rekomendasiWeb": 
        return Konversiwaktu(onBack: () => {
          setState(() {
            paging = "";
          })});
      case "":
      default:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.timer),
                title: Text('Stopwatch'),
                subtitle: Text('Aplikasi stopwatch, mencatat waktu'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  print('Stopwatch tapped');
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.numbers),
                title: Text('Number Type'),
                subtitle: Text('Aplikasi menampilkan jenis bilangan'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  print('Number Type tapped');
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.track_changes),
                title: Text('LBS Tracking'),
                subtitle: Text('Aplikasi tracking lokasi'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  print('LBS Tracking tapped');
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.date_range),
                title: Text('Time Converter'),
                subtitle: Text('Aplikasi konversi waktu'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  setState(() {
                    paging = 'konversiWaktu';
                  });
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.menu),
                title: Text('Web Recommendation'),
                subtitle: Text('Aplikasi rekomendasi situs web'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  setState(() {
                    paging = 'rekomendasiWeb';
                  });
                },
              ),
            ),
          ]),
        );
    }
  }
}
