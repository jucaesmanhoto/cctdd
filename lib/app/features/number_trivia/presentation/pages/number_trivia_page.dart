import 'package:cctdd/app/features/number_trivia/presentation/mobx/number_trivia_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NumberTriviaPage extends StatefulWidget {
  @override
  _NumberTriviaPageState createState() => _NumberTriviaPageState();
}

class _NumberTriviaPageState
    extends ModularState<NumberTriviaPage, NumberTriviaController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Container(
          height: MediaQuery.of(context).size.height / 2,
          child: Placeholder(),
        ),
        SizedBox(height: 20),
        Column(
          children: <Widget>[
            Placeholder(
              fallbackHeight: 30,
              fallbackWidth: 100,
            ),
            Placeholder(
              fallbackHeight: 40,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Placeholder(fallbackHeight: 30),
                ),
                Expanded(
                  child: Placeholder(fallbackHeight: 30),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
