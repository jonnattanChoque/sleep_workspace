enum StateLottie {
  loading('assets/animations/loading.json'),
  good('assets/animations/good.json'),
  neutral('assets/animations/regular.json'),
  bad('assets/animations/bad.json');

  final String path;
  const StateLottie(this.path);
}