part of firefirestyle.html.page;

abstract class ToolbarItem {
  html.Element makeElement(String id, String className);
  Map<String, ToolbarItem> toUrlItem() {
    return {};
  }
}

class ToolbarItemMulti extends ToolbarItem {
  List<ToolbarItemSingle> items = [];
  String label = "";
  String id = "";

  ToolbarItemMulti(this.label, this.id, this.items) {}

  html.Element makeElement(String ida, String className) {
    var ret = new html.Element.html(["""<div ><div id="${id}" style="width:100%;">${label}<div><div id="${"${id}cont"}" style="display:hide;"></div></div>"""].join(), treeSanitizer: html.NodeTreeSanitizer.trusted);
    var retCont = ret.querySelector("#${id}cont");
    items.forEach((v) {
      retCont.children.add(v.makeElement(ida, className));
    });
    ret.querySelector("#${id}").onClick.listen((ev){
      if(retCont.style.display == "block") {
        retCont.style.display = "none";
      } else {
        retCont.style.display = "block";
      }
    });
    return ret;
  }

  Map<String, ToolbarItem> toUrlItem() {
    Map<String, ToolbarItemSingle> ret = {};
    items.forEach((v) {
      ret[v.url] = v;
    });
    return ret;
  }
}

class ToolbarItemSingle extends ToolbarItem {
  String url;
  String label;
  ToolbarItemSingle(this.label, this.url) {}
  html.Element makeElement(String id, String className) {
    return new html.Element.html(["""<a href="${url}" id="${id}" class="${className}"> ${label} </a>"""].join(), treeSanitizer: html.NodeTreeSanitizer.trusted);
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
  ToolbarItem rightItem = new ToolbarItemSingle("(-_-)", "");
  Map<String, html.Element> elms = {};

  String rootId;
  String mode = "_humberger";
  static const String modeHumberger = "_humberger";
  static const String modeTab = "_tab";

  Toolbar(this.rootId, {this.mode: modeHumberger}) {
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
    //::selectio
    //  var e = elm[html.window.location.hash];
  }

  bakeContainer({needMakeRoot: false}) {
    html.Element rootElm = html.document.body;
    if (rootId != null) {
      rootElm = html.document.body.querySelector("#${rootId}");
    }
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
          """<div id="${navigatorId+"hum-close"}" class="${navigatorItemId+mode}" style="display:${mode==modeHumberger?"block":"hide"}">X</div>""", //
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
    navigatorRight.children.add(rightItem.makeElement("", """${navigatorItemId+mode}"""));
  }

  updateLeft({needMakeRoot: false}) {
    html.Element rootElm = html.document.body;
    if (rootId != null) {
      rootElm = html.document.body.querySelector("#${rootId}");
    }
    var navigatorLeft = rootElm.querySelector("#${navigatorLeftId}");
    navigatorLeft.children.clear();
    for (int i = 0; i < leftItems.length; i++) {
      var item = leftItems[i].makeElement("", "${navigatorItemId+mode}");
      navigatorLeft.children.add(item);

      leftItems[i].toUrlItem().forEach((k, ToolbarItem v) {
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
