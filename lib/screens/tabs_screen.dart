import 'package:flutter/material.dart';
import '../models/people.dart';
import 'people_screen.dart';
import 'saved_screen.dart';
import '../components/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({required this.favoritePeople, Key? key}) : super(key: key);

  final List<People> favoritePeople;

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  List<Map<String, Object>>? _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
    {
      'title': 'People List',
      'screen': const PeopleScreen(),
    },
    {
      'title': 'Saved People',
      'screen': SavedScreen(favoritePeople: widget.favoritePeople),
    }
  ];
  }

  _selectScreen(int i) {
    setState(() {
      _selectedPageIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(child: Text(_screens?[_selectedPageIndex]['title'] as String)),
      ),
      drawer: const MainDrawer(),
      body: _screens?[_selectedPageIndex]['screen'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'People',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Saved',
          ),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedPageIndex,
        unselectedItemColor: Theme.of(context).colorScheme.onTertiary,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _selectScreen,
      ),
      );
  }
}