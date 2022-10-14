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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return favPeople.isEmpty
    ? const Center(
        child: Text('No favorites yet'),
      )
    : Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: favPeople.length,
              itemBuilder: (ctx, i) => SizedBox(
                height: height * 0.20,
                width: width * 0.20,
                child: Column(
                  children: [
                    Flexible(
                      child: PersonItem(
                        person: favPeople[i]
                      ),
                    ),
                    const Divider()
                  ],
                )
              ),
            ),
          ),
        ],
      );
  }
}