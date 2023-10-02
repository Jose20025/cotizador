import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color? color;
  final IconData icon;
  const CustomCard(
      {super.key,
      required this.icon,
      required this.title,
      this.color,
      this.subtitle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: color,
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: Icon(icon),
          subtitle: subtitle != null ? Text(subtitle!) : null,
        ),
      ),
    );
  }
}
