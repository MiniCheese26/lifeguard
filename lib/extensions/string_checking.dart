extension StringChecking on String? {
  bool isNullOrEmpty() {
    return this == null || this!.isEmpty || this!.trim().isEmpty;
  }
}