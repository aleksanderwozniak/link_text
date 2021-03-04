// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:link_text/link_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinkText Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'LinkText Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _text =
      'Lorem ipsum https://flutter.dev\nhttps://pub.dev dolor https://google.com/search?q=flutter+&oq=flutter sit amet';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24.0),
              _buildNormalText(),
              const SizedBox(height: 64.0),
              _buildLinkText(),
              const SizedBox(height: 64.0),
              _buildLinkTextShortened(),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNormalText() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Normal Text Widget',
          textAlign: TextAlign.center,
          style: TextStyle().copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12.0),
        Text(
          _text,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLinkText() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'LinkText Widget',
          textAlign: TextAlign.center,
          style: TextStyle().copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12.0),
        LinkText(
          _text,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLinkTextShortened() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'LinkText Widget with trimmed URL parameters',
          textAlign: TextAlign.center,
          style: TextStyle().copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12.0),
        LinkText(
          _text,
          textAlign: TextAlign.center,
          shouldTrimParams: true,
        ),
      ],
    );
  }
}
