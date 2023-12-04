import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_silver/model/actors.dart';
import 'package:movie_silver/services/api_constants.dart';
import 'package:movie_silver/services/endpoints.dart';
import 'package:movie_silver/services/function.dart';
import 'package:movie_silver/src/actors_detail.dart';
import 'package:movie_silver/src/searchactors.dart';
import 'package:movie_silver/src/widgets.dart';
import 'package:page_transition/page_transition.dart';

class ActorsScreen extends StatefulWidget {
  const ActorsScreen({super.key});

  @override
  State<ActorsScreen> createState() => _ActorsScreenState();
}

class _ActorsScreenState extends State<ActorsScreen> {
  List<Actors>? actors;
  List<Actors>? popularActors;
  List<Actors>? discover;
  final random = Random();
  

  @override
  void initState() {
    super.initState();
    fetchActors(Endpoints.popularActors(random.nextInt(100) + 1)).then((value) {
      setState(() {
        actors = value;
      });
    });
    fetchActors(Endpoints.popularActors(random.nextInt(30) + 1)).then((value) {
      setState(() {
        popularActors = value;
      });
    });
    fetchActors(Endpoints.popularActors(random.nextInt(100) + 31)).then((value) {
      setState(() {
        discover = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/1.png',
              fit: BoxFit.cover,
              height: 40,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'MSmdb',
              style: GoogleFonts.bangers(fontSize: 20),
            ),
          ],
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white70,
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const SearchActorsScreen()));
              })
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            width: double.infinity,
            height: 350,
            child: actors == null
                ?  CarouselSlider.builder(
                    itemCount: 10,
                    options: CarouselOptions(
                      height: 300,
                      autoPlay: true,
                      viewportFraction: 0.55,
                      enlargeCenterPage: true,
                      pageSnapping: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration: const Duration(seconds: 1),
                    ),
                    itemBuilder:
                        (BuildContext context, int index, pageViewIndex) {
                      return SizedBox(
                              height: 200,
                              width: 300,
                              child:  Image.asset(
                                      filterQuality: FilterQuality.high,
                                          fit: BoxFit.cover,
                                      'assets/images/6.png'),
                            );
                    })
                : CarouselSlider.builder(
                    itemCount: 10,
                    options: CarouselOptions(
                      height: 300,
                      autoPlay: true,
                      viewportFraction: 0.55,
                      enlargeCenterPage: true,
                      pageSnapping: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration: const Duration(seconds: 1),
                    ),
                    itemBuilder:
                        (BuildContext context, int index, pageViewIndex) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: ActorsDetailPage(
                                    actorId: actors![index].id!,
                                    
                                  )));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.cover,
                            '${TMDB_BASE_IMAGE_URL}w500/${actors![index].profile_path!}',
                          ),
                        ),
                      );
                    }),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Popular Actors'),
              ),
            ],
          ),
          PopularActors(
            api: Endpoints.popularActors(random.nextInt(30) + 1),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Discover'),
              ),
            ],
          ),
          discover == null
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 256, crossAxisCount: 2),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                            height: 200,
                            width: 300,
                            child: Image.asset(
                              filterQuality: FilterQuality.high,
                                  fit: BoxFit.cover,
                              'assets/images/6.png'),
                          ),
                    );
                  },
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 256, crossAxisCount: 2),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: discover!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                           Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: ActorsDetailPage(
                                      actorId: discover![index].id!,
                                       
                                      ))); 
                        },
                        child: SizedBox(
                          width: 100,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.cover,
                                    '${TMDB_BASE_IMAGE_URL}w500/${discover![index].profile_path!}',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  discover![index].name!,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }
}
