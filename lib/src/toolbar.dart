part of firefirestyle.html.page;


class ToolbarItem {
  String url;
  String label;
  ToolbarItem(this.label, this.url) {}
}

class Toolbar extends Page {
  String navigatorId = "fire-navigation";
  String navigatorRightId = "fire-navigation-right";
  String navigatorLeftId = "fire-navigation-left";
  String contentId = "fire-content";
  String footerId = "fire-footer";
  String navigatorItemId = "fire-naviitem";

  List<ToolbarItem> leftItems = [];
  ToolbarItem rightItem = new ToolbarItem("(-_-)", "");
  Map<String, html.Element> elms = {};

  String rootId;
  Toolbar(this.rootId) {
    html.window.onHashChange.listen((html.Event ev) {
      onHashChange();
    });
  }

  void addLeftItem(ToolbarItem item) {
    print(">> ${item.label} : ${item.url}");
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
    if (rootId != null){
      rootElm = html.document.body.querySelector("#${rootId}");
    }
    if (needMakeRoot) {
      rootElm.children.clear();
      rootElm.appendHtml(
          [
            """<div id=${navigatorId} class="${navigatorId}"> </div>""", //
            """<div id=${contentId} class="${contentId}"> </div>""", //
            """<div id=${footerId} class="${footerId}"> </div>""",
          ].join("\r\n"), //
          treeSanitizer: html.NodeTreeSanitizer.trusted);
    }
    //
    var navigator = rootElm.querySelector("#${navigatorId}");
    navigator.children.clear();
    navigator.appendHtml(
        [
          """<div id=${navigatorLeftId} class="${navigatorLeftId}"> </div>""",
          """<div id=${navigatorRightId} class="${navigatorRightId}"> </div>""", //
        ].join("\r\n"),
        treeSanitizer: html.NodeTreeSanitizer.trusted);
  }

  updateRight({needMakeRoot: false}) {
    html.Element rootElm = html.document.body;
    if (rootId != null){
      rootElm = html.document.body.querySelector("#${rootId}");
    }
    var navigatorRight = rootElm.querySelector("#${navigatorRightId}");
    navigatorRight.children.clear();
    navigatorRight.appendHtml("""<a href="${rightItem.url}" style="right:100;" class="${navigatorItemId}">${rightItem.label}</a>""", treeSanitizer: html.NodeTreeSanitizer.trusted);
  }

  updateLeft({needMakeRoot: false}) {
    html.Element rootElm = html.document.body;
    if (rootId != null){
      rootElm = html.document.body.querySelector("#${rootId}");
    }
    var navigatorLeft = rootElm.querySelector("#${navigatorLeftId}");
    navigatorLeft.children.clear();
    for (int i = 0; i < leftItems.length; i++) {
      var item = new html.Element.html("""<a href="${leftItems[i].url}" id="${navigatorItemId}" class="${navigatorItemId}"> ${leftItems[i].label} </a>""", treeSanitizer: html.NodeTreeSanitizer.trusted);
      navigatorLeft.children.add(item);
      elms[leftItems[i].url] = item;
      item.onClick.listen((e) {
        for (var ee in elms.values) {
          ee.classes.clear();
          if (item != ee) {
            ee.classes.add("${navigatorItemId}");
          } else {
            ee.classes.add("${navigatorItemId}-checked");
          }
        }
      });
    }
  }

  bake({needMakeRoot: false}) {
//    html.Element rootElm = html.document.body;
//    if (rootId != null){
//      rootElm = html.document.body.querySelector("#${rootId}");
//    }
    bakeContainer(needMakeRoot: needMakeRoot);
    //
    updateRight(needMakeRoot: needMakeRoot);
    //
    updateLeft(needMakeRoot: needMakeRoot);
  }
}
