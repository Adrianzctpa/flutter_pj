import 'package:flutter/material.dart';
import '../models/people.dart';
import '../services/fetch_service.dart';

class Pages extends StatefulWidget {

  const Pages({
    required this.info, 
    required this.updState,
    required this.filter, 
    Key? key}) : super(key: key);

  final Getter info;
  final String? filter;
  final void Function(List<People>?, Getter?, String?) updState;

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  static const int minItemsForPage = 10;
  bool isDisabled = false;
  int nextPage = 2;
  int previousPage = 0;

  int get _pages {
    if (widget.info.count > minItemsForPage) {
      return (widget.info.count / minItemsForPage).ceil();
    } else {
      return 0;
    }
  }

  bool get _shouldNextPageBeEnabled {
    final int currentPage = nextPage - 1;
    final bool canIncrement = (currentPage + 1) <= _pages;
    final bool canIncrementPrevious = (previousPage + 1) < _pages;

    if (canIncrement && canIncrementPrevious) {
      return true;
    } 

    return false;
  }

  bool get _shouldPreviousPageBeEnabled {
    final bool canDecrement = (previousPage - 1) >= 0;

    if (canDecrement) {
      return true;
    } 

    return false;
  }

  void _handlePage(int num, String id) async {
    setState(() {
      isDisabled = true;
    });
    
    final data = widget.filter == null 
    ? await FetchService().getPeopleByPage(num)
    : await FetchService().getPeopleByPage(num, widget.filter as String);
    
    debugPrint('$_pages');

    if (data != null) {
      setState(() {
        widget.updState(data.results, data, widget.filter);

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
      });
    } else {
      setState(() {
        nextPage = widget.info.count + 1;
      });
    }

    setState(() {
      isDisabled = false;
    });
  }

  void _handlePageLoad(String? prev, String? next) {
    if (next == null) {
      setState(() {
        nextPage = widget.info.count + 1;
      });
    }

    if (prev != null) {
      final uri = Uri.parse(prev);
      final int id = int.parse(uri.queryParameters['page'] as String) + 1;
      
      if ((id + 1) <= _pages && _pages != 0)  {
        setState(() {
          nextPage = id + 1;
          previousPage = id - 1;
        });
      }
    }
  }

  @override 
  void initState () {
    super.initState();

    _handlePageLoad(widget.info.previous, widget.info.next);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (_pages != 0)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.arrow_back),
              onPressed: isDisabled || !_shouldPreviousPageBeEnabled
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
              onPressed: isDisabled || !_shouldNextPageBeEnabled
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