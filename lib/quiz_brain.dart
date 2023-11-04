import 'dart:convert';
import 'dart:math';
import 'const.dart';
import 'package:http/http.dart' as http;

class QuizBrain {
  int _questionNumber = 0;
  List<Question> _questions = [];

  QuizBrain() {
    fetchPokemonList();
  }

  Future<void> fetchPokemonList() async {
    final response = await http.get(Uri.parse(pokeApiUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];

      for (var result in results) {
        final name = result['name'];
        _questions.add(Question(name, false)); 
      }

      
      final randomIndex = Random().nextInt(results.length);
      _questions[randomIndex] = Question(results[randomIndex]['name'], true);
    } else {
      throw Exception('Erro ao buscar a lista de Pokémon');
    }
  }

  String getQuestionText() {
    return _questions[_questionNumber].text;
  }

  bool getQuestionAnswer() {
    return _questions[_questionNumber].answer;
  }

  bool isChoiceCorrect(bool choice) {
    return _questions[_questionNumber].answer == choice;
  }

  void nextQuestion() {
    if (_questionNumber < _questions.length - 1) {
      _questionNumber++;
    }
  }

  bool isFinished() {
    return _questionNumber == _questions.length - 1;
  }

  void reset() {
    _questionNumber = 0;
  }
}

class Question {
  String text;
  bool answer;

  Question(this.text, this.answer);
}