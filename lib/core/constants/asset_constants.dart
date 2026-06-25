// >>> AssetConstants =======================
// Centralized asset paths for lottie animations and images
abstract class AssetConstants {
  // Base paths
  static const String _lottiePath = 'assets/lottie';
  static const String _imagesPath = 'assets/images';

  // Lottie animations
  static const String loadingAnimation = '$_lottiePath/loading.json';
  static const String downloadingAnimation = '$_lottiePath/downloading.json';
  static const String successAnimation = '$_lottiePath/success.json';
  static const String errorAnimation = '$_lottiePath/error.json';
  static const String emptyAnimation = '$_lottiePath/empty.json';
  static const String searchAnimation = '$_lottiePath/search.json';
  static const String noInternetAnimation = '$_lottiePath/no_internet.json';

  // Images
  static const String appLogo = '$_imagesPath/app_logo.png';
  static const String placeholder = '$_imagesPath/placeholder.png';
  static const String onboarding1 = '$_imagesPath/onboarding_1.png';
  static const String onboarding2 = '$_imagesPath/onboarding_2.png';
  static const String onboarding3 = '$_imagesPath/onboarding_3.png';
}
// <<< AssetConstants =======================
