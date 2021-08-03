
## 1.0.0

* stable official

## 1.0.1

* fix some problems on routing (link routing error)
* export `SharkWidgetState` type
* update test sample

## 1.0.2

* add refresh method
* modify the routing method
  - route: prefix with 'route://', internally would call [Navigator.pushName('new_path')]
  - redirect: prefix with 'redirect://', redirect current page with the following path
  - link: prefix with 'link://', start the browser to open a url
