import 'package:image_save/image_save.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';

saveNetworkImage(url) async {
  var response = await Dio()
      .get(url, options: Options(responseType: ResponseType.bytes));
  final result =
  await ImageSave.saveImage("jpg", Uint8List.fromList(response.data));
  print(result);
}
