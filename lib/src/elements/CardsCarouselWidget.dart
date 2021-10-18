import 'package:flutter/material.dart';

import '../elements/CardsCarouselLoaderWidget.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';
import 'CardWidget.dart';

// ignore: must_be_immutable
class CardsCarouselWidget extends StatefulWidget {
  List<Restaurant> restaurantsList;
  String heroTag;

  CardsCarouselWidget({Key key, this.restaurantsList, this.heroTag}) : super(key: key);

  @override
  _CardsCarouselWidgetState createState() => _CardsCarouselWidgetState();
}

class _CardsCarouselWidgetState extends State<CardsCarouselWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.restaurantsList.isEmpty
        ? CardsCarouselLoaderWidget()
        : Container(
            height: 288,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.restaurantsList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Details',
                        arguments: RouteArgument(
                          id: widget.restaurantsList.elementAt(index).id,
                          heroTag: widget.heroTag,
                        ));
                  },
                  child: CardWidget(restaurant: widget.restaurantsList.elementAt(index), heroTag: widget.heroTag),
                );
              },
            ),
          );
  }
}



// ignore: must_be_immutable
class CardsCarouselWidgetVertical extends StatefulWidget {
  List<Restaurant> restaurantsList;
  String heroTag;

  CardsCarouselWidgetVertical({Key key, this.restaurantsList, this.heroTag}) : super(key: key);

  @override
  _CardsCarouselWidgetVerticalState createState() => _CardsCarouselWidgetVerticalState();
}

class _CardsCarouselWidgetVerticalState extends State<CardsCarouselWidgetVertical> {

  @override
  Widget build(BuildContext context) {
    return widget.restaurantsList.isEmpty
        ? CardsCarouselLoaderWidget()
        : ListView.builder(
          physics:NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: widget.restaurantsList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/Details',
                    arguments: RouteArgument(
                      id: widget.restaurantsList.elementAt(index).id,
                      heroTag: widget.heroTag,
                    ));
              },
              child: CardWidget(restaurant: widget.restaurantsList.elementAt(index), heroTag: widget.heroTag),
            );
          },
        );
  }
}
