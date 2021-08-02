# Shark Flutter 🦈 (Official)

[![codecov](https://codecov.io/gh/lau1944/shark/branch/dev/graph/badge.svg?token=USH2YH4BK1)](https://codecov.io/gh/lau1944/shark)
[![pub package](https://img.shields.io/pub/v/shark.svg)](https://pub.dev/packages/shark)
[![CodeFactor](https://www.codefactor.io/repository/github/lau1944/shark/badge/main)](https://www.codefactor.io/repository/github/lau1944/shark/overview/main)

A Flutter server rendering framework 

## What it is

Shark is a server rendering framework, a server-driven UI framework.

Simple use case of shark

Let say you have a `text` widget, you specify it as json on the server return to the client,
the client use shark to receive the text widget and show the UI successfully.

After a while, you want to change the text widget to a `button`, instead of modify it on the client code and go through all the mobile app store update process,
you only need to modify the text widget to a button widget on the server, and the shark client received it, showed the newest UI.

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

<p> To redirect to another page, call `redirect`

```dart
_controller.redirect('/your_new_path');
```

## Routing

 `shark` auto handles your page routing, if you do not want it, set `handleClickEvent` to false

``` dart
 _sharkController = SharkController('/your_path', handleClickEvent: false);
```

### Click Event

<p> Routing trigger by click event, which you can set it like this on your json widget file.

```javascript
    {
        'type': "container",
        'click_event': 'route://your_path'
    }
```
  
The schema `route` represents the routing action 

Currently, there are only 2 routing action


`route`: Navigation to the next page corresponds to the path you define

`link`: use `url_launcher` internally to open a url on browser, please visit [url_launcher](https://pub.dev/packages/url_launcher) to configure the detail requirements for each platform

## Caching

`Shark` use [dio_cache_interceptor](https://pub.dev/packages/dio_cache_interceptor) for caching purposes.

When you initialize the shark library, you can pass a `cacheStrategy` argument to config your caching setting.

## Parsing

Note that Shark uses [dynamic_widget](https://pub.dev/packages/dynamic_widget) for widget parsing,
  
If you want to create your own parser

``` dart
class MyCustomParser extends SharkParser {}
```  

To view the json format, go visit [documentation](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md) on dynamic_widget.
  
  
## OTHER
You can also view the [express server sample](https://github.com/lau1944/shark-server), you can deploy to [heroku](https://www.heroku.com/home) fast
  
or you can test it on this temporary host =(little slow)
  
https://shark-sample-server.herokuapp.com/    
  

  
  
### Real world sample (Promotion 😂)
  
My new meditation app had implemented `shark` recently, the `profile` page is handled by `shark` completely. 

https://seasonnatural.netlify.app/  
  
  
### Future Job

 - Security
 - Localization
