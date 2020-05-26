import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal_widget.dart';

import '../models/pelicula_model.dart';

class HomePage extends StatelessWidget {
  final _peliculaProvider = new PeliculaProvider();

  @override
  Widget build(BuildContext context) {
    _peliculaProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        title: Text("Películas en cine"),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[_swiperTarjetas(), _footer(context)],
        ),
      ),
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
        future: _peliculaProvider.getEnCines(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return CardSwiper(peliculas: snapshot.data);
          } else {
            return Container(
                height: 400.0,
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Populares',
                  style: Theme.of(context).textTheme.subtitle2)),
          SizedBox(
            height: 5.0,
          ),
          StreamBuilder(
              stream: _peliculaProvider.popularesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Pelicula>> snapshot) {
                if (snapshot.hasData) {
                  return MovieHorizontal(
                      peliculas: snapshot.data,
                      siguientePagina: _peliculaProvider.getPopulares);
                } else {
                  return Container(
                      height: 400.0,
                      child: Center(child: CircularProgressIndicator()));
                }
              })
        ],
      ),
    );
  }
}
