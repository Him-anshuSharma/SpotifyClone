import 'package:flutter/foundation.dart';
import 'package:spotify_clone/utils/constants.dart';
import 'package:dio/dio.dart';
import 'dart:convert' show Codec, base64, utf8;

class SpotifyApi{
  getToken() async{
    Dio dio = Dio();
    var authString = "${Constants.clientId}:${Constants.clientSecret}";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String authBase64 = stringToBase64.encode(authString);
    var url = Constants.baseUrl + Constants.tokenEndpoint;
    var headers = {
      "Authorization":"Basic $authBase64",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    var data = {"grant_type": "client_credentials"};
    try{
      Response result = await dio.post(
          url,
          data: data,
          options: Options(
              headers: headers
          )
      );
      if (kDebugMode) {
        print("${result.data}");
      }
      Map map = result.data;
      return map['access_token'];
    }catch(e){
      return "Something Bad happened";
    }
  }
}