import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/people_list.dart';
import '../models/people.dart';
import '../models/films.dart';
import '../services/fetch_service.dart';
import '../utils/swapi_routes.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isCached = false;

  List<Films> films = [];

  Future<List<Films>> loadFilms(List<String> url) async {
    final List<Films> films = [];

    for (var i = 0; i < url.length; i++) {
      final film = await FetchService().getSpecificFilm(url[i]);
      if (film != null) {
        films.add(film);
      }
    }

    return films;
  }

  Widget _createSectionTitle(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _createSectionContainer(Widget child) {
    return Container(
      width: 300,
      height: 200,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: child,
    );
  }

  Widget _createCardDetail(String text) {
    return Card(
      color: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5, 
          horizontal: 10
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      )
    );
  }

  Widget _createPeopleInfo(BuildContext context, People person) {
    return Column(
      children: [
        _createSectionTitle(context, 'General Details'),
        _createSectionContainer(
          SingleChildScrollView(
            child: Column(children: <Widget>[
                _createCardDetail('Height: ${person.height}cm'),
                const Divider(),
                _createCardDetail('Mass: ${person.mass}kg'),
                const Divider(),
                _createCardDetail('Gender: ${person.gender}'),
                const Divider(),
                _createCardDetail('Birth Year: ${person.birthYear}'),
                const Divider(),
                _createCardDetail('Hair Color: ${person.hairColor}'),
                const Divider(),
                _createCardDetail('Skin Color: ${person.skinColor}'),
              ]
            ),
          )
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final pplClass = Provider.of<PeopleList>(context, listen: false);
    
    // Caching manager
    final cached = pplClass.cachedPeople;
    final person = ModalRoute.of(context)!.settings.arguments as People;
    
    if (cached.isNotEmpty) {
      final cacheList = [];
      for (var map in cached) {
        final mapPerson = map['person'] as People;
        cacheList.add(mapPerson.name);
      }

      if (!cacheList.contains(person.name)) {
        loadFilms(person.films).then((loadedFilms) {
          pplClass.postAndCache(person, loadedFilms);
          cacheList.add(person.name);
          cached.add({'person': person, 'films': loadedFilms});
        });
      }

      for (var i = 0; i < cacheList.length; i++) {
        if (cacheList[i] == person.name) {
          setState(() {
            isCached = true;
            films = cached[i]['films'] as List<Films>;
          });
        }
      }
    } else {
      loadFilms(person.films).then((loadedFilms) {
        pplClass.postAndCache(person, loadedFilms);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    final pplClass = Provider.of<PeopleList>(context);
    final person = ModalRoute.of(context)!.settings.arguments as People;
    final favPeopleSet = pplClass.toggleFavorite;
    final isFavorite = pplClass.isFavorite(person);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(
          child: Text(
            'Details for ${person.name}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondary
            ),
          )
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              alignment: Alignment.center,
              child: Image.network(
                '${SWAPIRoutes.peopleImgAPI}${person.id}.jpg',
                fit: BoxFit.contain,
              ),
            ),
            isCached 
            ? Column(
              children: [
                _createSectionTitle(context, 'Films'),
                _createSectionContainer(
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      return _createCardDetail(films[index].title);
                    },
                    itemCount: films.length,
                  ),
                ),
                _createPeopleInfo(context, person)
              ],
            )
            : FutureBuilder<List<Films>>(
              future: loadFilms(person.films),
              builder: (BuildContext context, AsyncSnapshot<List<Films>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      _createSectionTitle(context, 'Films'),
                      _createSectionContainer(
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (ctx, i) {
                            return Column(
                              children: <Widget>[
                                _createCardDetail(snapshot.data![i].title),
                                const Divider(),
                              ],
                            );
                          }
                        ),
                      ),
                      _createPeopleInfo(context, person)
                    ]
                  );
                }
              }
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            favPeopleSet(
              person
            );
          });
        },
        child: Icon(
          isFavorite
          ? Icons.star
          : Icons.star_border,
          color: Theme.of(context).primaryColor
        ),
      ),
    );
  }
}