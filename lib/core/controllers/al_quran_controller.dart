import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:diaa_almuslim/core/constants/json_files.dart';
import 'package:diaa_almuslim/core/models/surah.dart';
import 'package:quran/quran.dart';
import 'package:string_validator/string_validator.dart';

class AlQuranController extends ChangeNotifier {
  bool isLoading = true;

  List<Surah> allSurahs = [];

  List<Surah> displaySurahs = [];
  List<int> pageNumbers = [];
Map<dynamic, dynamic>? ayahSearchResults;  Timer? _debounce;
  Future<void> init() async {
    await _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    try {
      final String jsonString = await rootBundle.loadString(
        ConstJsonFiles.surahs,
      );
      final List<dynamic> data = jsonDecode(jsonString);

      allSurahs = data.map((surah) => Surah.fromMap(surah)).toList();
      displaySurahs = List.from(allSurahs);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) {
    // if (_debounce?.isActive ?? false) _debounce!.cancel();
    final String safeQuery = query.trim();

    pageNumbers.clear();
    ayahSearchResults = null;
    displaySurahs.clear();
    //all surahs
    if (safeQuery.isEmpty) {
      displaySurahs = List.from(allSurahs);
      notifyListeners();
      return;
    }

    // specific pages
    if (isInt(safeQuery)) {
      num pageNum = toInt(safeQuery);
      if (pageNum > 0 && pageNum <= 604) {
        pageNumbers.add(pageNum.toInt());
      }
    } else {
      displaySurahs = allSurahs.where((surah) {
        return getSurahNameArabic(surah.id).contains(safeQuery);
      }).toList();
      final searchResult = searchWords(safeQuery);
      if (
          searchResult["occurences"] != null &&
          searchResult["occurences"] > 0) {
        ayahSearchResults = searchResult;
      }
    }
    notifyListeners();

  }
    @override
    void dispose() {
      _debounce?.cancel();
      super.dispose();
    }
}
