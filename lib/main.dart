import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '決められないのかい？',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        accentColor: Colors.blueGrey,
        primaryColor: Colors.cyan,
        backgroundColor: Color(0xfff0f0f0),
        fontFamily: "NotoSansJP",
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        Locale("ja","JP"),
      ],
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String selected;

  List<String> selectionList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("ルーレット"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Container(
              height: 100,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Text(
                    selected ?? "選択されていません",
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text("選ぶ", style: TextStyle(color: Colors.white),),
                onPressed: selectionList.length == 0 ? null : () {
                  if(selectionList.length > 0) {
                    setState(() {
                      selected = selectionList.random();
                    });
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: selectionList.indexedMap((i,s) => selectionCard(i, s))..add(
                  OutlineButton(
                    child: Text("+ 追加"),
                    borderSide: BorderSide(color: Theme.of(context).accentColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    onPressed: () {
                      setState(() {
                        selectionList.add("");
                        _focusedIndex = selectionList.length - 1;
                      });
                    },
                  )
              ),
            ),
          ),
        ],
      )
    );
  }
  int _focusedIndex;


  Widget selectionCard(int index, String title) {

    return Dismissible(
      key: UniqueKey(),
      //key: Key(uuid.v4()),
      confirmDismiss: (d) async => true,
      onDismissed: (d) {
        setState(() {
          _focusedIndex = null;
          selectionList.removeAt(index);
        });
      },
      child: new Card(
        child: ListTile(
          title: _focusedIndex == index
              ? editCard(index, title)
              : Text(title),
          onTap: () {
            setState(() {
              _focusedIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget editCard(int index, String title) {
    String editing = title;

    return Row(
      children: <Widget>[
        Expanded(
          child: new TextFormField(
            initialValue: title,
            onChanged: (text) {
              print(text);
              editing = text;
            },
            autofocus: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (text) {
              setState(() {
                selectionList[index] = editing;
              });
              _focusedIndex = null;
            },
          ),
        ),
        RaisedButton(
          child: const Text("確定"),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            setState(() {
              selectionList[index] = editing;
            });
            _focusedIndex = null;
          },
        )
      ],
    );
  }
}

extension Indexmapper on List<String> {
  List<E> indexedMap<E>(E function(int index, String item)) {
    List<E> res = [];
    for(int i = 0; i < this.length; i++) {
      res.add(function(i, this[i]));
    }
    return res;
  }

  String random() {
    final _rand = Random();
    return this[_rand.nextInt(this.length)];
  }
}
