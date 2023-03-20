import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friday Countdown',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Friday Countdown'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer _timer;
  late DateTime _nextFriday;
  late Duration _timeUntilFriday;

  @override
  void initState() {
    super.initState();
    _calculateNextFriday();
    _startTimer();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void _calculateNextFriday() {
    final now = DateTime.now();
    final nextFriday = now.add(Duration(days: (5 - now.weekday) % 7));
    _nextFriday =
        DateTime(nextFriday.year, nextFriday.month, nextFriday.day, 18);
    _timeUntilFriday = _nextFriday.difference(now);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeUntilFriday = _nextFriday.difference(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _timeUntilFriday.inDays;
    final hours = _timeUntilFriday.inHours % 24;
    final minutes = _timeUntilFriday.inMinutes % 60;
    final seconds = _timeUntilFriday.inSeconds % 60;

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$days',
                style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const Text(
                'days',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}',
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Digital-7',
                  color: Colors.lightBlue,
                ),
              ),
              const Text(
                'until Friday at 6 p.m.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}
