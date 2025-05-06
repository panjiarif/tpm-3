import 'package:flutter/material.dart';

class NumberChecker extends StatefulWidget {
  final VoidCallback onBack;

  const NumberChecker({
    super.key,
    required this.onBack,
  });

  @override
  State<NumberChecker> createState() => _NumberCheckerState();
}

class _NumberCheckerState extends State<NumberChecker> {
  final _controller = TextEditingController();
  String _result = '';
  String? _error;

  bool _isPrime(BigInt number) {
    if (number < BigInt.from(2)) return false;
    if (number == BigInt.two) return true;
    if (number.isEven) return false;

    for (BigInt i = BigInt.from(3); i * i <= number; i += BigInt.from(2)) {
      if (number % i == BigInt.zero) return false;
    }
    return true;
  }

  void _checkNumber() {
    setState(() {
      _result = '';
      _error = null;
      String input = _controller.text;

      if (input.isEmpty) {
        _error = 'Input tidak boleh kosong';
        return;
      }

      BigInt? bigIntVal;
      num? numVal;

      try {
        if (input.contains('.') || input.contains(',')) {
          numVal = num.parse(input.replaceAll(',', '.'));
          bigIntVal = BigInt.from(numVal.truncate());
        } else {
          bigIntVal = BigInt.parse(input);
          numVal = bigIntVal.toInt();
        }
      } catch (e) {
        _error = 'Masukkan hanya angka yang valid';
        return;
      }

      List<String> types = [];

      // Desimal
      if (numVal is double && numVal % 1 != 0) {
        types.add('Bilangan Desimal');
      } else {
        // Bukan desimal
        if (bigIntVal! >= BigInt.zero) {
          types.add('Bilangan Bulat Positif');
        } else {
          types.add('Bilangan Bulat Negatif');
        }

        if (bigIntVal >= BigInt.zero) {
          types.add('Bilangan Bulat');
        }

        if (bigIntVal >= BigInt.zero) {
          types.add('Bilangan Cacah');
        }

        if (_isPrime(bigIntVal)) {
          types.add('Bilangan Prima');
        }
      }

      _result = 'Jenis bilangan: ${types.join(', ')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Checker'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Masukkan angka',
                  errorText: _error,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkNumber,
                child: const Text('Cek'),
              ),
              const SizedBox(height: 20),
              Text(_result),
            ],
          ),
        ),
      ),
    );
  }
}
