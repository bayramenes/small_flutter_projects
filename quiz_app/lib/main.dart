import 'package:flutter/material.dart';

import './quiz.dart';
import './result.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _totalScore = 0;
  var _questionIndex = 0;
  final _questions = [
    {
      'text': "What's your favorite color? ",
      "answers": [
        {"text": "Red", "score": 6},
        {"text": "Green", "score": 4},
        {"text": "Blue", "score": 5},
        {"text": "Black", "score": 10}
      ],
    },
    {
      'text': "what's your favorite animal? ",
      "answers": [
        {"text": "Rabbit", "score": 4},
        {"text": "Snake", "score": 8},
        {"text": "Lion", "score": 6},
        {"text": "Tiger", "score": 8}
      ],
    },
    {
      'text': "What's your favorite country? ",
      "answers": [
        {"text": "Turkey", "score": 3},
        {"text": "China", "score": 10},
        {"text": "Green", "score": 4},
        {"text": "Russia", "score": 8}
      ],
    },
  ];
  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answered(int Score) {
    _totalScore += Score;
    print(_totalScore);
    setState(() {
      _questionIndex += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Quiz App"),
        ),
        body: _questionIndex < _questions.length
            ? Quiz(
                questions: _questions,
                questionIndex: _questionIndex,
                answered: _answered)
            : Result(_totalScore, _resetQuiz),
      ),
    );
  }
}
