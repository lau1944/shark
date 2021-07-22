
bool isDateExpired(int startDate, int duration) {
  final today = DateTime.now().millisecondsSinceEpoch;
  return today - startDate > duration;
}