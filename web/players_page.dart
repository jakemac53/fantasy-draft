import 'package:polymer/polymer.dart';
import 'package:core_elements/core_list_dart.dart';

import 'fantasy_draft_app.dart';

//typedef bool PlayerFilter(Player player);
  
@CustomTag('players-page')
class PlayersPage extends PolymerElement {
  @published Position position;
  @published List<Player> players;
  @observable List<Player> filteredPlayers = toObservable([]);
//  @published PlayerFilter filter;
  
  bool willRefresh = false;
  
  PlayersPage.created() : super.created() {
    print('players page created');
  }
  
  ready() {
    ($['player-list'] as CoreList).on['core-activate'].listen((e) {
      Player player = e.detail.data;
      player.drafted = !player.drafted;
      print('${player.name}: ${player.drafted}');
      refresh();
    });
  }
  
  playersChanged() {
    if (players == null) return;
    filteredPlayers.clear();
    players.forEach((player) {
      if (position != Position.ALL && player.position != position) return;
      filteredPlayers.add(player);
    });
  }
  
  refresh() {
    $['player-list'].refresh(true);
  }

//  static List<Player> filteredPlayers(
//      List<Player> players, [PlayerFilter filter]) =>
//          filter != null ? players.where(filter) : players;
}