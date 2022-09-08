import 'package:flutter/material.dart';
import '../models/people.dart';
import '../components/person_item.dart';
import '../components/options.dart';
import '../services/fetch_service.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  bool? isLoaded = false;
  bool? canUpdate = false;
  final searchController = TextEditingController();
  Getter? info;
  List<People>? ppl; 
  String? filter;

  @override
  void initState() {
    super.initState();

    getData();
  }

  void _handleSearch(List<People>? arg, Getter? getter, String? name) async {
    setState(() {
      ppl = arg;
      info = getter;
      filter = name;
      canUpdate = true;
    }); 
  }

  void getData() async {
    final data = await FetchService().getPeople();
    if (data != null) {
      setState(() {
        isLoaded = true;
        info = data;
        ppl = data.results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Center(child: Text('SWAPI People')),
        actions: <Widget>[
          if (isLoaded != null && isLoaded == true)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) => Column(
                    children: <Widget>[
                      Options(onSearch: _handleSearch, info: info!),
                    ]
                  ),
                );
              },
            ),
        ]
      ),
      body:
        GridView(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          children: <Widget>[
            if (isLoaded != null && isLoaded == true)
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