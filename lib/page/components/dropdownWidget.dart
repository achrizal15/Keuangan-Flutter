import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final String dropdownValue;
  final Function fungsi;

  const DropdownWidget({Key key, this.dropdownValue, this.fungsi})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
        alignment: Alignment.centerLeft,
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.filter_list_alt,color: Colors.white),
          iconSize: 24,
          dropdownColor: Colors.orange[200],
          elevation: 16,
          style: TextStyle(
            color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: fungsi,
          items: <String>[
            'All',
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              
              value: value,
              child: Text(value),
            );
          }).toList(),
        ));
  }
}
