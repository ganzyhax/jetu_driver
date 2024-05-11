import 'package:flutter/material.dart';

class TodayWorkInfoCard extends StatelessWidget {
  final String cost;
  final String rides;
  const TodayWorkInfoCard({super.key, required this.cost, required this.rides});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 30,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Сегодня',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    cost + ' тг',
                    style: TextStyle(color: Colors.black, fontSize: 32),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.car_crash_rounded, color: Colors.blue),
                          Text(
                            rides + ' заездов',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.watch_later_outlined,
                            color: Colors.blue,
                          ),
                          Text(
                            '24 часов',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
