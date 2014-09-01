part of fantasy_draft_app;

class Position {
  int id;
  String name;
  
  static final Position RB = new Position(20, "RB");
  static final Position QB = new Position(10, "QB");
  static final Position WR = new Position(30, "WR");
  static final Position DEF = new Position(99, "DEF");
  static final Position K = new Position(80, "K");
  static final Position TE = new Position(40, "TE");
  static final Position ALL = new Position(0, "ALL");
  static final Position UNKNOWN = new Position(1, "UNKNOWN");
  
  static final List<Position> all = [ALL, QB, RB, WR, /*DEF, K, */TE];
  
  Position(this.id, this.name);
  
  factory Position.fromJson(String json) {
    Map values = new JsonDecoder().convert(json);
    return new Position(values['id'], values['name']);
  }
  
  factory Position.fromString(String name) {
    switch(name) {
      case "QB": return QB;
      case "RB": return RB;
      case "WR": return WR;
      case "DEF": return DEF;
      case "K": return K;
      case "TE": return TE;
    }
    return UNKNOWN;
  }
  
  Map toJson() => {'id': id, 'name': name};
}