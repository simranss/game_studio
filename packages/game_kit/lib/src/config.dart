import 'package:flutter/material.dart';

/// Everything that makes one game app different from another: its name,
/// its colours, its store product and its AdMob / Play Games IDs.
///
/// Each app creates ONE of these in its `main.dart` and hands it to
/// [runGameApp]. The shared code in this package never hard-codes an ID.
class GameConfig {
  /// Shown in the app bar and the task switcher, e.g. 'Sudoku'.
  final String appName;

  /// Short, stable, lowercase id, e.g. 'sudoku'. Used for the database
  /// file name and stamped into backup files so a Sudoku backup can't be
  /// imported into the Spider app by mistake. Never change it after release.
  final String appId;

  final Color seedColor;

  /// The in-app product that removes ads (Play Console → Monetize →
  /// In-app products). Every app sells its own Premium.
  final String premiumProductId;

  // AdMob ad units. The defaults are Google's official TEST units, safe to
  // click during development. Real ones go in before release.
  final String bannerAdUnit;
  final String interstitialAdUnit;
  final String rewardedAdUnit;

  /// Play Games IDs by a name the app chooses, e.g. {'easy': 'CgkI...'}.
  final Map<String, String> leaderboards;
  final Map<String, String> achievements;

  /// Ad pacing for free players. The house rule for every app in this
  /// book: an interstitial after EVERY finished game. Raise these
  /// (e.g. 3 games / 4 minutes) for a gentler app — AdService won't change.
  final int gamesBetweenInterstitials;
  final Duration interstitialCooldown;

  const GameConfig({
    required this.appName,
    required this.appId,
    required this.seedColor,
    this.premiumProductId = 'premium_unlock',
    this.bannerAdUnit = 'ca-app-pub-3940256099942544/9214589741',
    this.interstitialAdUnit = 'ca-app-pub-3940256099942544/1033173712',
    this.rewardedAdUnit = 'ca-app-pub-3940256099942544/5224354917',
    this.leaderboards = const {},
    this.achievements = const {},
    this.gamesBetweenInterstitials = 1,
    this.interstitialCooldown = Duration.zero,
  });
}