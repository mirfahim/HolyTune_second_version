import 'dart:convert';
import 'package:HolyTune/models/SliderImageModel.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/ApiUrl.dart';

class SliderImageProvider extends ChangeNotifier{
  List<SliderImageModel> imageList = [];

  getSliderImages()async{
    var response = await http.get(Uri.parse(ApiUrl.sliderImages));
    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      await result['upcomings'].forEach((imageModel) {
        imageList.add(SliderImageModel.fromJson(imageModel));
      });
      notifyListeners();
    }
  }
}