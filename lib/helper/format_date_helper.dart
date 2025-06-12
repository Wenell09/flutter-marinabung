class FormatDateHelper {
  String formatTanggal(String isoDateString) {
    final DateTime dateTime = DateTime.parse(isoDateString).toLocal();

    const List<String> namaBulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    int day = dateTime.day;
    String monthName = namaBulan[dateTime.month - 1];
    int year = dateTime.year;

    return '$day $monthName $year';
  }

  String formatTanggalJam(String isoDateString) {
  final DateTime utcDateTime = DateTime.parse(isoDateString).toUtc();
  final DateTime localDateTime = utcDateTime.add(const Duration(hours: 7)); // UTC+7 (WIB)

  const List<String> namaBulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  String day = localDateTime.day.toString();
  String monthName = namaBulan[localDateTime.month - 1];
  String year = localDateTime.year.toString();

  String hour = localDateTime.hour.toString().padLeft(2, '0');
  String minute = localDateTime.minute.toString().padLeft(2, '0');

  return '$day $monthName $year $hour:$minute';
}

}
