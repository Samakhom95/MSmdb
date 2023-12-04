

import 'package:flutter/material.dart';

class SeriesScreen extends StatefulWidget {
  const SeriesScreen({super.key});

  @override
  State<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
         padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: const [

      ],),
    );
  }
}
