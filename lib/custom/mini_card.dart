import 'package:flutter/material.dart';

class MiniCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const MiniCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}
