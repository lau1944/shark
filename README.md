# Shark Flutter 🦈 (Official)

[![pub package](https://img.shields.io/pub/v/shark.svg)](https://pub.dev/packages/shark)
[![CodeFactor](https://www.codefactor.io/repository/github/lau1944/shark/badge/main)](https://www.codefactor.io/repository/github/lau1944/shark/overview/main)
[![build](https://github.com/lau1944/shark/actions/workflows/flutter_ci.yaml/badge.svg?branch=dev)](https://github.com/lau1944/shark/actions)

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

### Guide 

* [Set Up](#how-to-use)
* [Routing](#routing)
* [Event](#click-event)
* [Caching](#caching)
* [Parsing](#parsing)
* [Localization](#localization)
* [Other](#other)
* [Real World Sample](#real-world-sample)

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

To redirect to another page, call `redirect`

```dart
_controller.redirect('/your_new_path');
```

To refresh current page, call `refresh`
```dart
_controller.refresh();
```

If you want to create your own parser

``` dart
class MyCustomParser extends SharkParser {}
```

## Routing

 `shark` auto handles your page routing, if you do not want it, set `handleClickEvent` to false

``` dart
 _sharkController = SharkController('/your_path', handleClickEvent: false);
```

### Click Event

<p> Routing trigger by click event, which you can set it like this on your json widget file.

A sample event json format

```json
    {
        "type": "container",
        "click_event": "route://your_path?xxx=xxx"
    }
```

`schema`: xxx://
  
  
`path`: your_path
  
  
`argument`: After the prefix '?' is the argument field.
xxx=xxx, separate with `&`
  
sample: 
```json
"click_event": "route://second_page?name=hello&place=world"  
```

### The schema represents the routing action
  

Currently, there are 4 routing action

`route`: prefix with `route://`, internally would call `Navigator.pushName('new_path', args)`
  

Push a new route to `Navigator`

** Please remember to specify `route path` on your route map
  
  
If not, navigator would throw an error
then SharkController would try to navigator to a new default shark widget with the following path

`pop`: prefix with `pop://`, internally would call `Navigator.pop(result)`

`redirect`: prefix with `redirect://`, redirect current page with the following path

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

Then add this new parser to shark widget
``` dart
_sharkController.addParser(MyCustomParser());
```
<br/>
To view the json format, go visit [documentation](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md) on dynamic_widget.

## Localization

`shark` uses [easy_localization](https://pub.dev/packages/easy_localization) for localization, follow the [instructions](https://pub.dev/packages/easy_localization) to set up.

After setting up easy_localization package, next thing you need to do is to add a `TranslatedTextParser` to shark widget

`TranslatedTextParser` do all the localize work for you

```dart
_sharkController.addParse(TranslatedTextParser());
```

In your server json file, modify the  `text` tag to `translatedText`

``` json
{
    "type": "Text",
    "data": "Redirect To next page"
}
```
To
```json
{
    "type": "TranslatedText",
    "data": "Redirect To next page"
}
```

`data` value should be the value corresponds to your translations json file `key`

sample translations file `zh.json`

```json
{
  "Navigate To next page":"push路由，转入下一页",
  "Redirect To next page": "转换至另一页",
  "To goog.gl": "去谷歌"
}
```

That's it ~~

<br/>
<br/>


## OTHER
You can also view the [express server sample](https://github.com/lau1944/shark-server), you can deploy to [heroku](https://www.heroku.com/home) fast

or you can test it on this temporary host =(little slow)

https://shark-sample-server.herokuapp.com/




### Real world sample 
(Promotion 😂)  

My new meditation app had implemented `shark` recently, the `profile` page is handled by `shark` completely.

https://seasonnatural.netlify.app/


<br></br>

My work email : lauchuen94@gmail.com
