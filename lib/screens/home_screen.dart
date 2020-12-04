import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:Covid19_Tracker/models/chart_data_model.dart';
import 'package:Covid19_Tracker/widgets/char_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<String> imageUrl = [
    'assets/images/ic_active_2x.png',
    'assets/images/ic_heart_2x.png',
    'assets/images/ic_dead_2x.png',
  ];

  List<ChartDataModel> dataPointsWeekly = [];
  List<ChartDataModel> dataPointsMonthly = [];

  static const spinkit = SpinKitFadingCube(
    color: Colors.blue,
    size: 36,
  );

  final String apiBase = 'https://api.covid19api.com/';
  final String apiSummary = 'https://api.covid19api.com/summary';
  final String apiWeekly =
      'https://api.covid19api.com/country/india/status/confirmed';

  final DateTime today = DateTime.now();

  final formatter = NumberFormat('#,##,###');

  int totalDeadths = 0;
  int newDeaths = 0;
  int totalConfirmed = 0;
  int newConfirmed = 0;
  int totalRecovered = 0;
  int newRecovered = 0;

  String lastUpdateDate = '';

  void getData() async {
    final todaysData = await http.get(apiSummary);

    if (todaysData.statusCode == 200) {
      final jsonResponse = json.decode(todaysData.body);
      List<dynamic> mp = jsonResponse['Countries'];
      for (int i = 0; i < mp.length; i++) {
        if (mp[i]['Country'] == 'India') {
          setState(() {
            newDeaths = mp[i]['NewDeaths'];
            newConfirmed = mp[i]['NewConfirmed'];
            newRecovered = mp[i]['NewRecovered'];
            totalConfirmed = mp[i]['TotalConfirmed'];
            totalDeadths = mp[i]['TotalDeaths'];
            totalRecovered = mp[i]['TotalRecovered'];
            lastUpdateDate = DateFormat('d MMM, y').format(today);
          });
          break;
        }
      }
    } else
      print('Failed');

    DateTime weekDatefromNow = today.add(Duration(days: -8));
    DateTime testToday = today.add(Duration(days: -1));
    String weeklyApi = apiWeekly +
        '?from=' +
        weekDatefromNow.toIso8601String() +
        '&to=' +
        testToday.toIso8601String();

    final weeklyData = await http.get(weeklyApi);

    if (weeklyData.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(weeklyData.body);

      dataPointsWeekly = [];

      setState(() {
        for (int i = 0; i < jsonResponse.length; i++) {
          dataPointsWeekly.add(ChartDataModel(
            cases: jsonResponse[i]['Cases'],
            status: jsonResponse[i]['Status'],
            day: DateTime.parse(jsonResponse[i]['Date']).weekday,
          ));
        }
      });
    } else
      print('Weekly Chart Data Failed!!');
  }

  void initState() {
    super.initState();
    getData();
  }

  InkWell infoRowItem(
      Color col, int imageUrlIndex, String status, int newData, int totalData) {
    return InkWell(
      highlightColor: col.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        // getData();
      },
      child: Container(
        height: 150,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: col.withOpacity(0.20),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imageUrl[imageUrlIndex]),
              SizedBox(height: 10),
              Text(
                '[+' + formatter.format(newData).toString() + ']',
                style: TextStyle(
                  color: col,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                formatter.format(totalData).toString(),
                style: TextStyle(
                  color: col,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: col,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Covid19 India Tracker',
            style: TextStyle(
              color: Color.fromRGBO(14, 51, 96, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 75, 99, 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(156, 54, 54, 0.32),
                        spreadRadius: 3,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  height: 105,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/images/character.png',
                        fit: BoxFit.cover,
                        height: 180,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Take the Self Checkup!',
                              style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.62,
                              child: Text(
                                'Contains several checklist question to check your physical condition.',
                                style: TextStyle(
                                  fontSize: 13.3,
                                  color: Colors.white,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transmission Update',
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Latest Update: ' + lastUpdateDate,
                          style: TextStyle(fontFamily: 'Gilroy', fontSize: 14),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                        icon: Icon(Icons.cached),
                        splashRadius: 28,
                        onPressed: () {
                          getData();
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    infoRowItem(Color.fromRGBO(0, 123, 255, 1), 0, 'Active',
                        newConfirmed, totalConfirmed),
                    infoRowItem(Color.fromRGBO(33, 207, 85, 1), 1, 'Recovered',
                        newRecovered, totalRecovered),
                    infoRowItem(Color.fromRGBO(255, 49, 49, 1), 2, 'Deceased',
                        newDeaths, totalDeadths),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 20),
                  child: Text(
                    'Spread Trends',
                    style: TextStyle(fontSize: 19),
                  ),
                ),
                Container(
                  height: 400,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(0, 123, 255, 0.20),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Active Cases',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 123, 255, 1),
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Color.fromRGBO(0, 123, 255, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                    text: formatter.format(totalConfirmed)),
                                TextSpan(
                                  text: '[+${formatter.format(newConfirmed)}]',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      DefaultTabController(
                        length: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 40,
                              child: TabBar(
                                labelColor: Colors.black,
                                indicatorColor: Colors.black,
                                tabs: [
                                  Tab(
                                    text: 'Weekly',
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 300,
                              child: TabBarView(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    width: double.infinity,
                                    child: (dataPointsWeekly == null || dataPointsWeekly.length == 0)
                                        ? Container(
                                            child: spinkit,
                                          )
                                        : ChartWidget(
                                            dataPoints: dataPointsWeekly,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
