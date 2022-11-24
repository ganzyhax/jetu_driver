import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/services/jetu_order/grapql_query.dart';
import 'package:jetu.driver/app/widgets/graphql_wrapper/subscription_wrapper.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';

class JetuServicesListWidget extends StatelessWidget {
  const JetuServicesListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SubscriptionWrapper<JetuOrderList>(
      queryString: JetuOrdersQuery.fetchOrders(),
      dataParser: (json) => JetuOrderList.fromUserJson(json),
      contentBuilder: (JetuOrderList data) {
        return SizedBox(
          height: 60.h,
          child: ListView.builder(
            itemCount: data.orders.length,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemBuilder: (c, index) {
              final service = data.orders[index];
              return ListTile(
                title: Text('dd'),
              );
            },
          ),
        );
      },
    );
  }
}
