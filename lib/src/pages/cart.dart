import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/controllers/Available_Time_Slots.dart';
import 'package:food_delivery_app/src/controllers/checkout_controller.dart';
import 'package:food_delivery_app/src/controllers/order_controller.dart';
import 'package:food_delivery_app/src/pages/data_storage.dart';
import 'package:food_delivery_app/src/repository/available_time_slot_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:intl/intl.dart';
import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/CartItemWidget.dart';
import '../elements/EmptyCartWidget.dart';
//import '../helpers/hpaelper.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class CartWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  CartWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends StateMVC<CartWidget> {
  CartController _con;

  _CartWidgetState() : super(CartController()) {
    _con = controller;
  }



  DatePickerController _controller = DatePickerController();
  @override
  void initState() {
    _con.listenForCarts();
    super.initState();
    DataStorage.slotId = null;
    DataStorage.selectedDate = null;
  }

 DateTime selectedDate = null;
  String selectedDateFormatted = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      bottomNavigationBar: CartBottomDetailsWidget(
          con: _con, selectedDateFormatted: selectedDateFormatted),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            if (widget.routeArgument != null) {
              Navigator.of(context).pushReplacementNamed(
                  widget.routeArgument.param,
                  arguments: RouteArgument(id: widget.routeArgument.id));
            } else {
              Navigator.of(context)
                  .pushReplacementNamed('/Pages', arguments: 2);
            }
          },
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).hintColor,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).cart,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshCarts,
        child: _con.carts.isEmpty
            ? EmptyCartWidget()
            : Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.shopping_cart,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            S.of(context).shopping_cart,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          subtitle: Text(
                            S
                                .of(context)
                                .verify_your_quantity_and_click_checkout,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: true,
                          itemCount: _con.carts.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 15);
                          },
                          itemBuilder: (context, index) {
                            return CartItemWidget(
                              cart: _con.carts.elementAt(index),
                              heroTag: 'cart',
                              increment: () {
                                _con.incrementQuantity(
                                    _con.carts.elementAt(index));
                              },
                              decrement: () {
                                _con.decrementQuantity(
                                    _con.carts.elementAt(index));
                              },
                              onDismissed: () {
                                _con.removeFromCart(
                                    _con.carts.elementAt(index));
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 70),
                        margin: EdgeInsets.only(bottom: 30),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.15),
                                  offset: Offset(0, 2),
                                  blurRadius: 5.0)
                            ]),
                        child: Column(
                          children: [
                            Text(
                              S.of(context).selectBookingDate,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * .132,
                                width: MediaQuery.of(context).size.width,
                                child: DatePicker(
                                  DateTime.now(),
                                  width: 60,
                                  height: 50,
                                  controller: _controller,
                                  initialSelectedDate: DateTime.now(),
                                  selectionColor:
                                      Theme.of(context).accentColor,
                                  selectedTextColor: Colors.white,
                                  onDateChange: (date) {
                                    // New date selected
                                    setState(() {
                                      print("Resturent Id : ${_con.carts[0].food.restaurant.id}");
                                      print(date.toString());
                                    _con.selectDatePicker(date);
                                    print("DataStorage.selectedDate${DataStorage
                                        .selectedDate}");
                                       if (DataStorage.selectedDate != null) {
                                         DataStorage.slotId=null;
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              TimeDialog(
                                                date: DataStorage.selectedDate,
                                                res_id: _con.carts[0].food.restaurant.id,
                                              ),
                                        );

                                       }

                                    });


                                  },
                                ) //,
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(18),
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.15),
                              offset: Offset(0, 2),
                              blurRadius: 5.0)
                        ]),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      onSubmitted: (String value) {
                        _con.doApplyCoupon(value);
                      },
                      cursorColor: Theme.of(context).accentColor,
                      controller: TextEditingController()
                        ..text = coupon?.code ?? '',
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: Theme.of(context).textTheme.bodyText1,
                        suffixText: coupon?.valid == null
                            ? ''
                            : (coupon.valid
                                ? S.of(context).validCouponCode
                                : S.of(context).invalidCouponCode),
                        suffixStyle: Theme.of(context)
                            .textTheme
                            .caption
                            .merge(
                                TextStyle(color: _con.getCouponIconColor())),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Icon(
                            Icons.confirmation_number,
                            color: _con.getCouponIconColor(),
                            size: 28,
                          ),
                        ),
                        hintText: S.of(context).haveCouponCode,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

}

class TimeDialog extends StatefulWidget {
  final String date;
  final String res_id;


  const TimeDialog({Key key, this.date, this.res_id}) : super(key: key);
  @override
  _TimeDialogState createState() => _TimeDialogState();
}

class _TimeDialogState extends StateMVC<TimeDialog> {
  TimeSlotController _con;
  CartController con = CartController();
  DateTime selectedDate;
  _TimeDialogState() : super(TimeSlotController()) {
    _con = controller;
  }
  bool loading;
  @override
  void initState() {
    loadData();
    DataStorage.slotId = null;
    super.initState();
  }

  loadData() async {
    setState(() {
      loading = true;
    });
    await _con.getAvailableTimeSlots(
        widget.date, widget.res_id, DataStorage.hour);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15),
      title: Center(child: const Text(' Time Slot')),
      content: loading == true
          ? Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 4,
          child: Center(
              child: Container(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator())))
          : Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4,
        child: _con.timeSlot.data.length == 0
            ? Column(
          children: [
            SizedBox(height: 30,),
            Center(
              child: Text(
                'No Time Slots Available!!',
                style: TextStyle(color: Theme.of(context).accentColor,fontSize: 20),
              ),
            ),
          ],
        )
            : GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children:
          List.generate(_con.timeSlot.data.length, (index) {
            return InkWell(
              child: Container(
                width: 150,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _con.timeSlot.data[index].status == 0
                      ? Colors.red
                      : Colors.black12,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:2.0),
                  child: Center(
                      child: _con.timeSlot.data.length == null
                          ? Text(" ")
                          : Text(_con.timeSlot.data[index].slots,style: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.w600),)),
                ),
              ),
              onTap: _con.timeSlot.data[index].status == 0
                  ? () {
                print("Slot : ${_con.timeSlot.data[index].slots}");
                con.selectedTimeSlots(
                    _con.timeSlot.data[index].id,_con.timeSlot.data[index].slots);
                Navigator.pop(context);
              }
                  : con.timeSlotNotAvailable(context),
            );
          }),
        ),
      ),
    );
  }
}

