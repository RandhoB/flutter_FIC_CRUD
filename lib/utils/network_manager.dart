import 'package:dio/dio.dart';
import 'package:flutter_crud/models/medical_model.dart';
import 'package:flutter_crud/models/request_medical.dart';

class NetworkManager {
  late Dio _dio;

  String baseurl = 'https://fic-app-fry88.ondigitalocean.app/api';

  NetworkManager() {
    _dio = Dio();
  }

  Future<MedicalModel> getAll() async {
    final response = await _dio.get(
      "$baseurl/medicals",
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );
    return MedicalModel.fromJson(response.data);
  }

  Future<void> addData(RequestMedical requestMedical) async {
    final response = await _dio.post(
      "$baseurl/medicals",
      // options: Options(
      //   headers: {
      //     "Content-Type": "application/json",
      //   },
      // ),
      data: {
        'data': requestMedical.toMap(),
      },
    );
    // print(response.toString());
  }

  Future<void> updateData(int id, RequestMedical requestMedical) async {
    var response = await _dio.put(
      "$baseurl/medicals/$id",
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
      data: {
        "data": requestMedical.toMap(),
      },
    );
    Map obj = response.data;
  }

  Future<void> deleteData(int id) async {
    var response = await _dio.delete(
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
      "$baseurl/medicals/$id",
    );
    print(response.statusCode);
  }
}
