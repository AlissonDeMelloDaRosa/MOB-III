import 'package:flutter/material.dart';
import 'package:login/models/dog.dart';
import 'package:login/services/dogService.dart';

class DogPage extends StatefulWidget {
  const DogPage({super.key});

  @override
  State<DogPage> createState() => _DogPageState();
}

class _DogPageState extends State<DogPage> {
  final dogApi = DogService();
  late Future<Dog> _randomDog;
  @override
  void initState() {
    super.initState();
    _randomDog = _load();
  }

  Future<Dog> _load() async {
    final randomDog = await dogApi.getRandomDog();

    return randomDog;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Random Dog Generator')),
      body: FutureBuilder<Dog>(
        future: _randomDog,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(children: [CircularProgressIndicator()]),
            );
          }
          final dog = snapshot.data;
          return Center(
            child: Column(children: [Image(image: NetworkImage(dog!.message))]),
          );
        },
      ),
    );
  }
}
