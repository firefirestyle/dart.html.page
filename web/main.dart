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
  toolBarObj = new page.Toolbar(null)//
  ..addLeftItem(new page.ToolbarItem("ME", "#/Me"))//
  ..addLeftItem(new page.ToolbarItem("Home", "#/Home"));
  toolBarObj.bake();
}