import 'dart:async';

import 'package:fizzbuzz/src/bloc/play.dart';
import 'package:fizzbuzz/src/bloc/provider.dart';
import 'package:fizzbuzz/src/helpers/Shapes.dart';
import 'package:fizzbuzz/src/models/session.dart';
import 'package:flutter/material.dart';

class FizzBuzz extends StatefulWidget {
  @override
  _FizzBuzzState createState() => _FizzBuzzState();
}

class _FizzBuzzState extends State<FizzBuzz> {
  final _bloc = $Provider.of<PlayBloc>();
  Timer _timer;

  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _bloc.joinGame();
    _timer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => _bloc.querySessions());
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: StreamBuilder<int>(
            stream: _bloc.id,
            builder: (context, snapshot) {
              return Text(snapshot.hasData
                  ? "FizzBuzz (${snapshot.data})"
                  : "FizzBuzz");
            }),
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder<List<GameSession>>(
              stream: _bloc.sessions,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    if (snapshot.hasData) {
                      List<GameSession> sessions = snapshot.data;
                      return ListView.separated(
                          separatorBuilder: (ctx, index) => Divider(),
                          itemBuilder: (ctx, index) {
                            GameSession session = sessions[index];
                            return ListTile(
                              title: Text(
                                  "User ${session.username}:${session.state}"),
                            );
                          },
                          itemCount: sessions.length);
                    } else {
                      return Center(
                        child: Text("Error ${snapshot.error}"),
                      );
                    }
                }
              }),
        ),
        StreamBuilder<String>(
            stream: _bloc.error,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                Future.delayed(Duration.zero,(){
                  _key.currentState.showSnackBar(SnackBar(content: Text("${snapshot.data}",),backgroundColor: Colors.red,));
                });
              }
                return Container();

            }),
        Row(
          children: [
            Expanded(
              child: FlatButton(
                onPressed: () {
                  _bloc.play("none");
                },
                child: Text(
                  "None",
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: Shapes.tiled,
              ),
            ),
            Container(
              width: 1,
            ),
            Expanded(
              child: FlatButton(
                onPressed: () {
                  _bloc.play("fizz");
                },
                child: Text(
                  "Fizz",
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: Shapes.tiled,
              ),
            ),
            Container(
              width: 1,
            ),
            Expanded(
              child: FlatButton(
                onPressed: () {
                  _bloc.play("buzz");
                },
                child: Text(
                  "Buzz",
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: Shapes.tiled,
              ),
            ),
            Container(
              width: 1,
            ),
            Expanded(
              child: FlatButton(
                onPressed: () {
                  _bloc.play("fizzbuzz");
                },
                child: Text(
                  "FizzBuzz",
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: Shapes.tiled,
              ),
            )
          ],
        ),
      ]),
    );
  }
}
