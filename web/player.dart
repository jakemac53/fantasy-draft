part of fantasy_draft_app;

class Player extends Observable {
  String name;
  String link;
  Position position;
  String team;
  int passingYards;
  int passingTds;
  int ints;
  int rushingYards;
  int rushingTds;
  int receivingYards;
  int receivingTds;
  double nflFantasyPts;
  @observable bool selected = false;
  @observable bool drafted = false;
  
  Player(this.name, this.link, this.position, this.team, this.passingYards, this.passingTds, 
      this.ints, this.rushingYards, this.rushingTds, this.receivingYards, this.receivingTds, 
      this.nflFantasyPts, this.drafted);
  
  factory Player.fromNFLObject(Map data) {
    return new Player(
        data['name']['text'], 
        data['name']['href'], 
        new Position.fromString(data['position']), 
        data['team'], 
        int.parse(data['passing_yards'], onError: (_) => 0),
        int.parse(data['passing_tds'], onError: (_) => 0),
        int.parse(data['ints'], onError: (_) => 0),
        int.parse(data['rushing_yards'], onError: (_) => 0),
        int.parse(data['rushing_tds'], onError: (_) => 0),
        int.parse(data['receiving_yards'], onError: (_) => 0),
        int.parse(data['receiving_tds'], onError: (_) => 0),
        double.parse(data['fantasy_points'], (_) => 0.0),
        (data['drafted'] == null) ? false : data['drafted']);
  }
  
  double get fantasyPts =>
      passingTds * 4 + ints * -2 + passingYards / 25 + rushingTds * 6 +
      rushingYards / 10 + receivingYards / 10 + receivingTds * 6;
      
  
  factory Player.fromJson(String json) {
    return new Player.fromNFLObject( new JsonDecoder().convert(json));
  }
  
  Map toJson() {
    return {
      'name': {
        'text': name,
        'href': link,
      },
      'position': position.name, 
      'team': team,
      'passing_yards': passingYards.toString(),
      'passing_tds': passingTds.toString(),
      'ints': ints.toString(),
      'rushing_yards': rushingYards.toString(),
      'rushing_tds': rushingTds.toString(),
      'receiving_yards': receivingYards.toString(),
      'receiving_tds': receivingTds.toString(),
      'fantasy_points': nflFantasyPts.toString(),
      'drafted': drafted,
    };
  }
}


//"name": {
//  "text": "Peyton Manning",
//  "href": "http://fantasy.nfl.com/players/card?leagueId=0&playerId=2501863"
//},
//"position": "QB",
//"team": "DEN",
//"passing_yards": "4882",
//"passing_tds": "44",
//"ints": "14",
//"rushing_yards": "-13",
//"rushing_tds": "1",
//"receiving_yards": "-",
//"receiving_tds": "-",
//"fantasy_points": "349.98"