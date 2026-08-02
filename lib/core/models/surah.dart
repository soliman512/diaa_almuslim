class Surah {
  int id;
  String arabicName;
  int versesCount;
  String revelationPlace;
  String? englishName;
  Surah({
    required this.id,
    required this.arabicName,
    required this.versesCount,
    required this.revelationPlace,
    this.englishName,
  });

  factory Surah.fromMap(Map<String, dynamic> jsonElement) => Surah(
    id: jsonElement["number"],
    arabicName: jsonElement["name"],
    versesCount: jsonElement["numberOfAyahs"],
    revelationPlace: jsonElement["revelationType"],
    englishName: jsonElement["englishName"],
  );
}
