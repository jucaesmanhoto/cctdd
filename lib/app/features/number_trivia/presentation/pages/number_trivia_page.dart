import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../mobx/number_trivia_controller.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display_widget.dart';
import '../widgets/trivia_display_widget.dart';

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
      body: SingleChildScrollView(child: _buildBody(context)),
    );
  }

  _buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Observer(
              builder: (_) {
                if (controller.isLoading) {
                  return LoadingWidget();
                } else if (controller.error != null) {
                  return MessageDisplay(
                    message: controller.error.message,
                  );
                } else if (controller.triviaModel == null) {
                  return MessageDisplay(
                    message: 'Start Searching',
                  );
                }

                return TriviaDisplay(trivia: controller.triviaModel);
              },
            ),
            SizedBox(height: 20),
            TriviaControls()
          ],
        ),
      ),
    );
  }
}

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState
    extends ModularState<TriviaControls, NumberTriviaController> {
  final TextEditingController _textController = TextEditingController();
  String _inputString = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _textController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            setState(() {
              _inputString = value;
            });
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text('Search'),
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: dispatchConcrete,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                child: Text('Get random trivia'),
                onPressed: dispatchRandom,
              ),
            )
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    _textController.clear();
    controller.getTriviaForConcreteNumber(string: _inputString);
    _inputString = '';
  }

  void dispatchRandom() {
    _textController.clear();
    controller.getTriviaForRandomNumber();
    _inputString = '';
  }
}
