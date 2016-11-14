part of firefirestyle.html.page;

abstract class ToolbarItem {
  bool isOpen = true;
  bool isChaild = false;
  html.Element makeElement(html.Element rootElm, String className);
  Map<String, ToolbarItem> toUrlItem() {
    return {};
  }
}

class ToolbarItemMulti extends ToolbarItem {
  List<ToolbarItemSingle> items = [];
  String label = "";
  String id = "";

  ToolbarItemMulti(this.label, this.id, this.items) {
    isOpen = false;
    for (var item in items) {
      item.isOpen = false;
      item.isChaild = true;
    }
  }

  html.Element makeElement(html.Element rootElm, String className) {
    var ret = new html.Element.html(["""<div id="${id}" class="${className}">${label}</div>""",].join(), treeSanitizer: html.NodeTreeSanitizer.trusted);
    ret.onClick.listen((ev) {
      for (var item in items) {
        var v = rootElm.querySelector("#${item.id}");
        if (v == null) {
          continue;
        }
        if (isOpen == false) {
          v.style.display = "block";
        } else {
          v.style.display = "none";
        }
      }
      isOpen = (isOpen == false ? true : false);
    });
    return ret;
  }

  Map<String, ToolbarItem> toUrlItem() {
    Map<String, ToolbarItem> ret = {};
    ret[id] = this;
    items.forEach((v) {
      ret[v.url] = v;
    });
    return ret;
  }
}

class ToolbarItemSingle extends ToolbarItem {
  String url;
  String label;
  String id;
  ToolbarItemSingle(this.id, this.label, this.url) {}
  html.Element makeElement(html.Element rootElm, String className) {
    return new html.Element.html(["""<a href="${url}" id="${id}" class="${className}" style="display:${(isOpen==false?"none":"block")}">${(isChaild==true?"&nbsp;":"")} ${label} </a>"""].join(), treeSanitizer: html.NodeTreeSanitizer.trusted);
  }

  Map<String, ToolbarItem> toUrlItem() {
    return {url: this};
  }
}

class Toolbar extends Page {
  String navigatorId = "fire-navigation";
  String navigatorRightId = "fire-navigation-right";
  String navigatorLeftId = "fire-navigation-left";
  String contentId = "fire-content";
  String footerId = "fire-footer";
  String navigatorItemId = "fire-naviitem";

  List<ToolbarItem> leftItems = [];
  ToolbarItem rightItem = new ToolbarItemSingle("right", "(-_-)", "");
  Map<String, html.Element> elms = {};

  String rootId;
  String mode = "_humberger";
  static const String modeHumberger = "_humberger";
  static const String modeTab = "_tab";
  bool hashChangeIsClose;
  Toolbar(this.rootId, {this.mode: modeTab, this.hashChangeIsClose: true}) {
    html.window.onHashChange.listen((html.Event ev) {
      onHashChange();
    });
  }

  void addLeftItem(ToolbarItem item) {
    leftItems.add(item);
  }

  void addRightItem(ToolbarItem item) {
    rightItem = item;
  }

  bool updateEvent(PageManager manager, PageManagerEvent event) {
    if (event == PageManagerEvent.startLoading) {
      for (var key in elms.keys) {
        elms[key].style.display = "none";
      }
    } else if (event == PageManagerEvent.stopLoading) {
      for (var key in elms.keys) {
        elms[key].style.display = "block";
      }
    }
    return true;
  }

  void onHashChange() {
    if (this.hashChangeIsClose == true) {
      html.Element rootElm = getRootElement();
      rootElm.querySelector("""#${navigatorId}""").style.transform = "translate(0px)";
    }
    //::selectio
    //  var e = elm[html.window.location.hash];
  }

  bakeContainer({needMakeRoot: false}) {
    html.Element rootElm = getRootElement();
    rootElm.children.clear();
    rootElm.appendHtml(
        [
          """<div id="${navigatorId+"hum"}" style="display:${mode==modeHumberger?"block":"hide"}">&#9776;</div>""", //
          """<div id=${navigatorId} class="${navigatorId+mode}">""",
          """</div>""",
        ].join("\r\n"), //
        treeSanitizer: html.NodeTreeSanitizer.trusted);
    rootElm.querySelector("""#${navigatorId+"hum"}""").onClick.listen((ev) {
      rootElm.querySelector("""#${navigatorId}""").style.transform = "translate(280px)";
    });
    var navigator = rootElm.querySelector("#${navigatorId}");
    navigator.children.clear();
    navigator.appendHtml(
        [
          """<div id="${navigatorId+"hum-close"}" class="${navigatorItemId+mode}" style="display:${mode==modeHumberger?"block":"none"}">X</div>""", //
          """<div id=${navigatorLeftId} class="${navigatorLeftId+mode}"> </div>""",
          """<div id=${navigatorRightId} class="${navigatorRightId+mode}"> </div>""", //
        ].join("\r\n"),
        treeSanitizer: html.NodeTreeSanitizer.trusted);
    rootElm.querySelector("""#${navigatorId+"hum-close"}""").onClick.listen((ev) {
      rootElm.querySelector("""#${navigatorId}""").style.transform = "translate(0px)";
    });
  }

  updateRight({needMakeRoot: false}) {
    html.Element rootElm = html.document.body;
    if (rootId != null) {
      rootElm = html.document.body.querySelector("#${rootId}");
    }
    var navigatorRight = rootElm.querySelector("#${navigatorRightId}");
    navigatorRight.children.clear();
    navigatorRight.children.add(rightItem.makeElement(getRootElement(), "${navigatorItemId+mode}" ""));
  }

  html.Element getRootElement() {
    html.Element rootElm = html.document.body;
    if (rootId != null) {
      rootElm = html.document.body.querySelector("#${rootId}");
    }
    return rootElm;
  }

  updateLeft({needMakeRoot: false}) {
    html.Element rootElm = getRootElement();
    var navigatorLeft = rootElm.querySelector("#${navigatorLeftId}");
    navigatorLeft.children.clear();
    for (int i = 0; i < leftItems.length; i++) {
      leftItems[i].toUrlItem().forEach((k, ToolbarItem v) {
//        var item = leftItems[i].makeElement("", "${navigatorItemId+mode}");
        var item = v.makeElement(getRootElement(), "${navigatorItemId+mode}");
        item.onClick.listen((e){
          onHashChange();
        });
        navigatorLeft.children.add(item);
        elms[k] = item;
        item.onClick.listen((e) {
          for (var ee in elms.values) {
            ee.classes.clear();
            if (item != ee) {
              ee.classes.add("${navigatorItemId+mode}");
            } else {
              ee.classes.add("${navigatorItemId}-checked${mode}");
            }
          }
        });
      });
    }
  }

  bake({needMakeRoot: false}) {
    bakeContainer(needMakeRoot: needMakeRoot);
    updateRight(needMakeRoot: needMakeRoot);
    updateLeft(needMakeRoot: needMakeRoot);
  }
}
