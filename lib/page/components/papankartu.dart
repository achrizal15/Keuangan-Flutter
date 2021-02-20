import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KartuPapan extends StatelessWidget {
  final String caption;
  final String src;
  final int caption2;

  const KartuPapan({Key key, this.caption, this.src, this.caption2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: Colors.orange[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              height: 110,
              width: 100,
              child: Image.asset('$src', fit: BoxFit.fill)),
          Text(
            caption,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w800),
          ),
          Text(
            NumberFormat.currency(
                                locale: 'id',symbol: 'Rp.',decimalDigits: 0,)
                            .format(caption2),
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w200),
          ),
        ],
      ),
    );
  }
}
