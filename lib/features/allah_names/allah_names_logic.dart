import 'dart:io';
import 'dart:convert';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:path_provider/path_provider.dart';

class AllahNamesLogic {
  List<Map<String, String>> data = [];
  Future<void> fetchData() async {
    final Uri _url = Uri.parse(
      'https://surahquran.com/99-Names-of-Allah-with-Meaning.html',
    );
    try {
      final response = await http.get(_url);
      if (response.statusCode == 200) {
          final utf8Body = utf8.decode(response.bodyBytes);
        //get the body of html page and convert to clear document
        dom.Document document = parser.parse(utf8Body);
        // get all h3 elements in page to get the specific element
        // final h3Elements = document.querySelectorAll("h3");
        // dom.Element? targetHeading;
        // //looping on all h3 elements and select the specific heading and store it
        // for (var h3 in h3Elements) {
        //   //check if the h3 has same data which i search for (title: شرح أسماء الله الحسنى وتفسير معانيها)
        //   if (h3.text.trim().contains("شرح أسماء الله الحسنى وتفسير معانيها")) {
        //     targetHeading = h3;
        //     break; // to save more rounds
        //   }
        // }
        // // protect the application if the h3 doesn't exist
        // if (targetHeading == null) {
        //   print("there is problem in store \"targetHeading\"");
        // }
        // get the table which after the target heading

        dom.Element? table = document.querySelector('.navigation-area table');

        // dom.Element? nextSibling = targetHeading!.nextElementSibling;
        // while (nextSibling != null) {
        //   if (nextSibling.localName == 'table') {
        //     table = nextSibling;
        //     break;
        //   }
        //   nextSibling = nextSibling.nextElementSibling;
        // }
        // protect the application if the h3 doesn't exist
        if (table == null) {
          print("there is problem: table not found inside navigation-area");
          return;
        }

        // create list of map to store the data
        List<Map<String, String>> namesList = [];

        // create list with table ROWs data:
        final rows = table.querySelectorAll('tr');

        //looping on rows and save each row data
        for (int i = 1; i < rows.length; i++) {
          final column = rows[i].querySelectorAll('td');
          if (column.length >= 2) {
            String name = column[0].text.trim();
            String meaning = column[1].text.trim();
            namesList.add({'name': name, 'meaning': meaning});
          }
        }

        String jsonString = jsonEncode(namesList);
        final directory = await getApplicationDocumentsDirectory();
        final file = File(
          "${directory.path}/allah_names_storage_from_web.json",
        );
        await file.writeAsString(jsonString);
      } else {
        print("no enternet connection or the link is incorrect");
      }
    } catch (e) {
      print("there is exception accoured when fetching data from web e: $e");
    }
  }

  Future<List<dynamic>> loadSavedNames() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/allah_names_storage_from_web.json");
      if (await file.exists()) {
        String content = await file.readAsString();
        print(content);
        return jsonDecode(content);
      }
    } catch (e) {
      print("error has accoured when load saved names");
    }
    return [];
  }
}
