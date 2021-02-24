//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

library link_text;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Easy to use text widget, which converts inlined urls into clickable links.
/// Allows custom styling.
class LinkText extends StatefulWidget {
  /// Text, which may contain inlined urls.
  final String text;

  /// Style of the non-url part of supplied text.
  final TextStyle textStyle;

  /// Style of the url part of supplied text.
  final TextStyle linkStyle;

  /// Determines how the text is aligned.
  final TextAlign textAlign;

  /// If true, this will cut off all visible links after '?'.
  /// This is only for better readability. When executing the url
  /// the link with all params stays the same.
  final bool shouldTrimParams;

  /// Overrides default behavior when tapping on links.
  /// Provides the url that was tapped.
  final void Function(String url) onLinkTap;

  /// Creates a [LinkText] widget, used for inlined urls.
  const LinkText({
    Key key,
    @required this.text,
    this.textStyle,
    this.linkStyle,
    this.textAlign = TextAlign.start,
    this.shouldTrimParams = false,
    this.onLinkTap,
  })  : assert(text != null),
        super(key: key);

  @override
  _LinkTextState createState() => _LinkTextState();
}

class _LinkTextState extends State<LinkText> {
  List<TapGestureRecognizer> _gestureRecognizers;
  final RegExp _regex = RegExp(
      r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%.,_\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\,+.~#?&//=]*)");

  final _shortenRegex = RegExp(r"(.*)\?");

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
    if (widget.onLinkTap != null) {
      widget.onLinkTap(url);
      return;
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textStyle = this.widget.textStyle ?? themeData.textTheme.bodyText2;
    final linkStyle = this.widget.linkStyle ??
        themeData.textTheme.bodyText2.copyWith(
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
        var newLinkText;

        final recognizer = TapGestureRecognizer()
          ..onTap = () => _launchUrl(link);

        if (widget.shouldTrimParams) {
          newLinkText = _shortenRegex.firstMatch(link)?.group(1);
        }

        _gestureRecognizers.add(recognizer);
        textSpans.add(
          TextSpan(
            text: newLinkText ?? link,
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
