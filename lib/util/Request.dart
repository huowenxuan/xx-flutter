import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';

class Request {
  static String API = 'http://huowenxuan.zicp.vip/';

//  static get(url) async {
//    var httpClient = new HttpClient();
//    try {
//      var request = await httpClient.getUrl(Uri.parse(url));
//      var response = await request.close();
//      if (response.statusCode == HttpStatus.ok) {
//        var json = await response.transform(utf8.decoder).join();
//        var data = jsonDecode(json);
//        return data;
//      } else {}
//    } catch (exception) {
//      throw exception;
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

  static handleError(e) {
    try{
      String msg = jsonDecode(e.response.toString())['error'];
      print(msg);
      throw msg;
    } catch (e) {
      handleError(e);
    }
  }

  static get(url) async {
    try {
      Response response = await Dio().get(url);
      return response.data;
    } catch (e) {
      handleError(e);
    }
  }

  static post(url, data) async {
    try {
      Response response = await Dio().post(url, data: data);
      return response.data;
    } catch (e) {
      handleError(e);
    }
  }

  static put(url, data) async {
    try {
      Response response = await Dio().put(url, data: data);
      return response.data;
    } catch (e) {
      handleError(e);
    }
  }

  static delete(url, data) async {
    try {
      Response response = await Dio().delete(url, data: data);
      return response.data;
    } catch (e) {
      handleError(e);
    }
  }
}
