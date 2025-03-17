import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:audio_session/audio_session.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conscious Timer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Conscious Timer'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isStarted = false;
  _isDarkMode(ctx) {
    return Theme.of(ctx).brightness == Brightness.dark;
  }

  final player = AudioPlayer();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _configureAudioSession();
  }

  Future<void> _configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
  }

  void _handleBell() {
    if (_isStarted) {
      _timer?.cancel();
      player.stop();
    } else {
      player.play(AssetSource('sounds/bell.wav'));
      _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
        player.play(AssetSource('sounds/bell.wav'));
      });
    }
    setState(() {
      _isStarted = !_isStarted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                _isDarkMode(context)
                    ? "assets/images/bg-dark.jpg"
                    : "assets/images/bg-light.jpg",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OverflowBar(
                children: <Widget>[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _isDarkMode(context)
                              ? Colors.lightBlue.shade300
                              : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color:
                              !_isDarkMode(context)
                                  ? Colors.black
                                  : Colors.white,
                          spreadRadius: 5,
                          blurRadius: _isStarted ? 50 : 20,
                        ),
                      ],
                    ),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,

                      onTap: _handleBell,
                      child: Padding(
                        padding: const EdgeInsets.all(60.0),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Image.asset(
                            _isStarted
                                ? "assets/images/bell.png"
                                : "assets/images/bell-2.png",
                            key: ValueKey<bool>(_isStarted),
                            width: 200,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
