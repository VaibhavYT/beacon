import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beacon/locator.dart';
import 'package:uni_links/uni_links.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({@required Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Uri _initialUri;
  Uri _latestUri;
  StreamSubscription _sub;

  Future<void> _handleInitialUri() async {
    _sub = uriLinkStream.listen((Uri uri) {
      if (!mounted) return;
      setState(() {
        _latestUri = uri;
      });
    }, onError: (Object err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
      });
    });
    try {
      final uri = await getInitialUri();
      if (!mounted) return;
      setState(() => _initialUri = uri);
    } on PlatformException {
      if (!mounted) return;
      setState(() => _initialUri = null);
    } on FormatException catch (err) {
      debugPrint(err.toString());
      if (!mounted) return;
      setState(() => _initialUri = null);
    }
    if (_latestUri == null && _initialUri == null) {
      final bool userLoggedIn = await userConfig.userLoggedIn();
      Future.delayed(const Duration(milliseconds: 750)).then((value) async {
        if (userLoggedIn) {
          navigationService.pushReplacementScreen('/main');
        } else {
          navigationService.pushReplacementScreen('/auth');
        }
      });
    } else {
      if (_initialUri != null) {
        String shortcode = _initialUri.queryParameters.toString();
        navigationService.pushScreen('/hikeScreen');
      }
    }
  }

  @override
  void initState() {
    _handleInitialUri();
    super.initState();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('SplashScreenScaffold'),
      body: Center(
        child: new Image(image: new AssetImage('images/hikers_group.png')),
      ),
    );
  }
}