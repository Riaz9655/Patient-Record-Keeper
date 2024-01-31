import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  final String label1;
  final String label2;
  final String value1;
  final String value2;

  const CustomRow({
    required this.label1,
    required this.label2,
    required this.value1,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 400,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              initialValue: value1,
              readOnly: true,
              style: const TextStyle(color: Colors.black, fontSize: 16.0),
              decoration: InputDecoration(
                labelText: label1,
                labelStyle: const TextStyle(color: Colors.blue),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: TextFormField(
              initialValue: value2,
              readOnly: true,
              style: const TextStyle(color: Colors.black, fontSize: 16.0),
              decoration: InputDecoration(
                labelText: label2,
                labelStyle: const TextStyle(color: Colors.blue),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
