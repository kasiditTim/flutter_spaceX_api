import 'package:dio/dio.dart';

class ApiService {
  static Future<List> get() async {
    try {
      const url = "https://api.spacexdata.com/v5/launches";
      final response = await Dio().get(url);

      if (response.statusCode == 200) {
        final responseData = response.data;
        return responseData;
      } else {
        print("Unable to make request. Status: ${response.statusCode}");
        throw Exception(
            "Unable to make request. Status: ${response.statusCode}");
      }
    } catch (e) {
      print(e.runtimeType);
      throw Exception(e);
    }
  }
}
