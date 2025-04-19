// GroupPage
import 'package:flutter/material.dart';
import 'package:tpm_tugas3/components/glassShine.dart';

class GroupPage extends StatelessWidget {
  GroupPage({super.key});

  final List<Map<String, String>> anggota = [
    {
      'nama': 'Ahmad Zakaria',
      'nim': '123220077',
      'gambar': 'assets/zaka.png',
    },
    {
      'nama': 'Andrea Alfian',
      'nim': '123220078',
      'gambar': 'assets/andre.jpg',
    },
    {
      'nama': 'Panji Arif',
      'nim': '123220091',
      'gambar': 'assets/andre.jpg',
    },
    {
      'nama': 'Muhammad Islakha',
      'nim': '123210096',
      'gambar': 'assets/lakha.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Anggota Kelompok',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 33, 177, 243),
            ),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            children: anggota.map((data) {
              return GlassShineEffect(
                child: Card(
                  color: Colors.blue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              data['gambar']!,
                              fit: BoxFit.cover,
                              alignment: Alignment(0, 0.4),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          data['nama']!,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'TP Mobile IF-E',
                              textAlign: TextAlign.center,
                            ),
                            content: Text(
                              'Nama  : ${data['nama']}\nNIM     : ${data['nim']}',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  'OK',
                                  textAlign: TextAlign.end,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        ))
      ],
    );
  }
}
