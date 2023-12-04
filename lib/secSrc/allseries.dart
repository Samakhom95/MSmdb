import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_silver/model/actorseries.dart';
import 'package:movie_silver/services/api_constants.dart';
import 'package:movie_silver/services/endpoints.dart';
import 'package:movie_silver/services/function.dart';

class AllSeriesScreen extends StatefulWidget { 
  final int actorId;
  final String name;
  const AllSeriesScreen({super.key, required this.actorId, required this.name});

  @override
  State<AllSeriesScreen> createState() => _AllSeriesScreenState();
}

class _AllSeriesScreenState extends State<AllSeriesScreen> {
    List<ActorsSeries>? actorSeriesList;
      String apiKey = '91da303c9cc4cea1a33482ca684c4f20';

  @override
  void initState() {
    super.initState();
    fetchActorSeries(Endpoints.actorsSeries(widget.actorId)).then((value) {
      setState(() {
        actorSeriesList = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: actorSeriesList ==null
      ?Container()
      :
      ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.name,
                  ),
                ),
                const Text(
                  'Series',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '(${actorSeriesList!.length.toString()})',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            actorSeriesList == null
                ? const Center(
                    child: SpinKitWave(
                      color: Colors.white,
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: screenHeight,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: actorSeriesList?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: 100,
                            height: 260,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                actorSeriesList![index].posterPath == null
                                    ? Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            filterQuality: FilterQuality.high,
                                            fit: BoxFit.cover,
                                            'assets/images/4.png',
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            fit: BoxFit.cover,
                                            '${TMDB_BASE_IMAGE_URL}w500/${actorSeriesList![index].posterPath!}',
                                          ),
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    actorSeriesList![index].name!,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ]),
    );
  }
}