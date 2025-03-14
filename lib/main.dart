import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(PokemonApp());
}

class PokemonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PokemonListScreen(),
    );
  }
}

class PokemonListScreen extends StatefulWidget {
  @override
  _PokemonListScreenState createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  List<dynamic> cards = [];

  @override
  void initState() {
    super.initState();
    fetchPokemonCards();
  }

  Future<void> fetchPokemonCards() async {
    final response = await http.get(Uri.parse('https://api.pokemontcg.io/v2/cards'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        cards = data['data'];
      });
    } else {
      throw Exception('Failed to load Pokémon cards');
    }
  }

  void showFullImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pokémon Cards')),
      body: cards.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return ListTile(
            leading: GestureDetector(
              onTap: () => showFullImage(card['images']['small']),
              child: Image.network(card['images']['small'], width: 50, height: 50),
            ),
            title: Text(card['name']),
          );
        },
      ),
    );
  }
}
