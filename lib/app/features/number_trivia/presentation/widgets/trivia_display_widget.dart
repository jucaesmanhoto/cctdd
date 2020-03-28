import 'package:flutter/material.dart';

import '../../data/models/number_trivia_model.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTriviaModel trivia;
  const TriviaDisplay({
    Key key,
    @required this.trivia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: <Widget>[
          Text(
            trivia.number.toString(),
            style: TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  trivia.text,
                  style: TextStyle(fontSize: 24.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
