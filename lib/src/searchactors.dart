
import 'package:flutter/material.dart';
import 'package:movie_silver/model/actors.dart';
import 'package:movie_silver/services/api_constants.dart';
import 'package:movie_silver/services/endpoints.dart';
import 'package:movie_silver/services/function.dart';
import 'package:movie_silver/src/actors_detail.dart';
import 'package:page_transition/page_transition.dart';

class SearchActorsScreen extends StatefulWidget {
  const SearchActorsScreen({super.key});

  @override
  State<SearchActorsScreen> createState() => _SearchActorsScreenState();
}

class _SearchActorsScreenState extends State<SearchActorsScreen> {
  String? text = '';
    List<Actors>? actorsList;
    final FocusNode _focusNode = FocusNode();
      @override
  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TextFormField(
            focusNode: _focusNode,
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 2.0),
              ),
              errorStyle: const TextStyle(color: Colors.grey),
              hintText: 'search actors',
              filled: false,
              fillColor: Colors.transparent,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.transparent, width: 2),
              ),
            ),
            onChanged: (value) {
              setState(() {
                text = value;
                fetchActors(Endpoints.personSearchUrl(text!)).then((value) {
                  setState(() {
                    actorsList = value;
                  });
                });
              });
            },
          ),
        ),
        body: Container(
          child: actorsList == null
              ? Container()
              : actorsList!.isEmpty
                  ? const Center(
                      child: Text(
                        "Oops! couldn't find the actors",
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: actorsList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 60,
                                    height: 80,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(8.0),
                                      child: actorsList![index].profile_path ==
                                              null
                                          ? Image.asset(
                                              'assets/images/3.png',
                                              fit: BoxFit.cover,
                                            )
                                          : GestureDetector(
                                            onTap: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: ActorsDetailPage(
                                                  actorId: actorsList![index].id!,
                                                )));
                                      },
                                            child: Image.network(
                                                filterQuality:
                                                    FilterQuality.high,
                                                fit: BoxFit.cover,
                                                '${TMDB_BASE_IMAGE_URL}w500/${actorsList![index].profile_path!}',
                                              ),
                                          ),
                                    ),
                                  ),
                                   Padding(
                                     padding: const EdgeInsets.all(15.0),
                                     child: SizedBox(
                                      width: 230,
                                       child: Text(
                                                actorsList![index].name!,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                     ),
                                   ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        )
    );
  }
}
