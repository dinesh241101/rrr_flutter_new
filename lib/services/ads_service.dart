import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  AdsService._();

  static final AdsService instance = AdsService._();

  static const String _appOpenAdUnitId =
      'ca-app-pub-6712784752953594/6596445544';
  static const String _homeBannerAdUnitId =
      'ca-app-pub-1123784420345660/8764365384';
  static const String _homeRewardedAdUnitId =
      'ca-app-pub-6712784752953594/1776092658';
  static const String _moduleSwitchingAdUnitId =
      'ca-app-pub-6712784752953594/5523765979';
  static const String _spinWheelRewardedAdUnitId =
      'ca-app-pub-6712784752953594/6459347195';
  static const String _scratchCardRewardedAdUnitId =
      'ca-app-pub-6712784752953594/6220402992';

  int _interstitialShown = 0;
  int _rewardedShown = 0;
  bool _sdkInitialized = false;
  bool _isLoadingAppOpenAd = false;
  bool _isShowingAppOpenAd = false;
  bool _isLoadingInterstitialAd = false;
  bool _isShowingInterstitialAd = false;
  bool _isLoadingRewardedAd = false;
  bool _isShowingRewardedAd = false;
  bool _isLoadingSpinWheelAd = false;
  bool _isShowingSpinWheelAd = false;
  bool _isLoadingScratchCardAd = false;
  bool _isShowingScratchCardAd = false;
  AppOpenAd? _appOpenAd;
  DateTime? _appOpenLoadedAt;
  InterstitialAd? _interstitialAd;
  DateTime? _interstitialAdLoadedAt;
  RewardedAd? _rewardedAd;
  DateTime? _rewardedAdLoadedAt;
  RewardedAd? _spinWheelAd;
  DateTime? _spinWheelAdLoadedAt;
  RewardedAd? _scratchCardAd;
  DateTime? _scratchCardAdLoadedAt;

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
    _loadSpinWheelAd();
    _loadScratchCardAd();
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
    if (!_isMobileAdsSupported) {
      return false;
    }
    await initialize();

    if (_isShowingInterstitialAd || !_hasValidInterstitialAd) {
      _loadInterstitialAd();
      return false;
    }

    final Completer<bool> shownCompleter = Completer<bool>();
    final InterstitialAd ad = _interstitialAd!;
    _interstitialAd = null;
    _interstitialAdLoadedAt = null;
    _isShowingInterstitialAd = true;

    ad.fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
      onAdShowedFullScreenContent: (InterstitialAd _) {
        _interstitialShown += 1;
        debugPrint(
          'Interstitial ad shown at $placement. Total: $totalAdsShown',
        );
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _isShowingInterstitialAd = false;
        _loadInterstitialAd();
        if (!shownCompleter.isCompleted) {
          shownCompleter.complete(true);
        }
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('Failed to show interstitial ad at $placement: $error');
        ad.dispose();
        _isShowingInterstitialAd = false;
        _loadInterstitialAd();
        if (!shownCompleter.isCompleted) {
          shownCompleter.complete(false);
        }
      },
    );

    ad.show();
    return shownCompleter.future;
  }

  Future<int?> showRewarded({
    required String placement,
    required int rewardCoins,
  }) async {
    if (!_isMobileAdsSupported) {
      return null;
    }
    await initialize();

    if (_isShowingRewardedAd || !_hasValidRewardedAd) {
      _loadRewardedAd();
      return null;
    }

    final Completer<int?> rewardCompleter = Completer<int?>();
    final RewardedAd ad = _rewardedAd!;
    _rewardedAd = null;
    _rewardedAdLoadedAt = null;
    _isShowingRewardedAd = true;
    int? earnedReward;

    ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
      onAdShowedFullScreenContent: (RewardedAd _) {
        debugPrint('Rewarded ad shown at $placement');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        _isShowingRewardedAd = false;
        _loadRewardedAd();
        if (!rewardCompleter.isCompleted) {
          rewardCompleter.complete(earnedReward);
        }
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint('Failed to show rewarded ad at $placement: $error');
        ad.dispose();
        _isShowingRewardedAd = false;
        _loadRewardedAd();
        if (!rewardCompleter.isCompleted) {
          rewardCompleter.complete(null);
        }
      },
    );

    ad.show(
      onUserEarnedReward: (_, RewardItem reward) {
        _rewardedShown += 1;
        earnedReward = rewardCoins;
        debugPrint('Rewarded ad at $placement. Reward: $rewardCoins');
      },
    );

    return rewardCompleter.future;
  }

  Future<int?> showSpinWheelRewarded({
    required String placement,
    int bonusCoins = 40,
  }) async {
    if (!_isMobileAdsSupported) {
      return null;
    }
    await initialize();

    if (_isShowingSpinWheelAd || !_hasValidSpinWheelAd) {
      _loadSpinWheelAd();
      return null;
    }

    final Completer<int?> rewardCompleter = Completer<int?>();
    final RewardedAd ad = _spinWheelAd!;
    _spinWheelAd = null;
    _spinWheelAdLoadedAt = null;
    _isShowingSpinWheelAd = true;
    int? earnedReward;

    ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
      onAdShowedFullScreenContent: (RewardedAd _) {
        debugPrint('Spin wheel rewarded ad shown at $placement');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        _isShowingSpinWheelAd = false;
        _loadSpinWheelAd();
        if (!rewardCompleter.isCompleted) {
          rewardCompleter.complete(earnedReward);
        }
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint(
          'Failed to show spin wheel rewarded ad at $placement: $error',
        );
        ad.dispose();
        _isShowingSpinWheelAd = false;
        _loadSpinWheelAd();
        if (!rewardCompleter.isCompleted) {
          rewardCompleter.complete(null);
        }
      },
    );

    ad.show(
      onUserEarnedReward: (_, RewardItem reward) {
        _rewardedShown += 1;
        earnedReward = bonusCoins;
        debugPrint(
          'Spin wheel ad reward earned at $placement. Bonus: $bonusCoins',
        );
      },
    );

    return rewardCompleter.future;
  }

  Future<int?> showScratchCardRewarded({
    required String placement,
    int bonusCoins = 40,
  }) async {
    if (!_isMobileAdsSupported) {
      return null;
    }
    await initialize();

    if (_isShowingScratchCardAd || !_hasValidScratchCardAd) {
      _loadScratchCardAd();
      return null;
    }

    final Completer<int?> rewardCompleter = Completer<int?>();
    final RewardedAd ad = _scratchCardAd!;
    _scratchCardAd = null;
    _scratchCardAdLoadedAt = null;
    _isShowingScratchCardAd = true;
    int? earnedReward;

    ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
      onAdShowedFullScreenContent: (RewardedAd _) {
        debugPrint('Scratch card rewarded ad shown at $placement');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        _isShowingScratchCardAd = false;
        _loadScratchCardAd();
        if (!rewardCompleter.isCompleted) {
          rewardCompleter.complete(earnedReward);
        }
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint(
          'Failed to show scratch card rewarded ad at $placement: $error',
        );
        ad.dispose();
        _isShowingScratchCardAd = false;
        _loadScratchCardAd();
        if (!rewardCompleter.isCompleted) {
          rewardCompleter.complete(null);
        }
      },
    );

    ad.show(
      onUserEarnedReward: (_, RewardItem reward) {
        _rewardedShown += 1;
        earnedReward = bonusCoins;
        debugPrint(
          'Scratch card ad reward earned at $placement. Bonus: $bonusCoins',
        );
      },
    );

    return rewardCompleter.future;
  }

  bool get _hasValidAppOpenAd {
    if (_appOpenAd == null || _appOpenLoadedAt == null) {
      return false;
    }
    return DateTime.now().difference(_appOpenLoadedAt!) <
        const Duration(hours: 4);
  }

  bool get _hasValidInterstitialAd {
    if (_interstitialAd == null || _interstitialAdLoadedAt == null) {
      return false;
    }
    return DateTime.now().difference(_interstitialAdLoadedAt!) <
        const Duration(hours: 4);
  }

  bool get _hasValidRewardedAd {
    if (_rewardedAd == null || _rewardedAdLoadedAt == null) {
      return false;
    }
    return DateTime.now().difference(_rewardedAdLoadedAt!) <
        const Duration(hours: 4);
  }

  bool get _hasValidSpinWheelAd {
    if (_spinWheelAd == null || _spinWheelAdLoadedAt == null) {
      return false;
    }
    return DateTime.now().difference(_spinWheelAdLoadedAt!) <
        const Duration(hours: 4);
  }

  bool get _hasValidScratchCardAd {
    if (_scratchCardAd == null || _scratchCardAdLoadedAt == null) {
      return false;
    }
    return DateTime.now().difference(_scratchCardAdLoadedAt!) <
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

  void _loadInterstitialAd() {
    if (!_isMobileAdsSupported ||
        _isLoadingInterstitialAd ||
        _hasValidInterstitialAd ||
        _isShowingInterstitialAd) {
      return;
    }

    _isLoadingInterstitialAd = true;
    InterstitialAd.load(
      adUnitId: _moduleSwitchingAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _isLoadingInterstitialAd = false;
          _interstitialAd = ad;
          _interstitialAdLoadedAt = DateTime.now();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isLoadingInterstitialAd = false;
          debugPrint('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  void _loadRewardedAd() {
    if (!_isMobileAdsSupported ||
        _isLoadingRewardedAd ||
        _hasValidRewardedAd ||
        _isShowingRewardedAd) {
      return;
    }

    _isLoadingRewardedAd = true;
    RewardedAd.load(
      adUnitId: _homeRewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _isLoadingRewardedAd = false;
          _rewardedAd = ad;
          _rewardedAdLoadedAt = DateTime.now();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isLoadingRewardedAd = false;
          debugPrint('Rewarded ad failed to load: $error');
        },
      ),
    );
  }

  void _loadSpinWheelAd() {
    if (!_isMobileAdsSupported ||
        _isLoadingSpinWheelAd ||
        _hasValidSpinWheelAd ||
        _isShowingSpinWheelAd) {
      return;
    }

    _isLoadingSpinWheelAd = true;
    RewardedAd.load(
      adUnitId: _spinWheelRewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _isLoadingSpinWheelAd = false;
          _spinWheelAd = ad;
          _spinWheelAdLoadedAt = DateTime.now();
          debugPrint('Spin wheel ad loaded successfully');
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isLoadingSpinWheelAd = false;
          debugPrint('Spin wheel ad failed to load: $error');
        },
      ),
    );
  }

  void _loadScratchCardAd() {
    if (!_isMobileAdsSupported ||
        _isLoadingScratchCardAd ||
        _hasValidScratchCardAd ||
        _isShowingScratchCardAd) {
      return;
    }

    _isLoadingScratchCardAd = true;
    RewardedAd.load(
      adUnitId: _scratchCardRewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _isLoadingScratchCardAd = false;
          _scratchCardAd = ad;
          _scratchCardAdLoadedAt = DateTime.now();
          debugPrint('Scratch card ad loaded successfully');
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isLoadingScratchCardAd = false;
          debugPrint('Scratch card ad failed to load: $error');
        },
      ),
    );
  }
}
