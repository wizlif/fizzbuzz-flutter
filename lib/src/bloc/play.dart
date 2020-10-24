import 'package:dash/dash.dart';
import 'package:fizzbuzz/src/models/JoinResponse.dart';
import 'package:fizzbuzz/src/models/session.dart';
import 'package:fizzbuzz/src/resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class PlayBloc implements Bloc {
  static Bloc instance() => PlayBloc();

  final _loading = BehaviorSubject<bool>();

  Stream<bool> get loading => _loading.stream;

  Function(bool) get setLoading => _loading.sink.add;

  List<GameSession> _gameSessions = [];
  final _sessions = BehaviorSubject<List<GameSession>>();

  Stream<List<GameSession>> get sessions => _sessions.stream;

  Function(List<GameSession>) get setGameSessions => _sessions.sink.add;

  final _id = BehaviorSubject<int>();

  Stream<int> get id =>_id.stream;

  Function(int) get setId => _id.sink.add;

  final _error = BehaviorSubject<String>();

  Stream<String> get error =>_error.stream;

  Function(String) get setError => _error.sink.add;



  int user_id;

  Future joinGame() async {
    try {
      JoinResponse _joinResponse = await API.joinGame();
      user_id = _joinResponse.username;
      setId(user_id);
      _gameSessions = _joinResponse.previousSessions;
      setGameSessions(_gameSessions);
    } catch (e) {
      setError(e.toString());
      return Future.error(e);
    }
  }

  Future play(String guess) async {
    try {
      GameSession _playResponse = await API.play(user_id, guess);
      _gameSessions.add(_playResponse);
      setGameSessions(_gameSessions);
    } catch (e) {
      setError(e.toString());
      return Future.error(e);
    }
  }

  Future querySessions() async{
    try {
      List<GameSession> _sessionsResponse = await API.fetchPreviousSessions();
      _gameSessions = _sessionsResponse;
      setGameSessions(_gameSessions);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  dispose() {
    _loading.close();
    _sessions.close();
    _id.close();
    _error.close();
  }
}
