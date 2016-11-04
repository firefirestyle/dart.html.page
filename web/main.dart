library firestylesite;

import 'dart:html' as html;
import 'dart:async';

import 'package:firefirestyle.location/location.dart' as loc;
import 'package:firefirestyle.location/location_html.dart' as loc;
import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert' as conv;
import 'dart:typed_data' as typed;
import 'dart:math' as math;
//
import 'package:firefirestyle.html.page/page.dart' as page;

page.Toolbar toolBarObj = new page.Toolbar(null);

void main() {
  print("hello client");
  List<page.ToolbarItem> items = [];
  items.add(new page.ToolbarItemSingle("aa","ME A", "#/MeA"));
  items.add(new page.ToolbarItemSingle("bb","ME B", "#/MeB"));
  toolBarObj = new page.Toolbar(null)//
  ..addLeftItem(new page.ToolbarItemMulti(toolBarObj,"xxx", "xxx",items))//
//  ..addLeftItem(new page.ToolbarItemSingle("ME", "#/Me"))//
  ..addLeftItem(new page.ToolbarItemSingle("dd","Home", "#/Home"));
  toolBarObj.bake();
}
