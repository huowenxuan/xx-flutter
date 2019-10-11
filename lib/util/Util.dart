import 'package:image_save/image_save.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';
// import 'package:permission_handler/permission_handler.dart';

requestPermission() {
//  PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
//     PermissionHandler().requestPermissions(<PermissionGroup>[
//       PermissionGroup.storage,
//       PermissionGroup.camera
//     ]);
}

saveNetworkImage(url) async {
  var response = await Dio()
      .get(url, options: Options(responseType: ResponseType.bytes));
  final result =
  await ImageSave.saveImage("jpg", Uint8List.fromList(response.data));
  print(result);
}
