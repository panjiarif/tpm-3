import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Konversiwaktu extends StatefulWidget {
  final VoidCallback onBack;

  const Konversiwaktu({
    super.key,
    required this.onBack,
  });

  @override
  State<Konversiwaktu> createState() => _KonversiwaktuState();
}

class _KonversiwaktuState extends State<Konversiwaktu> {
  final jamController = TextEditingController();
  final menitController = TextEditingController();
  final detikController = TextEditingController();
  final tahunController = TextEditingController();

  double? menitResult;
  double? detikResult;
  double? jamResult;
  double? tahunResult;

  double jamT = 0;
  double menitT = 0;
  double detikT = 0;

  double sisaJam = 0;
  double sisaMenit = 0;

  FocusNode tahunFocusNode = FocusNode();
  FocusNode jamFocusNode = FocusNode();
  FocusNode menitFocusNode = FocusNode();
  FocusNode detikFocusNode = FocusNode();
  String mode = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tahunFocusNode.addListener(() {
      if (tahunFocusNode.hasFocus) {
        setState(() {
          mode = "tahun";
          print("Mode berubah jadi: $mode");
        });
      }
    });
    jamFocusNode.addListener(() {
      if (jamFocusNode.hasFocus) {
        setState(() {
          mode = "jam";
          print("Mode berubah jadi: $mode");
        });
      }
    });
    menitFocusNode.addListener(() {
      if (menitFocusNode.hasFocus) {
        setState(() {
          mode = "menit";
          print("Mode berubah jadi: $mode");
        });
      }
    });
    detikFocusNode.addListener(() {
      if (detikFocusNode.hasFocus) {
        setState(() {
          mode = "detik";
          print("Mode berubah jadi: $mode");
        });
      }
    });
  }

  void ShowDialogError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Nilai terlalu besar"),
        content: Text("Angka harus dibawah 1 kuintiliun (10 pangkat 18 )"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void convertTahun() {
    setState(() {
      final tahun = double.tryParse(
              tahunController.text.replaceAll(".", "").replaceAll(",", ".")) ??
          0;
      print("tahun" + tahun.toString());

      if (tahun > 999_999_999_999_999_999 || tahun < -999_999_999_999_999_999) {
        ShowDialogError();
        return;
      }

      jamResult = tahun * 365 * 24;
      menitResult = jamResult! * 60;
      detikResult = jamResult! * 3600;

      jamT = tahun * 365 * 24; // misal 2324,4
      sisaJam = jamT % 1;
      print("Jam e : $jamT");
      print("sisa jam : $sisaJam");

      menitT = sisaJam * 60;
      sisaMenit = menitT % 1;
      print("menit e : $menitT");
      print("sisa menit : $sisaMenit");

      detikT = sisaMenit * 60;
      print("detik e : $detikT");
      // detikT = tahun ~/ (365 * 24 * 3600);

      print("menitR : " + menitResult.toString());
      print("detikR : " + detikResult.toString());
    });
  }

  void convertJam() {
    setState(() {
      final jam = double.tryParse(
              jamController.text.replaceAll(".", "").replaceAll(",", ".")) ??
          0;
      print("Jam" + jam.toString());

      if (jam > 999_999_999_999_999_999 || jam < -999_999_999_999_999_999) {
        ShowDialogError();
        return;
      }
      tahunResult = jam / (365 * 24);
      menitResult = jam * 60;
      detikResult = jam * 3600;

      jamT = jam;
      sisaJam = jam % 1;
      menitT = sisaJam * 60;
      sisaMenit = menitT % 1;
      detikT = sisaMenit * 60;

      print("Jam e : $jamT");
      print("sisa jam : $sisaJam");
      print("menit e : $menitT");
      print("sisa menit : $sisaMenit");
      print("detik e : $detikT");

      print("menitR : " + menitResult.toString());
      print("detikR : " + detikResult.toString());
    });
  }

  void convertMenit() {
    setState(() {
      final menit = double.tryParse(
              menitController.text.replaceAll(".", "").replaceAll(",", ".")) ??
          0;
      print("menit" + menit.toString());

      if (menit > 999_999_999_999_999_999 || menit < -999_999_999_999_999_999) {
        ShowDialogError();
        return;
      }

      tahunResult = menit / (365 * 24 * 60);
      detikResult = menit * 60;
      jamResult = menit / 60;

      jamT = menit / 60;
      menitT = menit % 60;
      sisaMenit = menitT % 1;
      detikT = sisaMenit * 60;

      print("Jam e : $jamT");
      print("sisa jam : $sisaJam");
      print("menit e : $menitT");
      print("sisa menit : $sisaMenit");
      print("detik e : $detikT");

      print("jamR : " + jamResult.toString());
      print("detikR : " + detikResult.toString());
    });
  }

  void convertDetik() {
    setState(() {
      final detik = double.tryParse(
              detikController.text.replaceAll(".", "").replaceAll(",", ".")) ??
          0;

      if (detik > 999_999_999_999_999_999 || detik < -999_999_999_999_999_999) {
        ShowDialogError();
        return;
      }

      menitResult = detik / 60;
      jamResult = detik / 3600;
      tahunResult = detik / (365 * 24 * 3600);

      jamT = detik / 3600;
      detikT = detik % 60;
      menitT = ((detik % 3600) - detikT) / 60;

      print("Jam e : $jamT");
      print("sisa jam : $sisaJam");
      print("menit e : $menitT");
      print("sisa menit : $sisaMenit");
      print("detik e : $detikT");
    });
  }

  void reset() {
    setState(() {
      jamController.clear();
      menitController.clear();
      detikController.clear();
      tahunController.clear();
      menitResult = null;
      detikResult = null;
      jamResult = null;
      tahunResult = null;
      mode = "";
    });
  }

  Widget buildTextField(
    String label,
    TextEditingController controller,
    double? nilai,
    VoidCallback onChanged,
    bool isEnabled,
    FocusNode focusNode,
    String satuan,
  ) {
    if (nilai != null) {
      // print("jangkrik");
      if (nilai.toString() != controller.text) {
        controller.text = "$nilai $satuan";
      }
    }

    return TextField(
      controller: controller,
      enabled: isEnabled,
      focusNode: focusNode,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[-0-9.,]')),
      ],
      onChanged: (_) {
        print("ngecek");
        final val = double.tryParse(
                controller.text.replaceAll(".", "").replaceAll(",", ".")) ??
            0;
        if (val > 999_999_999_999_999_999 || val < -999_999_999_999_999_999) {
          ShowDialogError();
          controller.text = (val ~/ 10).toString();
          return;
        }
        onChanged();
      },
      decoration: InputDecoration(
        labelText: label,
        // border: InputBorder
        //     .none, // default (tidak digunakan saat ini karena di-overwrite)
        border: OutlineInputBorder(
          // outline saat fokus
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          // outline saat fokus
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        scrollDirection: Axis.vertical,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * (75 / 100),
          ),
          child: Center(
            child: IntrinsicHeight(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Konversi Waktu',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 33, 177, 243),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      mode == ""
                          ? 'Silakan masukan nilai waktu yang ingin dikonversi!'
                          : "Anda sekarang di mode '$mode', klik refresh dahulu untuk mengganti mode!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(height: 15),
                    buildTextField(
                      "Tahun",
                      tahunController,
                      tahunResult,
                      convertTahun,
                      mode == "" || mode == "tahun" ? true : false,
                      tahunFocusNode,
                      "tahun",
                    ),
                    const SizedBox(height: 15),
                    Text(
                      jamT != 0.0
                          ? " ${jamT.toInt()} jam ${menitT.toInt()} menit ${detikT.toInt()} detik."
                          : "Hasil konversi tahun.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(height: 15),
                    buildTextField(
                      "Jam",
                      jamController,
                      jamResult,
                      convertJam,
                      mode == "" || mode == "jam" ? true : false,
                      jamFocusNode,
                      "jam",
                    ),
                    const SizedBox(height: 12),
                    buildTextField(
                      "Menit",
                      menitController,
                      menitResult,
                      convertMenit,
                      mode == "" || mode == "menit" ? true : false,
                      menitFocusNode,
                      "menit",
                    ),
                    const SizedBox(height: 12),
                    buildTextField(
                      "Detik",
                      detikController,
                      detikResult,
                      convertDetik,
                      mode == "" || mode == "detik" ? true : false,
                      detikFocusNode,
                      "detik",
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: reset,
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Refresh!",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 73, 155, 238),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
