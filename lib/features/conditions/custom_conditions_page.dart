import 'package:flutter/material.dart';

class CustomConditionsPage extends StatelessWidget {
  const CustomConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // FIXME: textos
      appBar: AppBar(
        title: Text('Custom Conditions'),
      ),
      body: SafeArea(
        child: Center(
          child: Text('Custom Conditions Page'),
        ),
      ),
    );
  }
}
