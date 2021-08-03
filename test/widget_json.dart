const String firstPage = '''
{
        "type": "Container",
        "color": "#FFFFFF",
        "alignment": "center",
        "child": {
          "type" : "Container",
          "child" : {
            "type": "Column",
            "mainAxisAlignment": "center",
            "children": [
              {
                "type": "RaisedButton",
                "color": "#000000",
                "textColor": "#FFFFFF",
                "click_event": "route://second_page",
                "child" : {
                  "type": "Text",
                  "data": "To next page"
                }
              }
            ]
          }
        }
      }
''';

const String secondPage = ''' {
        "type": "Container",
        "color": "#800080",
        "alignment": "center",
        "child": {
          "type" : "Container",
          "child" : {
            "type": "Column",
            "mainAxisAlignment": "center",
            "children": [
              {
                "type": "RaisedButton",
                "color": "#000000",
                "textColor": "#FFFFFF",
                "click_event": "link://https://google.com",
                "child" : {
                  "type": "Text",
                  "data": "To goog.gl"
                }
              }
            ]
          }
        }
      }
''';
