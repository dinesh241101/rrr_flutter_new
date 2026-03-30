import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  AdsService._();

  static final AdsService instance = AdsService._();

  static const String _appOpenAdUnitId =
      'ca-app-pub-1123784420345660/1448982149';
  static const String _homeBannerAdUnitId =
      'ca-app-pub-1123784420345660/8764365384';

  int _interstitialShown = 0;
  int _rewardedShown = 0;
  bool _sdkInitialized = false;
  bool _isLoadingAppOpenAd = false;
  bool _isShowingAppOpenAd = false;
  AppOpenAd? _appOpenAd;
  DateTime? _appOpenLoadedAt;

  int get interstitialShown => _interstitialShown;
  int get rewardedShown => _rewardedShown;
  int get totalAdsShown => _interstitialShown + _rewardedShown;

  bool get _isMobileAdsSupported {
    if (kIsWeb) {
      return false;
    }
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  Future<void> initialize() async {
    if (_sdkInitialized || !_isMobileAdsSupported) {
      return;
    }
    await MobileAds.instance.initialize();
    _sdkInitialized = true;
    _loadAppOpenAd();
  }

  BannerAd? createHomeBannerAd({
    required VoidCallback onLoaded,
    required void Function(LoadAdError error) onFailedToLoad,
  }) {
    if (!_isMobileAdsSupported) {
      return null;
    }

    final BannerAd bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: _homeBannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded(),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          onFailedToLoad(error);
        },
      ),
      request: const AdRequest(),
    );
    bannerAd.load();
    return bannerAd;
  }

  Future<bool> showAppOpenIfAvailable({required String placement}) async {
    if (!_isMobileAdsSupported) {
      return false;
    }
    await initialize();

    if (_isShowingAppOpenAd || !_hasValidAppOpenAd) {
      _loadAppOpenAd();
      return false;
    }

    final Completer<bool> shownCompleter = Completer<bool>();
    final AppOpenAd ad = _appOpenAd!;
    _appOpenAd = null;
    _appOpenLoadedAt = null;
    _isShowingAppOpenAd = true;

    ad.fullScreenContentCallback = FullScreenContentCallback<AppOpenAd>(
      onAdShowedFullScreenContent: (AppOpenAd _) {
        debugPrint('App open ad shown at $placement');
      },
      onAdDismissedFullScreenContent: (AppOpenAd ad) {
        ad.dispose();
        _isShowingAppOpenAd = false;
        _loadAppOpenAd();
        if (!shownCompleter.isCompleted) {
          shownCompleter.complete(true);
        }
      },
      onAdFailedToShowFullScreenContent: (AppOpenAd ad, AdError error) {
        debugPrint('Failed to show app open ad at $placement: $error');
        ad.dispose();
        _isShowingAppOpenAd = false;
        _loadAppOpenAd();
        if (!shownCompleter.isCompleted) {
          shownCompleter.complete(false);
        }
      },
    );

    ad.show();
    return shownCompleter.future;
  }

  Future<bool> showInterstitial({required String placement}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _interstitialShown += 1;
    debugPrint('Mock Interstitial shown at $placement. Total: $totalAdsShown');
    return true;
  }

  Future<int?> showRewarded({
    required String placement,
    required int rewardCoins,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _rewardedShown += 1;
    debugPrint('Mock Rewarded shown at $placement. Reward: $rewardCoins');
    return rewardCoins;
  }

  bool get _hasValidAppOpenAd {
    if (_appOpenAd == null || _appOpenLoadedAt == null) {
      return false;
    }
    return DateTime.now().difference(_appOpenLoadedAt!) <
        const Duration(hours: 4);
  }

  void _loadAppOpenAd() {
    if (!_isMobileAdsSupported ||
        _isLoadingAppOpenAd ||
        _hasValidAppOpenAd ||
        _isShowingAppOpenAd) {
      return;
    }

    _isLoadingAppOpenAd = true;
    AppOpenAd.load(
      adUnitId: _appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (AppOpenAd ad) {
          _isLoadingAppOpenAd = false;
          _appOpenAd = ad;
          _appOpenLoadedAt = DateTime.now();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isLoadingAppOpenAd = false;
          debugPrint('App open ad failed to load: $error');
        },
      ),
    );
  }
}
