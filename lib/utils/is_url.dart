bool isURL(String input) {
  final pattern = RegExp(r'^(https?://)');
  return pattern.hasMatch(input);
}
