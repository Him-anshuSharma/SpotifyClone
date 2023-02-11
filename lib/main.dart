import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/repository/spotifyAPI.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String trackName = '';
  var trackResponse = '';

  @override
  void initState() {
    api.getToken();
    super.initState();
  }


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
                setState(() {});
              },
              child: const Text('generate'),
            ),
            Text(authResponse),
            const SizedBox(height: 100,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Enter track name",
                ),
                onChanged: (String text) {
                  setState(() {
                    trackName = text;
                  });
                },
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    elevation: 2,
                    color: Colors.black,
                    textColor: Colors.white,
                    onPressed: () async {
                      SpotifyApi.trackLinks.clear();
                      if (kDebugMode) {
                        print("TRACK $trackName");
                      }
                      await api.getTrackId(trackName).then((_){
                        setState(() {
                        });
                      });
                    },
                    child: const Text('getTrack'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: MaterialButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    onPressed: () {
                      setState(() {

                      });
                    },
                    child: const Text('Refresh'),
                  ),
                ),
              ],
            ),


            Text(trackResponse),
            Expanded(child: ListView.builder(
              itemCount: SpotifyApi.trackLinks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    launchUrl(Uri.parse(SpotifyApi.trackLinks[index].link));
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(123,2, 34,4),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            SpotifyApi.trackLinks[index].name,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            SpotifyApi.trackLinks[index].artistName,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),)
          ],
        ),
      ),
    );
  }
}
