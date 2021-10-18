import 'package:flutter/material.dart';




class SelectDateWidget extends StatefulWidget {
  @override
  _SelectDateWidgetState createState() => _SelectDateWidgetState();
}

class _SelectDateWidgetState extends State<SelectDateWidget> {
  var finaldate;

  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      finaldate = order;
    });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(

      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.grey[200]),
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: finaldate == null
                  ? Text(
                "Use below button to Select a Date",
                textScaleFactor: 2.0,
              )
                  : Text(
                "$finaldate",
                textScaleFactor: 2.0,
              ),
            ),
            new RaisedButton(
              onPressed: callDatePicker,
              color: Colors.blueAccent,
              child:
              new Text('Click here', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}


