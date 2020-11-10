import 'dart:convert';
import 'dart:math';

import 'package:cambio_dashboard/model/kpi_model.dart';
import 'package:cambio_dashboard/widgets/driver_card.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  runApp(MyApp());
}

final TextTheme cambio_text_theme = const TextTheme(
  headline1: const TextStyle(
      fontSize: 72.0, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
  headline5: const TextStyle(
      fontSize: 36.0, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
  headline6: const TextStyle(
      fontSize: 36.0, fontStyle: FontStyle.italic, fontFamily: 'Montserrat'),
  bodyText2: const TextStyle(fontSize: 14.0, fontFamily: 'Montserrat'),
  bodyText1: const TextStyle(fontFamily: 'Montserrat'),
  caption: const TextStyle(fontSize: 12, fontFamily: 'Montserrat'),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Neumorphic App',
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        baseColor: Color(0xFFf7f3f2),
        lightSource: LightSource.topLeft,
        shadowLightColor: Colors.white,
        depth: 7,
        textTheme: cambio_text_theme,
        accentColor: Color(0xFFDB00B6),
        variantColor: Color(0xFF8900F2),
        iconTheme: IconThemeData(color: Color(0xFFD100D1)),
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: Color(0xFF3E3E3E),
        lightSource: LightSource.topLeft,
        depth: 6,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Driver> _scoreCard;
  Future<List<Driver>> _scoreCardFuture;

  Driver findDriverByName(String driverName) =>
      _scoreCard.firstWhere((driver) => driver.driverName == driverName);

  Future<List<Driver>> fetchScorecard() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/data/scorecardDefinitions.json");

    print(data);
    dynamic jsonData = jsonDecode(data);
    _scoreCard = List<Driver>.from(
        jsonData['drivers'].map((json) => Driver.fromJson(json)));
    return _scoreCard;
  }

  @override
  void initState() {
    super.initState();
    _scoreCardFuture = fetchScorecard();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scoreCardFuture = fetchScorecard();
  }

  int groupValue = 0;
  String selectedDriver = "Opportunity";
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var rng = new Random();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height * .07,
        backgroundColor: Color(0xFFf7f3f2),
        elevation: 3,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/hitl_logo.png"),
            SizedBox(
              width: size.width * .003,
            ),
            Text(
              "Cambio",
              style: TextStyle(
                  fontSize: 45,
                  color: Colors.black,
                  fontWeight: FontWeight.w100),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Driver>>(
          future: _scoreCardFuture,
          builder:
              (BuildContext context, AsyncSnapshot<List<Driver>> snapshot) {
            List<Driver> scoreCard = snapshot.data;
            return snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data.length == 0
                ? Container(
                    child: Text("Fetching Data"),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: size.height * .025,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: scoreCard
                            .map((driver) => Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      print(driver.driverName);
                                      setState(() {
                                        selectedDriver = driver.driverName;
                                      });
                                    },
                                    child: DriverCard(
                                      driverName: driver.driverName,
                                      scoreVal: driver.scoreVal,
                                      driverSelected: selectedDriver,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      ExpansionCard(
                        title: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  findDriverByName(selectedDriver).driverName,
                                  style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  findDriverByName(selectedDriver)
                                      .driverDescription,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w100),
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                        children: findDriverByName(selectedDriver)
                            .levers
                            .map((lever) => Container(
                                  padding: EdgeInsets.all(30.0),
                                  child: ExpansionCard(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lever.leverName,
                                          style: TextStyle(
                                              fontSize: 35,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          lever.leverDescription,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w100),
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Wrap(
                                          children: lever.kpis
                                              .map(
                                                (kpi) => Padding(
                                                  padding: const EdgeInsets.all(
                                                      18.0),
                                                  child: Neumorphic(
                                                    style: NeumorphicStyle(
                                                      boxShape:
                                                          NeumorphicBoxShape
                                                              .roundRect(
                                                        BorderRadius.circular(
                                                            10),
                                                      ),
                                                    ),
                                                    child: Container(
                                                      width: size.width / 5,
                                                      height: size.width / 5,
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              kpi.kpiQuestion,
                                                            ),
                                                            Text(
                                                              rng
                                                                  .nextInt(23)
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 45,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                      )
                    ],
                  );
          },
        ),
      ),
    );
  }
}
