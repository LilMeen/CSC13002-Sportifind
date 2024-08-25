class BarData {
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;
  final double sunAmount;

  BarData({
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,
    required this.sunAmount,

  });

  List<SingleBar> barData = [];

  void initializeBarData() {
    barData = [
      SingleBar(x: 0, y: monAmount),
      SingleBar(x: 1, y: tueAmount),
      SingleBar(x: 2, y: wedAmount),
      SingleBar(x: 3, y: thuAmount),
      SingleBar(x: 4, y: friAmount),
      SingleBar(x: 5, y: satAmount),
      SingleBar(x: 6, y: sunAmount),
    ];
  }
}


class SingleBar {
  final int x;
  final double y;

  SingleBar({
    required this.x,
    required this.y,
  });
}
