import 'package:flutter/material.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:smooth_corner/smooth_corner.dart';

abstract final class SubscriptionBrandIcon {
  static IconData? iconForKey(String? iconKey) {
    if (iconKey == null) return null;

    return switch (iconKey) {
      'netflix' => SimpleIcons.netflix,
      'spotify' => SimpleIcons.spotify,
      'youtube' => SimpleIcons.youtube,
      'applemusic' => SimpleIcons.applemusic,
      'appletv' => SimpleIcons.appletv,
      'hbomax' => SimpleIcons.hbomax,
      'deezer' => SimpleIcons.deezer,
      'tidal' => SimpleIcons.tidal,
      'crunchyroll' => SimpleIcons.crunchyroll,
      'sky' => SimpleIcons.sky,
      'twitch' => SimpleIcons.twitch,
      'dazn' => SimpleIcons.dazn,
      'audible' => SimpleIcons.audible,
      'notion' => SimpleIcons.notion,
      'figma' => SimpleIcons.figma,
      'github' => SimpleIcons.github,
      'zoom' => SimpleIcons.zoom,
      'duolingo' => SimpleIcons.duolingo,
      'telegram' => SimpleIcons.telegram,
      'nordvpn' => SimpleIcons.nordvpn,
      'expressvpn' => SimpleIcons.expressvpn,
      'icloud' => SimpleIcons.icloud,
      'googleone' => SimpleIcons.google,
      'dropbox' => SimpleIcons.dropbox,
      'playstation' => SimpleIcons.playstation,
      'googleplay' => SimpleIcons.googleplay,
      'peloton' => SimpleIcons.peloton,
      'strava' => SimpleIcons.strava,
      'headspace' => SimpleIcons.headspace,
      'newyorktimes' => SimpleIcons.newyorktimes,
      _ => null,
    };
  }

  static Color colorForKey(String? iconKey, {String? fallbackHex}) {
    final fromPackage = switch (iconKey) {
      'netflix' => SimpleIconColors.netflix,
      'spotify' => SimpleIconColors.spotify,
      'youtube' => SimpleIconColors.youtube,
      'applemusic' => SimpleIconColors.applemusic,
      'appletv' => SimpleIconColors.appletv,
      'hbomax' => SimpleIconColors.hbomax,
      'deezer' => SimpleIconColors.deezer,
      'tidal' => SimpleIconColors.tidal,
      'crunchyroll' => SimpleIconColors.crunchyroll,
      'sky' => SimpleIconColors.sky,
      'twitch' => SimpleIconColors.twitch,
      'dazn' => SimpleIconColors.dazn,
      'audible' => SimpleIconColors.audible,
      'notion' => SimpleIconColors.notion,
      'figma' => SimpleIconColors.figma,
      'github' => SimpleIconColors.github,
      'zoom' => SimpleIconColors.zoom,
      'duolingo' => SimpleIconColors.duolingo,
      'telegram' => SimpleIconColors.telegram,
      'nordvpn' => SimpleIconColors.nordvpn,
      'expressvpn' => SimpleIconColors.expressvpn,
      'icloud' => SimpleIconColors.icloud,
      'googleone' => SimpleIconColors.google,
      'dropbox' => SimpleIconColors.dropbox,
      'playstation' => SimpleIconColors.playstation,
      'googleplay' => SimpleIconColors.googleplay,
      'peloton' => SimpleIconColors.peloton,
      'strava' => SimpleIconColors.strava,
      'headspace' => SimpleIconColors.headspace,
      'newyorktimes' => SimpleIconColors.newyorktimes,
      _ => null,
    };

    if (fromPackage != null) return fromPackage;
    return _parseHex(fallbackHex) ?? Colors.blueGrey;
  }

  static Color foregroundOn(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.55 ? Colors.black87 : Colors.white;
  }

  static Color? _parseHex(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    try {
      final clean = hex.replaceFirst('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return null;
    }
  }
}

class SubscriptionBrandAvatar extends StatelessWidget {
  const SubscriptionBrandAvatar({
    super.key,
    this.iconKey,
    this.name,
    this.brandColor,
    this.size = 40,
  });

  final String? iconKey;
  final String? name;
  final String? brandColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    final icon = SubscriptionBrandIcon.iconForKey(iconKey);
    final color = SubscriptionBrandIcon.colorForKey(
      iconKey,
      fallbackHex: brandColor,
    );
    final foreground = SubscriptionBrandIcon.foregroundOn(color);
    final label = (name?.isNotEmpty ?? false)
        ? name!.characters.first.toUpperCase()
        : '?';

    return SmoothContainer(
      width: size,
      height: size,
      smoothness: SmoothStyle.smoothness,
      borderRadius: BorderRadius.circular(size / 2),
      color: color,
      alignment: Alignment.center,
      child: icon != null
          ? Icon(icon, color: foreground, size: size * 0.5)
          : Text(
              label,
              style: TextStyle(
                color: foreground,
                fontWeight: FontWeight.bold,
                fontSize: size * 0.38,
              ),
            ),
    );
  }
}
