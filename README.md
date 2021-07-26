# Shark Flutter 🦈 (Under Construction)

[![codecov](https://codecov.io/gh/lau1944/shark/branch/dev/graph/badge.svg?token=USH2YH4BK1)](https://codecov.io/gh/lau1944/shark)
[![pub package](https://img.shields.io/pub/v/shark.svg)](https://pub.dev/packages/shark)

A Flutter server rendering framework 

### Project diagram

<img src="https://github.com/lau1944/shark/blob/dev/shark_diagram.png?raw=true" width="1000" >

## How to use 

First, `init` Shark library on main method on your application

```dart
  void main() {
    WidgetsFlutterBinding.ensureInitialized();
    await Shark.init(hostUrl: 'http://yourhost.com');
    
    runApp(MyApp());
  }
```

Second, set up UI widget

* To be noticed, every thing related to widget is controlled by `SharkController`
* `get` method is where we send the request 

``` dart
  late final SharkController _controller;
  
  /// init the shark controller
  @override
  void initState() {
    _controller = SharkController.fromUrl(path: '/container',)..get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SharkWidget(controller: _controller);
  }
```

If you want to create your own parser

``` dart
class MyCustomParser extends SharkParser {}
```

<br></br>
* Remember that Shark is still on early development and lack of testing, I would not recommend you to use it on Production.

* Note that Shark uses [dynamic_widget](https://pub.dev/packages/dynamic_widget) for widget parsing,
* To view the json format, go visit [documentation](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md) on dynamic_widget.

You can also view the [express server sample](https://github.com/lau1944/shark-server)

### Future Job

 - Routing 
 - Parsing widget optimization
 - Security
 - Caching
