import 'dart:convert';
import 'dart:html';
import 'dart:math';

import 'package:cambio_dashboard/model/kpi_model.dart';
import 'package:cambio_dashboard/widgets/bar_chart.dart';
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
      title: 'Cambio',
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
  String selectedDriver = "Opportunity 🔑";
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
            List<Driver> _scoreCard = snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.data.length == 0)
              return Container(
                child: Text("Fetching Data"),
              );
            else
              return Column(
                children: [
                  SizedBox(
                    height: size.height * .025,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _scoreCard
                        .map((driver) => Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
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
                    initiallyExpanded: true,
                    title: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              findDriverByName(selectedDriver).driverName,
                              style: const TextStyle(
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
                                fontWeight: FontWeight.w100,
                              ),
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
                                initiallyExpanded: true,
                                title: Container(
                                  decoration: BoxDecoration(
                                      color:
                                          Colors.purpleAccent.withOpacity(0.1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          lever.leverName,
                                          style: TextStyle(
                                              fontSize: 35,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat'),
                                        ),
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Wrap(
                                      children: lever.kpis
                                          .map(
                                            (kpi) => Padding(
                                              padding:
                                                  const EdgeInsets.all(18.0),
                                              child: Neumorphic(
                                                style: NeumorphicStyle(
                                                  boxShape: NeumorphicBoxShape
                                                      .roundRect(
                                                    BorderRadius.circular(10),
                                                  ),
                                                ),
                                                child: Container(
                                                  width: size.width / 4,
                                                  height: size.width / 4,
                                                  padding: EdgeInsets.all(8.0),
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
                                                        KPICard(
                                                          rng: rng,
                                                          kpi: kpi,
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

class KPICard extends StatelessWidget {
  const KPICard({Key key, @required this.rng, @required this.kpi})
      : super(key: key);

  final Random rng;
  final KPI kpi;

  @override
  Widget build(BuildContext context) {
    if (kpi.valueType == 'Number') {
      return Text(
        kpi.value != null ? kpi.value.toString() : rng.nextInt(23).toString(),
        style: TextStyle(
            fontSize: 65, color: Colors.black, fontWeight: FontWeight.bold),
      );
    } else if (kpi.valueType == 'BarChart') {
      return kpi.values.isNotEmpty
          ? BarChartSample1(
              coordinates: kpi.values,
            )
          : Text("Read More");
    } else if (kpi.valueType == 'Scale') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: NeumorphicProgress(
                height: 15,
                percent: kpi.value / 10,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text((kpi.value * 10).toString() + "%",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w100))
          ],
        ),
      );
    } else
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: (NeumorphicButton(
          padding: EdgeInsets.all(8.0),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text("Read More"), Icon(Icons.read_more)],
          ),
        )),
      );
  }
}
