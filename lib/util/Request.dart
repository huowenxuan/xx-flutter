import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';

class Request {
//  static get(url) async {
//    var httpClient = new HttpClient();
//    try {
//      var request = await httpClient.getUrl(Uri.parse(url));
//      var response = await request.close();
//      if (response.statusCode == HttpStatus.ok) {
//        var json = await response.transform(utf8.decoder).join();
//        var data = jsonDecode(json);
//        return data;
//      } else {
//      }
//    } catch (exception) {
//    }
//  }
//
//  static post(url) async {
//    var httpClient = new HttpClient();
//    try {
//      var request = await httpClient.postUrl(Uri.parse(url));
//      var response = await request.close();
//      if (response.statusCode == HttpStatus.ok) {
//        var json = await response.transform(utf8.decoder).join();
//        var data = jsonDecode(json);
//        return data;
//      } else {
//      }
//    } catch (exception) {
//    }
//  }

  static get(url) async {
    try {
      Response response = await Dio().get(url);
      return response.data;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static post(url, data) async {
    try {
      Response response = await Dio().post(url, data: data);
      return response.data;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static put(url, data) async {
    try {
      Response response = await Dio().put(url, data: data);
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
