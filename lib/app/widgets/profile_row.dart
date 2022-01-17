import 'package:flutter/material.dart';

Widget profileRow({
  required IconData icon,
  required String title,
  required String subtitle,
}) {
  return Row(
    children: [
      Container(
        height: 55,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 17,
            color: Colors.yellow,
          ),
        ),
      ),
      SizedBox(width: 20),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
                fontFamily: 'MetroPolis',
                fontWeight:FontWeight.bold
            ),
          ),
          SizedBox(height: 8),

          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),


        ],
      ),

    ],
  );
}
