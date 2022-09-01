import 'package:flutter/material.dart';
import '../models/people.dart';

class PersonItem extends StatelessWidget {
  const PersonItem({required this.person, Key? key}) : super(key: key);

  final People person;

  void _selectScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/person-details', 
      arguments: person
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectScreen(context),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.onSecondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          person.name,
          style: Theme.of(context).textTheme.titleMedium,
        )
      ),
    );
  }
}