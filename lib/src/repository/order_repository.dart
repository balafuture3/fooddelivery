import 'dart:convert';
import 'dart:io';

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

Future<Stream<Order>> getOrders() async {

  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=user;foodOrders;foodOrders.food;foodOrders.extras;orderStatus;payment&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=id&sortedBy=desc';

  final client = new http.Client();

  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));


  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {

    return Order.fromJSON(data);
  });
}

Future<Stream<Order>> getOrder(orderId) async {

  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders/$orderId?${_apiToken}with=user;foodOrders;foodOrders.food;foodOrders.extras;orderStatus;deliveryAddress;payment';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).map((data) {
   print("data $data ");
    return Order.fromJSON(data);
  });
}

Future<Stream<Order>> getRecentOrders() async {

  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }

  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=user;foodOrders;foodOrders.food;foodOrders.extras;orderStatus;payment&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=updated_at&sortedBy=desc&limit=3';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    print("getRecentOrders $data ");
    return Order.fromJSON(data);
  });
}

Future<Stream<OrderStatus>> getOrderStatus() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}order_statuses?$_apiToken';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    return OrderStatus.fromJSON(data);
  });
}

Future<Order> addOrder(Order order, Payment payment) async {
//Future<Order> addOrder(Order order, Payment payment) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Order();
  }
  CreditCard _creditCard = await userRepo.getCreditCard();
  order.user = _user;
  order.payment = payment;


  final String _apiToken = 'api_token=${_user.apiToken}';
  //final String url = '${GlobalConfiguration().getString('api_base_url')}orders?$_apiToken';
 final String url = '${GlobalConfiguration().getString('api_base_url')}orders?$_apiToken';
  final client = new http.Client();
  Map params = order.toMap();
  params.addAll(_creditCard.toMap());
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(params),
  );
  print("order Api : $url");
  print("data params : ${params.toString()}");
  print("data resp : ${response.body.toString()}");
  final String url1 = '${GlobalConfiguration().getString('api_base_url')}updateOrderData?$_apiToken';
  print("url1 $url1");
   //Map param = Map();

  // param["id"]=json.decode(response.body)['data']["id"];
  // param["delivery_date"]= order.delivery_date;
  // param["delivery_time_slot"]=order.delivery_time_slot;
 // print("param to json:${param}");
  await client.post(
    url1,
   // headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: {"id":json.decode(response.body)['data']["id"].toString(),
      "delivery_date":order.delivery_date,
      "delivery_time_slot":order.delivery_time_slot,
    } //json.encode(param),
  );

  return Order.fromJSON(json.decode(response.body)['data']);
}

Future<Order> cancelOrder(Order order) async {
  print(order.toMap());
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}orders/${order.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(order.cancelMap()),
  );
  if (response.statusCode == 200) {
    return Order.fromJSON(json.decode(response.body)['data']);
  } else {
    throw new Exception(response.body);
  }
}
