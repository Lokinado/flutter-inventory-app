/// Ten plik jest odpowiedzialny za pobieranie informacji nt budynków, pięter
/// lub sal - pobrane wyniki są zwracane jako listy danych
/// zostaje on użyty w pick_place_page.dart i change_place_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Funkcja znajduąca indeks danego elementu na liście, wiedząc którą listę
/// trzeba przejrzeć, i jaki numer jest szukany
int znajdzNaLiscie(List lista, wartosc) {
  for (int i = 0; i < lista.length; i++) {
    if (lista[i][0].contains(wartosc)) {
      return i;
    }
  }
  return -1;
}

/// Funkcja zwracająca dwie listy, budynków i numerów budynków;
/// pierwsza zwraca listę list, gdzie każdy element to lista skłądająca się
/// z nazwy budynku i jego identyfikatora, a druga zwraca listę samych numerów
Future<List<String>> pobierzBudynki() async {
  var listaBudynkow =
      await FirebaseFirestore.instance.collection('Building').get();

  List<String> lisbud = [];

  for (var doc in listaBudynkow.docs) {
    lisbud.add(doc.id.toString());
  }

  return lisbud;
}

/// Funkcja pobierająca informację o wybranym budynku, i zwracająca tablicę
/// napisów reprezentujących numerów pięter (przygotowanie na nr. piętra z lierą)
Future<List<String>> pobierzPietra(wybranyBudynekId) async {
  var listaPomie = await FirebaseFirestore.instance
      .collection("/Building/$wybranyBudynekId/Floors")
      .get();

  List<String> numpietra = [];

  for (var doc in listaPomie.docs) {
    numpietra.add(doc.id.toString());
  }

  return numpietra;
}

/// Funkcja pobierająca informację o wybranym budynku i piętrze, a zwracająca
/// listę pomieszczeń, w tym budynku, na tym piętrze
Future<List<String>> pobierzPomieszczenia(
    wybranyBudynekId, wybranePietroId) async {
  var listaPom = await FirebaseFirestore.instance
      .collection("/Building/$wybranyBudynekId/Floors/$wybranePietroId/Rooms")
      .get();

  List<String> numPom = [];

  for (var doc in listaPom.docs) {
    numPom.add(doc.id.toString());
  }

  return numPom;
}

Future<List<List<String>>> pobieraniePrzedmiotow(
    wybranyBudynekId, wybranePietroId, wybranePomId) async {
  var collection = await FirebaseFirestore.instance.collection(
      "/Building/$wybranyBudynekId/Floors/$wybranePietroId/Rooms/$wybranePomId/Items");

  var querySnapshot = await collection.get();

  List<List<String>> pom = [];

  for (var doc in querySnapshot.docs) {
    var dane = doc.data();
    List<String> item = [];
    item.add(doc.id.toString());
    item.add(dane["comment"].toString());
    item.add(dane["typ"].toString());

    pom.add(item);
  }
  print(pom);
  return pom;
}
