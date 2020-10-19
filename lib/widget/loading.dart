import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final Color color;
  const Loading({
    this.color = Colors.indigo,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
      height: 25,
      width: 25,
    ));
  }
}
