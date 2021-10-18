import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/pages/data_storage.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../repository/cart_repository.dart';
import '../repository/coupon_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';
import 'package:intl/intl.dart';

class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  int cartCount = 0;
  double subTotal = 0.0;
  double total = 0.0;
  GlobalKey<ScaffoldState> scaffoldKey;


  CartController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  DatePickerController _controller = DatePickerController();

  void listenForCarts({String message}) async {
    carts.clear();
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {
          coupon = _cart.food.applyCoupon(coupon);
          carts.add(_cart);
        });
      }
    }, onError: (a) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (carts.isNotEmpty) {
        calculateSubtotal();
      }
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
      onLoadingCartDone();
    });
  }

  void onLoadingCartDone() {}

  void listenForCartsCount({String message}) async {
    final Stream<int> stream = await getCartCount();
    stream.listen((int _count) {
      setState(() {
        this.cartCount = _count;
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    });
  }

  Future<void> refreshCarts() async {
    setState(() {
      carts = [];
    });
    listenForCarts(message: S.of(context).carts_refreshed_successfuly);
  }

  void removeFromCart(Cart _cart) async {
    setState(() {
      this.carts.remove(_cart);
    });
    removeCart(_cart).then((value) {
      calculateSubtotal();
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(
            S.of(context).the_food_was_removed_from_your_cart(_cart.food.name)),
      ));
    });
  }

  void calculateSubtotal() async {
    double cartPrice = 0;
    subTotal = 0;
    carts.forEach((cart) {
      cartPrice = cart.food.price;
      cart.extras.forEach((element) {
        cartPrice += element.price;
      });
      cartPrice *= cart.quantity;
      subTotal += cartPrice;
    });
    /// Attn: Deliver fees is from the backend as amount, that should
    /// made to percent, then the below can be uncommented
    ///
    ///
    // if (Helper.canDelivery(carts[0].food.restaurant, carts: carts)) {
    //   deliveryFee = carts[0].food.restaurant.deliveryFee;
    //   print("DELIVERY FEES ${carts[0].food.restaurant.deliveryFee}");
    // }

    /// The below delivery fees should be removed when the above is done
    ///
    ///
    var rem = subTotal % 500;
    if(rem == 0) {
      deliveryFee = ((subTotal/500) * 50);
    } else if(rem > 0) {
      deliveryFee = ((subTotal/500).ceil() * 50).toDouble();
    }

    taxAmount =
        (subTotal + deliveryFee) * carts[0].food.restaurant.defaultTax / 100;
    total = subTotal + taxAmount + deliveryFee;
    setState(() {});
  }

  void doApplyCoupon(String code, {String message}) async {
    coupon = new Coupon.fromJSON({"code": code, "valid": null});
    final Stream<Coupon> stream = await verifyCoupon(code);
    stream.listen((Coupon _coupon) async {
      coupon = _coupon;
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      listenForCarts();
//      saveCoupon(currentCoupon).then((value) => {
//          });
    });
  }

  incrementQuantity(Cart cart) {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  void goCheckout(BuildContext context) {
    if (!currentUser.value.profileCompleted()) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).completeYourProfileDetailsToContinue),
        action: SnackBarAction(
          label: S.of(context).settings,
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            Navigator.of(context).pushNamed('/Settings');
          },
        ),
      ));
    } else {
      if (carts[0].food.restaurant.closed) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_restaurant_is_closed_),
        ));
      } else {

        if(DataStorage.selectedDate == null || DataStorage.slotId==null) {
          print("DataStorage.slotId");
          scaffoldKey?.currentState?.showSnackBar(SnackBar(duration: Duration(seconds:2),
            content: Text(S.of(context).Please_select_a_date_to_Continue),
          ));
        }
        else
          Navigator.of(context).pushNamed('/DeliveryPickup',);
      }
    }
  }
  getSelectDate(BuildContext context) {
    if (!currentUser.value.profileCompleted()) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).completeYourProfileDetailsToContinue),
        action: SnackBarAction(
          label: S.of(context).settings,
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            Navigator.of(context).pushNamed('/Settings');
          },
        ),
      ));
    } else {
      if (carts[0].food.restaurant.closed) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_restaurant_is_closed_),
        ));
      } else {
        return _selectDate(context);
      }
    }
  }

  selectDatePicker(DateTime date){
    DateTime selectedValue=date;
    DataStorage.selectedDate=DateFormat("yyyy-MM-dd").format(selectedValue);
    print(DataStorage.selectedDate);
    DateTime current = DateTime.now();
    DataStorage.hour=current.hour.toString();
    print('Hour: ${DataStorage.hour}');
  }
  selectedTimeSlots(int slotId,String Slots){
    DataStorage.slotId = slotId;
    DataStorage.slots = Slots;

  }
  timeSlotNotAvailable(context){

    scaffoldKey?.currentState?.showSnackBar(SnackBar(
      content: Text(S.of(context).Time_slot_not_available),
    ));
  }

  Future<void> _selectDate(BuildContext context) async {
    String _selectedDate;
    final DateTime d = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
        helpText:  "Schedule Booking",
        builder: (BuildContext context,Widget child){
          return Theme(data: ThemeData(
            primarySwatch: Colors.red,
          ),
            child: child, );
        }

    );
    if (d != null)
      setState(() {
        _selectedDate =DateFormat("yyyy-MM-dd").format(d);
        debugPrint(_selectedDate);
        DataStorage.selectedDate=_selectedDate;
        print(DataStorage.selectedDate);
      });
  }

  Color getCouponIconColor() {
    print(coupon.toMap());
    if (coupon?.valid == true) {
      return Colors.green;
    } else if (coupon?.valid == false) {
      return Colors.redAccent;
    }
    return Theme.of(context).focusColor.withOpacity(0.7);
  }
}
