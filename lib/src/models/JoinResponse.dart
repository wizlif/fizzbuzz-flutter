import 'package:fizzbuzz/src/models/session.dart';

import 'session.dart';

class JoinResponse {
  int username;
  List<GameSession> previousSessions;

  JoinResponse({this.username, this.previousSessions});

  JoinResponse.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    previousSessions = json['sessions'].map<GameSession>((v) => GameSession.fromJson(v)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['sessions'] = this.previousSessions;
    return data;
  }
}