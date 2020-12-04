import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:Covid19_Tracker/models/chart_data_model.dart';

class ChartWidget extends StatefulWidget {
  final List<ChartDataModel> dataPoints;

  ChartWidget({this.dataPoints});

  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  List<FlSpot> spots = [];
  List<FlSpot> spotsGenerator() {
    spots = [];
    int ref = widget.dataPoints[0].day;
    for (int i = 0; i < widget.dataPoints.length; i++) {
      spots.add(
          FlSpot(i.toDouble() + ref, widget.dataPoints[i].cases.toDouble()));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      
      clipData: FlClipData(
        bottom: true,
        left: true,
        right: true,
        top: true,
      ),
      borderData: FlBorderData(
        show: false,
      ),
      gridData: FlGridData(
        drawHorizontalLine: false,
        drawVerticalLine: true,
      ),
      lineBarsData: [
        LineChartBarData(
          spots:
              widget.dataPoints.length == 0 ? FlSpot(0, 0) : spotsGenerator(),
          isCurved: true,
          colors: [Color.fromRGBO(0, 123, 255, 1)],
          
          barWidth: 5,
          belowBarData: BarAreaData(
            show: true,
            colors: [Color.fromRGBO(0, 123, 255, 0.3)],
          ),
        ),
      ],
      titlesData: FlTitlesData(
        show: true,
        leftTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          margin: 1,
          reservedSize: 0,
          getTitles: (value) {
            switch (value.toInt() % 7) {
              case 0:
                return 'Mon';
              case 1:
                return 'Tue';
              case 2:
                return 'Wed';
              case 3:
                return 'Thur';
              case 4:
                return 'Fri';
              case 5:
                return 'Sat';
              case 6:
                return 'Sun';
            }
            return 'NULL';
          },
        ),
      ),
    ));
  }
}
