import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/Avilable_Time_Slots.dart';
import 'package:food_delivery_app/src/repository/available_time_slot_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class TimeSlotController extends ControllerMVC {
  AvailableTimeSlots timeSlot = AvailableTimeSlots();

  GlobalKey<ScaffoldState> scaffoldKey;

  getAvailableTimeSlots(
      String Date, String restaurant_id, String currentTime) async {
    print("currentTime gatavailabeTimeSlots : $currentTime");
    final Stream<AvailableTimeSlots> stream = await getTimeSlots(Date, restaurant_id, currentTime);
    stream.listen((AvailableTimeSlots _data) {
      timeSlot = _data;
      // timeSlot.add(_data);
      setState(() {});
    });
  }
}
