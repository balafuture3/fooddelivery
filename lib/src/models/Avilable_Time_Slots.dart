// To parse this JSON data, do
//
//     final availableTimeSlots = availableTimeSlotsFromJson(jsonString);

import 'dart:convert';

//List<AvailableTimeSlots> availableTimeSlotsFromJson(str) => List<AvailableTimeSlots>.from(str.map((x) => AvailableTimeSlots.fromJson(x)));
//
// String availableTimeSlotsToJson(List<AvailableTimeSlots> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class AvailableTimeSlots {
//   AvailableTimeSlots({
//     this.id,
//     this.slots,
//     this.status,
//   });
//
//   int id;
//   String slots;
//   int status;
//
//   factory AvailableTimeSlots.fromJson(Map<String, dynamic> json) => AvailableTimeSlots(
//     id: json["id"],
//     slots: json["slots"],
//     status: json["status"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "slots": slots,
//     "status": status,
//   };
// }

// class AvailableTimeSlots {
//   AvailableTimeSlots({
//     this.id,
//     this.slots,
//     this.status,
//   });
//
//   int id;
//   String slots;
//   Status status;
//
//   factory AvailableTimeSlots.fromJson(Map<String, dynamic> json) => AvailableTimeSlots(
//     id: json["id"],
//     slots: json["slots"],
//     status: statusValues.map[json["status"]],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "slots": slots,
//     "status": statusValues.reverse[status],
//   };
// }
//
// enum Status { AVAILABLE, NOT_AVAILABLE }
//
// final statusValues = EnumValues({
//   "available": Status.AVAILABLE,
//   "not_available": Status.NOT_AVAILABLE
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }


// To parse this JSON data, do
//
//     final availableTimeSlots = availableTimeSlotsFromJson(jsonString);




AvailableTimeSlots availableTimeSlotsFromJson(String str) => AvailableTimeSlots.fromJson(json.decode(str));

String availableTimeSlotsToJson(AvailableTimeSlots data) => json.encode(data.toJson());

class AvailableTimeSlots {
  AvailableTimeSlots({
    this.status,
    this.data,
  });

  int status;
  List<Datum> data;

  factory AvailableTimeSlots.fromJson(Map<String, dynamic> json) => AvailableTimeSlots(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.slots,
    this.status,
  });

  int id;
  String slots;
  int status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    slots: json["slots"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slots": slots,
    "status": status,
  };
}

/*
AvailableTimeSlots availableTimeSlotsFromJson(String str) => AvailableTimeSlots.fromJson(json.decode(str));

String availableTimeSlotsToJson(AvailableTimeSlots data) => json.encode(data.toJson());

class AvailableTimeSlots {
  AvailableTimeSlots({
    this.status,
    this.data,
  });

  int status;
  List<Datum> data;

  factory AvailableTimeSlots.fromJson(Map<String, dynamic> json) => AvailableTimeSlots(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.date,
    this.slots,
  });

  DateTime date;
  List<Slot> slots;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    date: DateTime.parse(json["date"]),
    slots: List<Slot>.from(json["slots"].map((x) => Slot.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "slots": List<dynamic>.from(slots.map((x) => x.toJson())),
  };
}

class Slot {
  Slot({
    this.id,
    this.slots,
    this.status,
  });

  int id;
  String slots;
  int status;

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
    id: json["id"],
    slots: json["slots"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slots": slots,
    "status": status,
  };
}
*/
