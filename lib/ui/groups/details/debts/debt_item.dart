import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/ui/helpers/on_future_build_error.dart';
import 'package:spending_share/ui/widgets/circle_icon_button.dart';

class DebtItem extends StatelessWidget {
  const DebtItem({
    Key? key,
    required this.onTap,
    required this.from,
    required this.to,
    required this.value,
    required this.currency,
    required this.color,
    required this.icon,
  }) : super(key: key);

  final VoidCallback onTap;
  final DocumentReference from;
  final DocumentReference to;
  final double value;
  final String currency;
  final String color;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder<DocumentSnapshot>(
          future: from.get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var member = Member.fromDocument(snapshot.data!);
              return Row(
                children: [
                  CircleIconButton(
                    width: 20,
                    color: color,
                    icon: member.icon ?? icon,
                  ),
                  Column(
                    children: [
                      Text(member.name),
                      if (value.floor() == value)
                        Text(value.toInt().toString() + ' ' + currency)
                      else
                        Text(value.toString() + ' ' + currency),
                    ],
                  )
                ],
              );
            }
            return OnFutureBuildError(snapshot);
          },
        ),
        const Icon(Icons.arrow_forward_outlined),
        FutureBuilder<DocumentSnapshot>(
          future: to.get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var member = Member.fromDocument(snapshot.data!);
              return Row(
                children: [
                  Text(member.name),
                  CircleIconButton(
                    width: 20,
                    color: color,
                    icon: member.icon ?? icon,
                  ),
                ],
              );
            }
            return OnFutureBuildError(snapshot);
          },
        ),
      ],
    );
  }
}
