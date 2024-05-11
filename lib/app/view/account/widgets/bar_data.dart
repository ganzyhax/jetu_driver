import 'package:jetu.driver/app/view/account/widgets/individual_bars.dart';

class BarData {
  final double sunAmout;
  final double monAmout;
  final double tueAmout;
  final double wedAmout;
  final double thurAmout;
  final double friAmout;
  final double satAmout;
  BarData(
      {required this.satAmout,
      required this.sunAmout,
      required this.thurAmout,
      required this.tueAmout,
      required this.friAmout,
      required this.wedAmout,
      required this.monAmout});
  List<IndividualBar> barData = [];
  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: sunAmout.toInt()),
      IndividualBar(x: 1, y: monAmout.toInt()),
      IndividualBar(x: 2, y: tueAmout.toInt()),
      IndividualBar(x: 3, y: wedAmout.toInt()),
      IndividualBar(x: 5, y: thurAmout.toInt()),
      IndividualBar(x: 4, y: friAmout.toInt()),
      IndividualBar(x: 5, y: satAmout.toInt()),
    ];
  }
}
