import 'package:flutter/material.dart';
import '../models/people.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final person = ModalRoute.of(context)!.settings.arguments as People;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Center(
        child: Text(person.name),
      ),
    );
  }
}