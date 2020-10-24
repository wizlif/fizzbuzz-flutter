class GameSession {
  int username;
  String state;

  GameSession({this.username, this.state});

  GameSession.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['state'] = this.state;
    return data;
  }
}