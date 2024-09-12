import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/homeController.dart';
import 'home.dart';


class StartScreen extends StatelessWidget {
  final QuizController controller = Get.put(QuizController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guessing Game'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.find<QuizController>().resetQuiz();
            controller.startTimer(); // Start the timer when the game begins
            Get.to(() => QuizScreen());// Reset the quiz before starting
          },
          child: const Text('Start Game'),
        ),
      ),
    );
  }
}
