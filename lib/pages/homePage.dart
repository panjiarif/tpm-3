import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tpm_tugas3/pages/loginPage.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int _selectedIndex = 0;

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final List<Widget> _pages = [
    MenuPage(),
    GroupPage(),
    HelpPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tugas TPM 3'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.cyan,
        backgroundColor: Colors.transparent,
        key: _bottomNavigationKey,
        items: <Widget>[
          Icon(
            Icons.menu,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.group,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.help,
            size: 30,
            color: Colors.white,
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}

// MenuPage
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              print('Time Converter tapped');
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
              print('Web Recommendation tapped');
            },
          ),
        ),
      ]),
    );
  }
}

// GroupPage
class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Anggota Kelompok',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            children: [
              Card(
                child: InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 50),
                      Text('Arya'),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Anggota 2'),
                            content:
                                Text('Nama: Ahmad Zakaria\nNIM: 123220077\n'),
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
                child: InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 50),
                      Text('Andrea'),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Anggota 1'),
                            content: Text(
                                'Nama: Andrea Alfian Sah Putra\nNIM: 123220078\n'),
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
                child: InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 50),
                      Text('Panji'),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Anggota 3'),
                            content: Text(
                                'Nama: Panji Arif Jafarudin\nNIM: 123220091\n'),
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
                child: InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 50),
                      Text('Mas'),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Anggota 4'),
                            content: Text('Nama: mamammamaa\nNIM: 123456\n'),
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
            ],
          ),
        ))
      ],
    );
  }
}

// HelpPage
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
                            'Masukan angka dalam tahun, lalu tekan tombol convert untuk mengonversi ke satuan waktu jam menit detik.'),
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
                print('Logout button pressed');
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
