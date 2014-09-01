import 'package:polymer/polymer.dart';

import 'fantasy_draft_app.dart';

@CustomTag('player-item')
class PlayerItem extends PolymerElement {
  @published Player player;
  
  PlayerItem.created() : super.created();
}