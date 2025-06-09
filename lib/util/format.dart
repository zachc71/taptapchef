/// Utility for displaying large numbers using short suffixes.
String formatNumber(num number) {
  if (number < 1000) return number.toString();
  const suffixes = ['k', 'm', 'b', 't', 'q'];
  double value = number.toDouble();
  int i = 0;
  while (value >= 1000 && i < suffixes.length) {
    value /= 1000;
    i++;
  }
  final text = value.toStringAsFixed(value < 10 ? 1 : 0);
  return '$text${suffixes[i - 1]}';
}

