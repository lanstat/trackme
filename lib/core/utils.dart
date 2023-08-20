String formatDate(DateTime date) {
  String parseDecimal(int number) {
    if (number < 10) {
      return '0$number';
    }
    return number.toString();
  }
  return '${parseDecimal(date.day)}/${parseDecimal(date.month)}/${date.year}';
}

String formatDateTime(DateTime date) {
  String parseDecimal(int number) {
    if (number < 10) {
      return '0$number';
    }
    return number.toString();
  }
  return '${parseDecimal(date.day)}/${parseDecimal(date.month)}/${date.year} ${parseDecimal(date.hour)}:${parseDecimal(date.minute)}:${parseDecimal(date.second)}';
}

String formatTime(DateTime date) {
  String parseDecimal(int number) {
    if (number < 10) {
      return '0$number';
    }
    return number.toString();
  }
  return '${parseDecimal(date.hour)}:${parseDecimal(date.minute)}:${parseDecimal(date.second)}';
}
