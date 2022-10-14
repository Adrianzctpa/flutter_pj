import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/people_list.dart';
import '../models/people.dart';
import '../utils/app_routes.dart';
import '../utils/swapi_routes.dart';

class PersonItem extends StatelessWidget {
  const PersonItem({required this.person, Key? key}) : super(key: key);

  final People person;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<PeopleList>(
              builder: (ctx, pplClass, _) => IconButton(
                onPressed: () {
                  pplClass.toggleFavorite(person);
                },
                icon: Icon(
                    pplClass.isFavorite(person) ? Icons.star : Icons.star_border),
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            title: Text(
              person.name,
              textAlign: TextAlign.center,
            ),
          ),
          child: GestureDetector(
            child: Hero(
              tag: person.id,
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/placeholder-image.png'),
                image: NetworkImage('${SWAPIRoutes.peopleImgAPI}${person.id}.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.personDetails, 
                arguments: person
              );
            },
          ),
        ),
      );
    }
}