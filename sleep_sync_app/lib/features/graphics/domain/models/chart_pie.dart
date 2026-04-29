class PieChartState {
  final double myShare;
  final double partnerShare;
  final double greyArea;
  final int totalPercent;
  final double avgStars;

  PieChartState({
    required this.myShare,
    required this.partnerShare,
    required this.greyArea,
    required this.totalPercent,
    required this.avgStars,
  });

  factory PieChartState.empty() => PieChartState(
        myShare: 0,
        partnerShare: 0,
        greyArea: 100,
        totalPercent: 0,
        avgStars: 0.0,
      );
}