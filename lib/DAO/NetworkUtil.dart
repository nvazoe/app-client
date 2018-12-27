import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) {
    print(url.toString());
    return http.get(url).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      print(res.toString());
      if (/*statusCode < 200 || statusCode > 400 ||*/ json == null) {
        throw new Exception("Erreur de connexion");
      }
      return _decoder.convert(res);

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    print(body.toString());
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (/*statusCode < 200 || statusCode > 400 ||*/ json == null) {
        return new Future.error(new Exception("Erreur de connexion"));
      }
      print(res.toString());
      return _decoder.convert(res);

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  Future<dynamic> put(String url, {Map headers, body, encoding}) {
    print(body.toString());
    return http
        .put(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (/*statusCode < 200 || statusCode > 400 ||*/ json == null) {
        return new Future.error(new Exception("Erreur de connexion"));
      }
      print(res.toString());
      return _decoder.convert(res);

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  Future<dynamic> delete(String url, {Map headers, body, encoding}) {
    print(body.toString());
    return http
        .delete(url, headers: headers,)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (/*statusCode < 200 || statusCode > 400 ||*/ json == null) {
        return new Future.error(new Exception("Erreur de connexion"));
      }
      print(res.toString());
      return _decoder.convert(res);

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }
}