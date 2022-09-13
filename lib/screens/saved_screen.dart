import 'package:flutter/material.dart';
import '../models/people.dart';
import '../components/person_item.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({required this.favoritePeople, Key? key}) : super(key: key);

  final List<People> favoritePeople;
  
  @override
  Widget build(BuildContext context) {
    if (favoritePeople.isEmpty) {
      return const Center(
        child: Text('No saved people!'),
      );
    } else {
      return ListView.builder(
        itemCount: favoritePeople.length,
        itemBuilder: (ctx, index) {
          return PersonItem(
            person: favoritePeople[index],
          );
        },
      );
    }
  }
}