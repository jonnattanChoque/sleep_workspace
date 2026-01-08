import 'package:sleep_sync_app/core/utils/enum_lottie.dart';

String getLottieAssetByQuality(double quality) {
  if (quality >= 7.5) {
    return StateLottie.good.path;
  } else if (quality >= 5.5) {
    return StateLottie.neutral.path;
  } else {
    return StateLottie.bad.path;
  }
}