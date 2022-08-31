import 'package:flutter/material.dart';
import 'models/people.dart';
import 'services/fetch_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoaded = false;
  List<Result>? ppl; 

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
        title: Text(widget.title),
      ),
      body: isLoaded 
      ? ListView.builder(
          itemCount: ppl?.length,
          itemBuilder: (ctx, i) {
            return Text('Hi ${ppl![i].name}');
          }
      )
      : const Text('Loading..')
    );
  }
}
