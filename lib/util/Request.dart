import 'dart:io';
import 'dart:convert';

class Request {
  static get(url) async {
    var httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        return data;
      } else {
      }
    } catch (exception) {
    }
  }

  static post(url) async {
    var httpClient = new HttpClient();
    try {
      var request = await httpClient.postUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        return data;
      } else {
      }
    } catch (exception) {
    }
  }
}
