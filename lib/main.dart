// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jokes Planet',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: JokePage(
        onToggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

class JokePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  JokePage({required this.onToggleTheme, required this.isDarkMode});

  @override
  _JokePageState createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  final ApiService _apiService = ApiService();
  final FlutterTts _flutterTts = FlutterTts();
  String _joke = 'Click the button below to have fun!';
  bool _loading = false;
  String _error = '';

  void _fetchJoke() async {
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final joke = await _apiService.fetchJoke();
      setState(() {
        _joke = '${joke['setup']} - ${joke['punchline']}';
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch joke. Please try again later.';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _speakJoke() async {
    if (_joke.isNotEmpty) {
      await _flutterTts.speak(_joke);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jokes Planet'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Navigation Bar'),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              title: Text('nothing here for you!!!'),
              onTap: () {
                // Handle item 1 tap
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('what are you here for?'),
              onTap: () {
                // Handle item 2 tap
                Navigator.pop(context);
              },
            ),
            // Add more items as needed
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (_loading)
                      CircularProgressIndicator()
                    else
                      Text(
                        _joke,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    if (_error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          _error,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _fetchJoke,
                      child: Text(_loading ? 'Loading...' : 'Get Joke'),
                    ),
                    SizedBox(height: 20),
                    if (_joke != 'Click the button below to have fun!')
                      ElevatedButton(
                        onPressed: _speakJoke,
                        child: Text('Read Joke Aloud'),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Powered by Udogad',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
