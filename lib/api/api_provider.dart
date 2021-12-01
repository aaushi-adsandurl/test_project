import 'package:get/get.dart';

class Provider extends GetConnect {
  Future<dynamic> getUser() async {
    final response = await get(
        'https://shibe.online/api/shibes?count=20&urls=true&httpsUrls=true');
    if (response.status.hasError) {
      return Future.error(response.statusText);
    } else {
      return response.body;
    }
  }
}
