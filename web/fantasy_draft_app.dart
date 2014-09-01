library fantasy_draft_app;

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:polymer/polymer.dart';
import 'package:observe/observe.dart';

part 'player.dart';
part 'position.dart';

@CustomTag('fantasy-draft-app')
class FantasyDraftApp extends PolymerElement {
  @PublishedProperty(reflect: true)
  String selected = Position.QB.id.toString();
  
  Map<String, int> scrollPositions = {};
  
  List<String> draftedPlayerLinks = toObservable([]);
  
  @published List<Player> players = toObservable([]);
  
  bool willSavePlayers = false;
  
  FantasyDraftApp.created() : super.created() {
    print('app created');
  }
  
  ready() {
    html.Storage localStorage = html.window.localStorage;
    if (localStorage['players'] != null) {
      loadPlayersFromData(new JsonDecoder().convert(localStorage['players']));
    } else {
      html.HttpRequest
          .getString('https://www.kimonolabs.com/api/1tjsl89k?apikey=BQSDvFMARhaQSATr0pYoFtLpZ5AxVwuv')
          .then((data) {
            loadPlayersFromData(new JsonDecoder().convert(data)['results']['collection1']);
            if (players == null || players.isEmpty) return;
            html.window.localStorage['players'] = new JsonEncoder().convert(players);
          });
    }

    for (Player player in players) {
      player.changes.listen((_) {
        if (willSavePlayers) return;
        willSavePlayers = true;
        new Future(() {savePlayers();});
      });
    };
  }
  
  savePlayers() {
    willSavePlayers = false;
    if (players == null || players.isEmpty) return;
    html.window.localStorage['players'] = new JsonEncoder().convert(players);
    print('saved players!');
  }
  
  loadPlayersFromData(List<Map> playerDataList) {
    var allPlayers = [];
    try {
      playerDataList.forEach((playerData) {
        try {
          var player = new Player.fromNFLObject(playerData);
          if (allPlayers.any((p) => p.link == player.link)) return;
          allPlayers.add(player);
        } catch(e) {
          print(e);
        }
      });
      print("${allPlayers.length} players found");
      allPlayers.sort((a, b) => (b.fantasyPts - a.fantasyPts).floor());
      players = toObservable(allPlayers);
    } catch(e) {
      html.window.alert('$e');
    }
  }
  
  selectedChanged(oldValue, newValue) {
    $['pages'].querySelector('players-page[name="$newValue"]').refresh();
//    if (oldValue == null) return;
//    scrollPositions[oldValue]= $['pages'].scrollTop;
//    
//    var restorePos = scrollPositions[newValue];
//    if (restorePos != null) {
//      $['pages'].scrollTop = restorePos;
//    } else {
//      $['pages'].scrollTop = 0;
//    }
  }
  
//  @ComputedProperty("playersForPosition(position, players)")
//  List<Player> playersForPosition(Position position, List<Player> players) => toObservable(
//      players.where((player) => position == Position.ALL || player.position == position).toList());
  
  List<Position> get positions => Position.all;
}
