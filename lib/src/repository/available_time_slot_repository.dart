import 'dart:convert';
import 'dart:io';

import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/Avilable_Time_Slots.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/credit_card.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;


Future<Stream<AvailableTimeSlots>> getTimeSlots(String date,String restaurant_id,String currentTime) async {


  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}get_AvailableTimeSlots?${_apiToken}&date=$date&restaurant_id=$restaurant_id&hour=$currentTime';
      //'${GlobalConfiguration().getString('api_base_url')}getAvailableTimeSlots?${_apiToken}&date=$date&restaurant_id=$restaurant_id';
  print("getAvailableTimeSlots  $url");
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    print("getAvailableTimeSlots1233333456");
    /*return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data){
      print("api call $data");
     return AvailableTimeSlots.fromJson(data);

    });*/
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) {
      print(data);
      print("123");
      return AvailableTimeSlots.fromJson(data);
    });
  }  catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(AvailableTimeSlots.fromJson({}));
  }
}




