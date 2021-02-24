# Link Text

[![Pub Package](https://img.shields.io/pub/v/link_text.svg?style=flat-square)](https://pub.dartlang.org/packages/link_text)

Easy to use text widget for Flutter apps, which converts inlined urls into working, clickable links. Allows custom styling.

![Image](https://raw.githubusercontent.com/aleksanderwozniak/link_text/assets/link_text_demo.png)

## Usage

**Link Text** widget requires no setup. Just simply pass a `String` with inlined URLs, and the widget will take care of the rest.

```dart
final String _text = 'Lorem ipsum https://flutter.dev\nhttps://pub.dev';

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: LinkText(
        text: _text,
        textAlign: TextAlign.center,
        // You can optionally handle link tap event by yourself
        // onLinkTap: (url) => ...
      ),
    ),
  );
}
```

### Installation

Add to pubspec.yaml:

```yaml
dependencies:
  link_text: ^0.1.5
```
For more info, check out [example project](https://github.com/aleksanderwozniak/link_text/tree/master/example).
