import 'package:flutter/material.dart';
import 'package:gamming/home/views/start.dart';
import 'package:get/get.dart';

import '../controller/homeController.dart';

class ScoreScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

   ScoreScreen({Key? key, required this.score, required this.totalQuestions}) : super(key: key);
  final QuizController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Score'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(
              'You scored:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '$score / $totalQuestions',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.find<QuizController>().resetQuiz();
                Get.offAll(StartScreen());
              },
              child: Text('Reset Game'),
            ),
          ],
        ),
      ),
    );
  }
}
