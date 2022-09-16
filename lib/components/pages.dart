import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/people_list.dart';
import '../models/people.dart';
import '../services/fetch_service.dart';

class Pages extends StatefulWidget {

  const Pages({
    required this.updState,
    Key? key}) : super(key: key);

  final void Function(List<People>, Getter) updState;

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  bool isDisabled = false;

  void _handlePage(int num, String id, BuildContext context) async {
    final pplClass = Provider.of<PeopleList>(context, listen: false);

    int prevPage = pplClass.previousPage;
    int nextPage = pplClass.nextPage;

    setState(() {
      isDisabled = true;
    });
    
    Getter? data;  

    data = pplClass.filter == '' || id == 'home'
    ? await FetchService().getPeopleByPage(num)
    : await FetchService().getPeopleByPage(num, pplClass.filter);

    switch (id) {
      case 'next':
        pplClass.setPages(prevPage+1, nextPage+1);
        break;
      case 'previous': 
        pplClass.setPages(prevPage-1, nextPage-1);
        break;
      case 'home':
        pplClass.setPages(0, 2);
        pplClass.setFilter('');
        break;   
    }

    if (data != null) {
      widget.updState(data.results as List<People>, data);
    } else {
      pplClass.setPages(prevPage, nextPage + pplClass.getter.count);
    }

    setState(() {
      isDisabled = false;
    });
  }

  @override
  void initState() {
    super.initState();

    final pplClass = Provider.of<PeopleList>(context, listen: false);
    pplClass.handlePageLoad(pplClass.getter.previous, pplClass.getter.next);
  }

  @override
  Widget build(BuildContext context) {
    final pplClass = Provider.of<PeopleList>(context);
    int previousPage = pplClass.previousPage;
    int nextPage = pplClass.nextPage;

    return Stack(
      children: <Widget>[
        if (pplClass.pages != 0)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.arrow_back),
              onPressed: isDisabled || !pplClass.shouldPreviousPageBeEnabled
              ? null
              : () async {
                  _handlePage(previousPage, 'previous', context);
                }
            ),
          ),
          Align(
            child: IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.home),
              onPressed: isDisabled || previousPage <= 1
              ? null
              : () async {
                  _handlePage(1, 'home', context);
                }
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.arrow_forward),
              onPressed: isDisabled || !pplClass.shouldNextPageBeEnabled
              ? null
              : () async {
                  _handlePage(nextPage, 'next', context);
                }
            )
          ),
      ]
    );
  }
}