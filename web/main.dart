library firestylesite;


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
