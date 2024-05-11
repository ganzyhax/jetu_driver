import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:jetu.driver/app/view/account/widgets/bar_data.dart';

class StatisticsBar extends StatelessWidget {
  final List weekResult;
  final String allWeekCost;
  const StatisticsBar(
      {super.key, required this.weekResult, required this.allWeekCost});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
        satAmout: weekResult[0].toDouble(),
        sunAmout: weekResult[1].toDouble(),
        thurAmout: weekResult[2].toDouble(),
        tueAmout: weekResult[3].toDouble(),
        friAmout: weekResult[4].toDouble(),
        wedAmout: weekResult[5].toDouble(),
        monAmout: weekResult[6].toDouble());
    myBarData.initializeBarData();
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Column(
        children: [
          Column(
            children: [
              Text(
                'На этой неделе',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                allWeekCost + ' тг',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          Divider(),
          SizedBox(
              height: 300,
              child: BarChart(BarChartData(
                  maxY: 25000,
                  minY: 0,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: myBarData.barData
                      .map((data) => BarChartGroupData(x: data.x, barRods: [
                            BarChartRodData(
                              toY: data.y.toDouble(),
                              color: Colors.blue,
                              width: 30,
                              borderRadius: BorderRadius.circular(4),
                            )
                          ]))
                      .toList(),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: getBottomTitles)),
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ))))
        ],
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = Text('Пн');
      break;
    case 1:
      text = Text('Вт');
      break;
    case 2:
      text = Text('Ср');
      break;
    case 3:
      text = Text('Чт');
      break;
    case 4:
      text = Text('Пт');
      break;
    case 5:
      text = Text('Сб');
      break;
    case 6:
      text = Text('Вс');
      break;
    default:
      text = Text('');
      break;
  }
  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}
