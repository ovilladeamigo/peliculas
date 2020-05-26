import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

import '../models/pelicula_model.dart';

class PeliculaProvider {
  String _apiKey = 'c67b3e13726cf1b849bc825fc110903f';
  String _url = 'api.themoviedb.org';
  String _language = 'es-UY';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> populares = new List();

  final _popularesStreamController =
      new StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '/3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language});

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];
    _cargando = true;

    _popularesPage++;

    print('Cargando siguientes... ');

    final url = Uri.https(_url, '/3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    populares.addAll(resp);

    popularesSink(populares);

    _cargando = false;

    return resp;
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodeData['results']);

    return peliculas.items;
  }
}
