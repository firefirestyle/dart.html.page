part of firefirestyle.html.page;

enum PageManagerEvent { startLoading, stopLoading, }

class PageManager {
  static const int startLoading = 1;
  static const int stopLoading = 2;

  bool _isLoading = false;

  List<Page> pages = [];
  bool get isLoading => _isLoading;

  PageManager() {
    html.window.onHashChange.listen((_) {
      doLocation();
    });
  }

  void doLocation({Location locationInfo:null}) {
    if(locationInfo == null) {
      locationInfo = new HtmlLocation();
    }
    for (var page in pages) {
      page.updateLocation(this, locationInfo);
    }
  }


  void doEvent(PageManagerEvent ev) {
    if (ev == PageManagerEvent.startLoading) {
      _isLoading = true;
    } else if (ev == PageManagerEvent.stopLoading) {
      _isLoading = false;
    }

    for (var page in pages) {
      page.updateEvent(this, ev);
    }
  }

  bool assignLocation(String url) {
    if (_isLoading == false) {
      html.window.location.assign(url);
      return true;
    } else {
      return false;
    }
  }

  bool assignReplace(String url) {
    if (_isLoading == false) {
      html.window.location.replace(url);
      return true;
    } else {
      return false;
    }
  }
}

class Page {
  bool updateLocation(PageManager manager, Location location) {
    return true;
  }

  bool updateEvent(PageManager manager, PageManagerEvent event) {
    return true;
  }
}
