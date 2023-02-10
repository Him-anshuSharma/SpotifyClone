import 'package:flutter/material.dart';
import 'package:spotify_clone/repository/spotifyAPI.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  SpotifyApi api = SpotifyApi();
  var authResponse = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              elevation: 2,
              color: Colors.black,
              textColor: Colors.white,
              onPressed: () async {
                authResponse = await api.getToken();
                setState(() {
                });
              },
              child: const Text('generate'),
            ),
            Text(authResponse)
          ],
        ),
      ),
    );
  }
}
