import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  const CustomCard(
      {super.key, required this.icon, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: ListTile(
          title: Text(title),
          leading: Icon(icon),
          subtitle: subtitle != null ? Text(subtitle!) : null,
        ),
      ),
    );
  }
}
