import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/people_list.dart';
import '../components/person_item.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    final favPeople = Provider.of<PeopleList>(context).favPeople;

    if (favPeople.isEmpty) {
      return const Center(
        child: Text('No saved people!'),
      );
    } else {
      return ListView.builder(
        itemCount: favPeople.length,
        itemBuilder: (ctx, index) {
          return PersonItem(
            person: favPeople[index],
          );
        },
      );
    }
  }
}