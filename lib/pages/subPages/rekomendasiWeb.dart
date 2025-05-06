import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tpm_tugas3/components/parseHTMLDescription.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

class RekomendasiWeb extends StatefulWidget {
  final VoidCallback onBack;

  const RekomendasiWeb({super.key, required this.onBack});

  @override
  State<RekomendasiWeb> createState() => _RekomendasiWebState();
}

class _RekomendasiWebState extends State<RekomendasiWeb> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = [
    "Umum",
    "Komik",
    "Streaming",
    "Tech",
    "Berita"
  ];

  String focusCategory = "Umum";
  String modeDuo = ""; // "" : "fav"  untuk rekomendasi dan favorit

  String jsonString = "";
  dynamic dataLocal = Null;

  Map<String, List<dynamic>> dataFavorites =
      {}; // yang akan menampung semua copyan yang dicheklist favorite

  dynamic webResponse = Null;

  List<Map<String, String>> searchResults = [];

  Future<void> performSearch(String query) async {
    final Uri url = Uri.parse(
        "https://api.search.brave.com/res/v1/web/search?q=$query&source=web");

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Accept-Encoding': 'gzip',
          'X-Subscription-Token': 'BSAyeuZnkSjUmb0K6lcqqyW3swBXs7b',
        },
      );

      if (response.statusCode == 200) {
        // Parsing JSON
        final jsonData = jsonDecode(response.body);
        print(
            "Hasil fetch = \n${jsonData['web']["results"]}"); // Lihat isi JSON-nya

        webResponse = jsonData['web']["results"]; // list

        setState(() {
          searchResults = List.generate(10, (i) {
            return {
              "title": "$query Website ${i + 1}",
              "url": "https://example.com/${query.toLowerCase()}${i + 1}"
            };
          });
        });
      } else {
        print("Gagal mengambil data. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetch: $e");
    }
  }

  void searchFromCategory(String category) {
    // _searchController.text = category;

    // performSearch(category);

    setState(() {
      focusCategory = category;
    });
  }

  void addToFavorites(dynamic data, String category) {
    category = category.toLowerCase();

    // DIGANTI HARUSNYA
    setState(() {
      if (dataFavorites[category] == null) {
        dataFavorites[category] = []; // inisialisasi jika belum ada
      }

      dataFavorites[category]!.add(data);
      print("ini data favorites $dataFavorites");
    });
  }

  void removeFromFavorites(dynamic data, String category) {
    category = category.toLowerCase();

    // DIGANTI HARUSNYA
    setState(() {
      if (dataFavorites[category] != null) {
        dataFavorites[category]!
            .removeWhere((item) => item['url'] == data['url']);
        print("Updated favorites for $category: ${dataFavorites[category]}");
      }
    });
  }

  void loadJsonData() async {
    jsonString =
        await rootBundle.loadString('assets/dataListCategoryWebsite.json');
    setState(() {
      dataLocal = jsonDecode(jsonString);

      // Pada saatnya nanti HARUS DIGANTI
      // membentuk struktur kosong dari dataFavorites
      dataLocal.forEach((key, _) => {
            print("\n$key"),
            dataFavorites["$key"] =
                [] // buat array kosong untuk setiap kategori
          });

      print("ini data local $dataLocal");
      print("ini data favorites $dataFavorites");
    });
  }

  @override
  void initState() {
    super.initState();
    loadJsonData(); // hanya dipanggil sekali saat widget pertama kali dibuat

    // Map<String, dynamic> localMap = dataLocal as Map<String, dynamic>;
    // dataFavorites = {};
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          widget
              .onBack(); // Fungsi yang ingin kamu panggil saat tombol back ditekan
        }
      },
      child: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      modeDuo = "";
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        modeDuo == ""
                            ? Icons.web_stories_rounded
                            : Icons.web_stories_outlined,
                        size: modeDuo == "" ? 25 : 20,
                        color: const Color.fromARGB(255, 33, 177, 243),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Rekomendasi Website ',
                        style: TextStyle(
                          fontSize: modeDuo == "" ? 20 : 16,
                          fontWeight:
                              modeDuo == "" ? FontWeight.w500 : FontWeight.w400,
                          color: const Color.fromARGB(255, 33, 177, 243),
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   height: 30,
                //   width: 3,
                //   color: const Color.fromARGB(255, 33, 177, 243),
                // ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      modeDuo = "fav";
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        ' Favorites',
                        style: TextStyle(
                          fontSize: modeDuo == "fav" ? 20 : 16,
                          fontWeight: modeDuo == "fav"
                              ? FontWeight.w500
                              : FontWeight.w400,
                          color: Color.fromARGB(255, 211, 164, 37),
                        ),
                      ),
                      Icon(
                        modeDuo == "fav"
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        size: modeDuo == "fav" ? 25 : 20,
                        color: Color.fromARGB(255, 241, 189, 43),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          modeDuo == ""
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: performSearch,
                    decoration: InputDecoration(
                      labelText: "Cari Website...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () => performSearch(_searchController.text),
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: 10,
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children: categories.map((cat) {
                return ActionChip(
                  padding: EdgeInsets.all(0),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: cat == focusCategory
                      ? modeDuo == ""
                          ? Color.fromARGB(255, 33, 177, 243)
                          : Color.fromARGB(255, 241, 189, 44)
                      : Colors.white,
                  labelStyle: TextStyle(
                    color: cat != focusCategory ? Colors.black87 : Colors.white,
                    fontSize: cat == focusCategory ? 15 : 12,
                    fontWeight: cat == focusCategory
                        ? FontWeight.w500
                        : FontWeight.w400,
                  ),
                  label: Text(cat),
                  onPressed: () => searchFromCategory(cat),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: modeDuo == ""
                      ? const Color.fromARGB(255, 227, 252, 255)
                      : Color.fromARGB(
                          255, 255, 246, 220), // warna gelap mirip ChatGPT
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: modeDuo == ""
                        ? Colors.cyan
                        : Color.fromARGB(255, 241, 189, 44), // Warna outline
                    width: 2, // Ketebalan outline
                  ), // border radius
                ),
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: (focusCategory == "Umum" &&
                            webResponse == Null &&
                            modeDuo == "") ||
                        (focusCategory == "Komik" &&
                            dataLocal["komik"] == null &&
                            modeDuo == "") ||
                        (focusCategory == "Streaming" &&
                            dataLocal["streaming"] == null &&
                            modeDuo == "") ||
                        (focusCategory == "Tech" &&
                            dataLocal["tech"] == null &&
                            modeDuo == "") ||
                        (focusCategory == "Berita" &&
                            dataLocal["berita"] == null &&
                            modeDuo == "")
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20, right: 20),
                          child: Text(
                            focusCategory == "Umum"
                                ? "Belum ada hasil pencarian secara manual!\n\nAnda juga dapat memilih kategory di atas untuk rekomendasi website yang telah kami siapkan!"
                                : "Belum ada website favorite \nuntuk jenis kategory ini!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      )
                    : (focusCategory == "Umum" &&
                                dataFavorites["umum"]!.isEmpty &&
                                modeDuo == "fav") ||
                            (focusCategory == "Komik" &&
                                dataFavorites["komik"]!.isEmpty &&
                                modeDuo == "fav") ||
                            (focusCategory == "Streaming" &&
                                dataFavorites["streaming"]!.isEmpty &&
                                modeDuo == "fav") ||
                            (focusCategory == "Tech" &&
                                dataFavorites["tech"]!.isEmpty &&
                                modeDuo == "fav") ||
                            (focusCategory == "Berita" &&
                                dataFavorites["berita"]!.isEmpty &&
                                modeDuo == "fav")
                        ? Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, left: 20, right: 20),
                              child: Text(
                                focusCategory == "Umum"
                                    ? "Belum ada website favorite \ndari pencarian manual!"
                                    : "Belum ada website favorite \nuntuk jenis kategory ini!",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          )
                        : listBuilderWebsite(),
              ),
            ),
          ),
          SizedBox(
            height: 0,
          )
        ],
      ),
    );
  }


  Future<void> bukahURL(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication, // Ini supaya buka di browser default
    )) {
      throw 'Tidak bisa membuka $url';
    }
  }

  ListView listBuilderWebsite() {
    return ListView.builder(
      itemCount: modeDuo == ""
          ? focusCategory == "Umum"
              ? webResponse.length
              : focusCategory == "Komik"
                  ? dataLocal['komik'].length
                  : focusCategory == "Streaming"
                      ? dataLocal['streaming'].length
                      : focusCategory == "Tech"
                          ? dataLocal['tech'].length
                          : focusCategory == "Berita"
                              ? dataLocal['berita'].length
                              : webResponse.length
          : focusCategory == "Umum"
              ? dataFavorites['umum']!.length
              : focusCategory == "Komik"
                  ? dataFavorites['komik']!.length
                  : focusCategory == "Streaming"
                      ? dataFavorites['streaming']!.length
                      : focusCategory == "Tech"
                          ? dataFavorites['tech']!.length
                          : focusCategory == "Berita"
                              ? dataFavorites['berita']!.length
                              : dataFavorites['umum']!.length,
      itemBuilder: (context, index) {
        final item = modeDuo == ""
            ? focusCategory == "Umum"
                ? webResponse[index]
                : focusCategory == "Komik"
                    ? dataLocal['komik'][index]
                    : focusCategory == "Streaming"
                        ? dataLocal['streaming'][index]
                        : focusCategory == "Tech"
                            ? dataLocal['tech'][index]
                            : focusCategory == "Berita"
                                ? dataLocal['berita'][index]
                                : webResponse[index]
            : focusCategory == "Umum"
                ? dataFavorites["umum"]![index]
                : focusCategory == "Komik"
                    ? dataFavorites['komik']![index]
                    : focusCategory == "Streaming"
                        ? dataFavorites['streaming']![index]
                        : focusCategory == "Tech"
                            ? dataFavorites['tech']![index]
                            : focusCategory == "Berita"
                                ? dataFavorites['berita']![index]
                                : dataFavorites["umum"]![index];
        // menentukan apakah ini sudah termasuk favorites atau belum
        bool isFavorited = false;
        final categoryKey = focusCategory.toLowerCase();

        if (dataFavorites[categoryKey] != null) {
          isFavorited = dataFavorites[categoryKey]!.any((data) =>
              data['url'] == item['url']); // gunakan any untuk cek kecocokan
          if (isFavorited) {
            print("Termasuk favorites");
          }
        }
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(12),
            // border: Border.all(color: Colors.blueAccent, width: 0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              GestureDetector(
                onTap: () {
                  bukahURL(item['profile']['url']);
                },
                child: Row(
                  children: [
                    Image.network(
                      item['profile']['img'] ?? '',
                      width: 32,
                      height: 32,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 32,
                          color: Colors.grey,
                        );
                      },
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * (70 / 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['profile']['name'] ?? '',
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 17, overflow: TextOverflow.ellipsis),
                          ),
                          Text(
                            item['profile']['url'] ?? '',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  bukahURL(item['profile']['url']);
                },
                child: Text(
                  item['title'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    // color: Color.fromARGB(255, 102, 102, 102),
                    color: Color.fromARGB(255, 39, 132, 207),
                  ),
                ),
              ),
              modeDuo == "" ? const SizedBox(height: 6) : SizedBox.shrink(),

              // Description (with bold <strong> parsing)
              modeDuo == ""
                  ? parseHtmlDescription(item['description'] ?? '')
                  : SizedBox.shrink(),

              modeDuo == "" ? const SizedBox(height: 10) : SizedBox.shrink(),

              GridView.builder(
                shrinkWrap: true,
                physics:
                    NeverScrollableScrollPhysics(), // biar scrollnya tetap di parent
                // padding: EdgeInsets.all(8),
                itemCount: modeDuo == "" ? item['cluster']?.length ?? 0 : 0,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 kolom
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2.5, // biar bentuknya lebih memanjang
                ),
                itemBuilder: (context, i) {
                  final clusterItem = item['cluster'][i];
                  return InkWell(
                    onTap: () => {
                      bukahURL(clusterItem['url'])
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // bukaURL(url)
                          },
                          child: Text(
                            clusterItem['title'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color.fromARGB(255, 39, 132, 207),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Expanded(
                          child: Text(
                            clusterItem['description']
                                    .replaceAll("<strong>", "")
                                    .replaceAll("</strong>", "") ??
                                '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(
                height: 10,
              ),
              // URL Row
              GestureDetector(
                onTap: () => {
                  modeDuo == "" && !isFavorited
                      ? addToFavorites(item, categoryKey)
                      : removeFromFavorites(item, categoryKey)
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      !isFavorited && modeDuo == "" ? "Add" : "Remove",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: !isFavorited && modeDuo == ""
                            ? Color.fromARGB(255, 255, 200, 49)
                            : Colors.red[600],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        modeDuo == "" && !isFavorited
                            ? Icons.bookmark_add_outlined
                            : Icons.bookmark_remove_outlined,
                        color: !isFavorited && modeDuo == ""
                            ? const Color.fromARGB(255, 255, 200, 49)
                            : Colors.red[600],
                        size: 25,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
