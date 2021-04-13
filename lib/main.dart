import 'package:flutter/material.dart';
//da acesso aos widgets dart e aos Widgets Material Theme
import 'package:english_words/english_words.dart';
//biblioteca para gerar os nomes

// o método main() é o ponto de entrada da aplicação
//void main() executa a aplicação
//runApp() usar qualquer widget como um argumento
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //método build é chamado para inserir o widget na árvore de widgets
    return MaterialApp(
      title: 'Startup Name Flutter',
      theme: ThemeData(
        primaryColor: Colors.pink,
      ),
      home: RandomWords(),
    );
  }
}
//Stateless widgets are immutable, meaning that their properties can’t change—all values are final.
// Stateful widgets maintain state that might change during the lifetime of the widget. Implementing a stateful widget requires at least two classes: 1) a StatefulWidget class that creates an instance of 2) a State class. The StatefulWidget class is, itself, immutable and can be thrown away and regenerated, but the State class persists over the lifetime of the widget.

//start typing stful:
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  //combinação entre duas palavras (primeira e segunda)
  final _saved = <WordPair>{};
  final _biggerFont = TextStyle(fontSize: 18.0);
  @override //edita uma função na sua classe mãe
  Widget build(BuildContext context) {
    //o método build retorna um Scaffold que é uma estrutura básica de layout widget material desing
    return Scaffold(
      appBar: AppBar(
        //appBar é um atributo que recebe um objeto AppBar que possui os atributos title e body
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }
  //   The itemBuilder callback is called once per suggested word pairing, and places each suggestion into a ListTile row. For even rows, the function adds a ListTile row for the word pairing. For odd rows, the function adds a Divider widget to visually separate the entries. Note that the divider might be difficult to see on smaller devices.
  // Add a one-pixel-high divider widget before each row in the ListView.
  // The expression i ~/ 2 divides i by 2 and returns an integer result. For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2. This calculates the actual number of word pairings in the ListView, minus the divider widgets.
  // If you’ve reached the end of the available word pairings, then generate 10 more and add them to the suggestions list.
  // The _buildSuggestions() function calls _buildRow() once per word pair. This function displays each new pair in a ListTile, which allows you to make the rows more attractive in the next step.

  //widget que constrói e estiliza as linhas
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        //  In Flutter's reactive style framework, calling setState() triggers a call to the build() method for the State object, resulting in an update to the UI
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    //pushes the route to navigator's stack
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final tiles = _saved.map(
        (WordPair pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        },
      );
      final divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text('Saved Suggestions'),
        ),
        body: ListView(children: divided),
      );
    }));
  }
}
