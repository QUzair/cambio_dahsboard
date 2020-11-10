import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DriverCard extends StatelessWidget {
  final String driverName;
  final double scoreVal;
  final String driverSelected;
  const DriverCard({
    Key key,
    this.driverName,
    this.scoreVal,
    this.driverSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
        padding: EdgeInsets.all(5),
        child: Neumorphic(
          style: NeumorphicStyle(
            depth: (driverSelected == driverName) ? 0 : 6,
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(10),
            ),
          ),
          padding: EdgeInsets.all(30.0),
          child: CircularPercentIndicator(
            radius: size.width/12,
            lineWidth: 13.0,
            animation: true,
            percent: scoreVal / 10,
            center: Text(
              scoreVal.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            footer: Text(
              driverName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.green.withOpacity(scoreVal / 10),
          ),
        ));
  }
}
