import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';

class Request {
  static String API = 'http://huowenxuan.zicp.vip/';

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

  static delete(url, data) async {
    try {
      Response response = await Dio().delete(url, data: data);
      return response.data;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
