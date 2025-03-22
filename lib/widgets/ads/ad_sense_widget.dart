import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class AdSenseWidget extends StatefulWidget {
  final bool adsEnabled;
  final String adsensePublisherId;
  final String adsenseAdSlotId;

  const AdSenseWidget({super.key, 
    required this.adsEnabled,
    required this.adsensePublisherId,
    required this.adsenseAdSlotId,
  });

  @override
  AdSenseWidgetState createState() => AdSenseWidgetState();
}

class AdSenseWidgetState extends State<AdSenseWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.adsEnabled) {
      _loadAdSense();
    }
  }

  void _loadAdSense() {
    final script =
        web.document.createElement('script') as web.HTMLScriptElement;
    script.async = true;
    script.src =
        'https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-${widget.adsensePublisherId}';
    script.crossOrigin = 'anonymous';

    final ins = web.document.createElement('ins') as web.HTMLElement;
    ins.className = 'adsbygoogle';
    ins.style.display = 'block';
    ins.setAttribute('data-ad-client', 'ca-pub-${widget.adsensePublisherId}');
    ins.setAttribute('data-ad-slot', widget.adsenseAdSlotId);
    ins.setAttribute('data-ad-format', 'auto');
    ins.setAttribute('data-full-width-responsive', 'true');

    final pushScript =
        web.document.createElement('script') as web.HTMLScriptElement;
    pushScript.text = '(adsbygoogle = window.adsbygoogle || []).push({});';

    web.document.head?.append(script);
    web.document.body?.append(ins);
    web.document.body?.append(pushScript);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.adsEnabled) {
      return Container(
        width: double.infinity,
        height: 250,
        child: HtmlElementView(viewType: 'adSense'),
      );
    }
    return SizedBox.shrink();
  }
}
