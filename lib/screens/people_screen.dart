import 'package:flutter/material.dart';
import '../models/people.dart';
import '../components/person_item.dart';
import '../services/fetch_service.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  bool isLoaded = false;
  List<People>? ppl; 

  @override
  void initState() {
    super.initState();

    getData();
  }

  void getData() async {
    final data = await FetchService().getPeople();
    if (data != null) {
      setState(() {
        isLoaded = true;
        ppl = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Center(child: Text('SWAPI People')),
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: <Widget>[
          if (isLoaded)
            for (var i = 0; i < ppl!.length; i++)
              PersonItem(
                person: ppl![i],
              )
          else
            const Text('Loading...')
        ]
      ),
    );
  }
}