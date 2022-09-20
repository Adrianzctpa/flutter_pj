import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pages_provider.dart';
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
  void _handlePage(int num, String id, BuildContext context) async {
    final pagesProvider = Provider.of<PagesProvider>(context, listen: false);

    int prevPage = pagesProvider.previousPage;
    int nextPage = pagesProvider.nextPage;

    pagesProvider.setDisableState(true);
 
    Getter? data;  

    data = pagesProvider.filter == '' || id == 'home'
    ? await FetchService().getPeopleByPage(num)
    : await FetchService().getPeopleByPage(num, pagesProvider.filter);

    switch (id) {
      case 'next':
        pagesProvider.setPages(prevPage+1, nextPage+1);
        break;
      case 'previous': 
        pagesProvider.setPages(prevPage-1, nextPage-1);
        break;
      case 'home':
        pagesProvider.setPages(0, 2);
        pagesProvider.setFilter('');
        break;   
    }

    if (data != null) {
      widget.updState(data.results as List<People>, data);
    } else {
      pagesProvider.setPages(prevPage, nextPage + pagesProvider.getter.count);
    }

    pagesProvider.setDisableState(false);
  }

  @override
  void initState() {
    super.initState();

    final pagesProvider = Provider.of<PagesProvider>(context, listen: false);
    pagesProvider.handlePageLoad(pagesProvider.getter.previous, pagesProvider.getter.next);
  }

  @override
  Widget build(BuildContext context) {
    final pagesProvider = Provider.of<PagesProvider>(context);
    int previousPage = pagesProvider.previousPage;
    int nextPage = pagesProvider.nextPage;
    final isDisabled = pagesProvider.isDisabled;

    return Stack(
      children: <Widget>[
        if (pagesProvider.pages != 0)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.arrow_back),
              onPressed: isDisabled || !pagesProvider.shouldPreviousPageBeEnabled
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
              onPressed: isDisabled || !pagesProvider.shouldNextPageBeEnabled
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