import 'package:flutter/material.dart';
import '../models/people.dart';
import '../services/fetch_service.dart';

class Pages extends StatefulWidget {
  const Pages({required this.info, required this.updState, Key? key}) : super(key: key);

  final Getter info;
  final void Function(List<People>?, Getter?) updState;

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  bool isDisabled = false;
  int nextPage = 2;
  int previousPage = 0;

  void _handlePage(int num, String id) async {
    setState(() {
      isDisabled = true;
    });
    
    final data = await FetchService().getPeopleByPage(num);
    if (data != null) {
      setState(() {
        widget.updState(data.results, data);

        switch (id) {
          case 'next':
            nextPage++;
            previousPage++;
            break;
          case 'previous': 
            nextPage--;
            previousPage--;
            break;
          case 'home':
            nextPage = 2;
            previousPage = 0; 
            break;   
        }

        debugPrint('$nextPage');
      });
    }

    setState(() {
      isDisabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int currentPage = nextPage - 1;

    const int minItemsForPage = 10;
    final int pages = widget.info.count > minItemsForPage 
    ? (widget.info.count / minItemsForPage).ceil()
    : 0;

    bool canDecrement = (previousPage - 1) >= 0;
    bool canIncrement = (currentPage + 1) <= pages && (previousPage + 1) < pages;

    return Stack(
      children: <Widget>[
        if (pages != 0)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.arrow_back),
              onPressed: isDisabled || !canDecrement
              ? null
              : () async {
                  _handlePage(previousPage, 'previous');
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
                  _handlePage(1, 'home');
                }
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.arrow_forward),
              onPressed: isDisabled || !canIncrement
              ? null
              : () async {
                  _handlePage(nextPage, 'next');
                }
            )
          ),
      ]
    );
  }
}