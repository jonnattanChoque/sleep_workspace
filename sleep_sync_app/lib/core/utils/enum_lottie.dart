enum StateLottie {
  loading('assets/animations/loading.json'),
  good('assets/animations/good.json'),
  neutral('assets/animations/regular.json'),
  bad('assets/animations/bad.json'),
  searching('assets/animations/searching.json');

  final String path;
  const StateLottie(this.path);
}