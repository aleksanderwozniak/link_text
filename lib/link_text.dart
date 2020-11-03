//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

library link_text;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final TextStyle linkStyle;
  final TextAlign textAlign;

  const LinkText({
    Key key,
    @required this.text,
    this.textStyle,
    this.linkStyle,
    this.textAlign = TextAlign.start,
  })  : assert(text != null),
        super(key: key);

  @override
  _LinkTextState createState() => _LinkTextState();
}

class _LinkTextState extends State<LinkText> {
  List<TapGestureRecognizer> _gestureRecognizers;
  final RegExp _regex = RegExp(
      r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%.,_\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\,+.~#?&//=]*)");

  @override
  void initState() {
    super.initState();
    _gestureRecognizers = <TapGestureRecognizer>[];
  }

  @override
  void dispose() {
    _gestureRecognizers.forEach((recognizer) => recognizer.dispose());
    super.dispose();
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textStyle = this.widget.textStyle ?? themeData.textTheme.body1;
    final linkStyle = this.widget.linkStyle ??
        themeData.textTheme.body1.copyWith(
          color: themeData.accentColor,
          decoration: TextDecoration.underline,
        );

    final links = _regex.allMatches(widget.text);

    if (links.isEmpty) {
      return Text(widget.text, style: textStyle);
    }

    final textParts = widget.text.split(_regex);
    final textSpans = <TextSpan>[];

    int i = 0;
    textParts.forEach((part) {
      textSpans.add(TextSpan(text: part, style: textStyle));

      if (i < links.length) {
        final link = links.elementAt(i).group(0);
        final recognizer = TapGestureRecognizer()
          ..onTap = () => _launchUrl(link);

        _gestureRecognizers.add(recognizer);
        textSpans.add(
          TextSpan(
            text: link,
            style: linkStyle,
            recognizer: recognizer,
          ),
        );

        i++;
      }
    });

    return Text.rich(
      TextSpan(children: textSpans),
      textAlign: widget.textAlign,
    );
  }
}
