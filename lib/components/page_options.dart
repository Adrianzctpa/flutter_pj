import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/fetch_service.dart';
import '../models/pages_provider.dart';
import '../models/people.dart';
import '/components/pages.dart';

class PageOptions extends StatefulWidget {
  const PageOptions({required this.onSearch, Key? key}) : super(key: key);

  final void Function(List<People>, Getter) onSearch;

  @override
  State<PageOptions> createState() => _OptionsState();
}

class _OptionsState extends State<PageOptions> {
  final searchController = TextEditingController();

  void _handleSearch() async {
    final String name = searchController.text;
    final pageProvider = Provider.of<PagesProvider>(context, listen: false);
    pageProvider.setDisableState(true);
    pageProvider.setFilter(name);
  
    final data = name.isNotEmpty 
    ? await FetchService().getPeopleByName(name)
    : await FetchService().getPeople();

    if (data!.count > 10) {
      pageProvider.setPages(0,2);
    } else {
      pageProvider.setPages(0,0);
    }

    widget.onSearch(data.results as List<People>, data);
    pageProvider.setDisableState(false);
  }


  @override
  Widget build(BuildContext context) {
    final TextField searcher = TextField(
      maxLength: 50,
      controller: searchController,
      onSubmitted: (_) =>_handleSearch(),
      obscureText: false,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        labelStyle: const TextStyle(color: Colors.white), 
        labelText: 'Name',
      ),
      style: const TextStyle(
        color: Colors.white70,
      )
    );

    final ElevatedButton btn = ElevatedButton(
      onPressed: () => _handleSearch,
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        textStyle: const TextStyle(
          fontSize: 20, 
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        side: BorderSide(
          width: 1.0,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      child: Text(
        'Search', 
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary
        )
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          searcher,
          const SizedBox(height: 10),
          btn,
          Pages(           
            updState: widget.onSearch, 
          ),
        ],
      ),
    );
  }
}