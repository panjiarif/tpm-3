import 'package:flutter/material.dart';
import 'dart:async';

class StopwatchApp extends StatefulWidget {
  final VoidCallback onBack;

  const StopwatchApp({
    super.key,
    required this.onBack,
  });

  @override
  State<StopwatchApp> createState() => _StopwatchAppState();
}

class _StopwatchAppState extends State<StopwatchApp> {
  final _stopwatch = Stopwatch();
  Timer? _timer;
  List<String> laps = [];

  String _formattedTime = '00:00:00.00';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        _updateTime();
      });
    }
  }

  void _stopTimer() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
      setState(() {});
    }
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _stopwatch.reset();
      _formattedTime = '00:00:00.00';
      laps.clear();
    });
  }

  void _recordLap() {
    if (_stopwatch.isRunning) {
      try {
        setState(() {
          String lapTime = _formatTime(_stopwatch.elapsedMilliseconds);
          laps.add(lapTime);
        });
      } catch (e) {
        print('Error when recording lap: $e');
      }
    }
  }

  void _updateTime() {
    if (_stopwatch.isRunning) {
      setState(() {
        _formattedTime = _formatTime(_stopwatch.elapsedMilliseconds);
      });
    }
  }

  String _formatTime(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate() % 100;
    int seconds = (milliseconds / 1000).truncate() % 60;
    int minutes = (milliseconds / (1000 * 60)).truncate() % 60;
    int hours = (milliseconds / (1000 * 60 * 60)).truncate();

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    String hundredsStr = hundreds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr.$hundredsStr';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          widget.onBack();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * (75 / 100),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
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
                        'Stopwatch',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 33, 177, 243),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          _formattedTime,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[800],
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildControlButton(
                            _stopwatch.isRunning ? 'Pause' : 'Start',
                            _stopwatch.isRunning
                                ? Icons.pause
                                : Icons.play_arrow,
                            _stopwatch.isRunning ? _stopTimer : _startTimer,
                            _stopwatch.isRunning ? Colors.orange : Colors.green,
                          ),
                          _buildControlButton(
                            'Lap',
                            Icons.flag,
                            _recordLap,
                            Colors.blue,
                            disabled: !_stopwatch.isRunning,
                          ),
                          _buildControlButton(
                            'Reset',
                            Icons.refresh,
                            _resetTimer,
                            Colors.red,
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      if (laps.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Laps',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: laps.length > 4
                                    ? 200
                                    : (laps.length * 50.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: laps.length,
                                  itemBuilder: (context, index) {
                                    final reverseIndex =
                                        laps.length - 1 - index;
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 10),
                                      margin: const EdgeInsets.only(bottom: 5),
                                      decoration: BoxDecoration(
                                        color: index % 2 == 0
                                            ? Colors.blue[50]
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Lap ${index + 1}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue[800],
                                            ),
                                          ),
                                          Text(
                                            laps[index],
                                            style: TextStyle(
                                              fontFamily: 'monospace',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue[800],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton(
      String label, IconData icon, VoidCallback onPressed, Color color,
      {bool disabled = false}) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: disabled ? Colors.grey[300] : color,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: disabled ? Colors.grey : color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
