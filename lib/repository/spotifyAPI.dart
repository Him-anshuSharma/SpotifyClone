import 'dart:convert' show Codec, base64, utf8;
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:spotify_clone/utils/constants.dart';

class SongDetails{
  String name;
  String artistName;
  String link;
  SongDetails(this.name,this.artistName,this.link);
}

class SpotifyApi {
  static var token = '';

  static List<SongDetails> trackLinks = [];

  Dio dio = Dio();

  getToken() async {
    var authString = "${Constants.clientId}:${Constants.clientSecret}";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String authBase64 = stringToBase64.encode(authString);
    var url = Constants.baseUrl + Constants.tokenEndpoint;
    var headers = {
      "Authorization": "Basic $authBase64",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    var data = {"grant_type": "client_credentials"};
    try {
      Response result =
      await dio.post(url, data: data, options: Options(headers: headers));
      Map map = result.data;
      token = map['access_token'];
      return map['access_token'];
    } catch (e) {
      return "Something Bad happened";
    }
  }

  getAuthHeader(token) {
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }

  Future<String> getTrackId(String trackName) async {
    try {
      Response response = await dio.get(
        "https://api.spotify.com/v1/search",
        queryParameters: {"q": trackName, "type": "track",},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      var tracks = response.data["tracks"]["items"];
      for(var track in tracks){
        getTrack(track["id"]);
      }
      return tracks[0]["id"].toString();
    } catch (e) {
      if (e is DioError && e.response != null) {
        log("Error: ${e.response?.data}");
      } else {
        log("$e");
      }
      return 'null';
    }
  }

  getTrack(String trackId) async {
    dio.options.baseUrl = "https://api.spotify.com/v1/";
    dio.options.headers = {
      "Authorization": "Bearer $token",
    };

// Make a GET request to the Spotify Web API to get the track
    try {
      Response response = await dio.get("tracks/$trackId");

      String trackLink = response.data["external_urls"]["spotify"];
      trackLinks.add(SongDetails(response.data['name'], response.data['artists'][0]['name'], trackLink));
      log("Track link: $trackLink");
    } catch (error) {
      log("$error");
    }
  }
}
