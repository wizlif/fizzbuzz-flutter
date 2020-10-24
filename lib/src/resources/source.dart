import 'package:fizzbuzz/src/models/JoinResponse.dart';
import 'package:fizzbuzz/src/models/session.dart';

abstract class Source{
  // Fetch previous sessions
  Future<List<GameSession>> fetchPreviousSessions();

  // Join a game
  Future<JoinResponse> joinGame();

  // Play
  Future<GameSession> play(int id,String choice);
}