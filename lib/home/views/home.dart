import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/homeController.dart';


class QuizScreen extends StatelessWidget {
  final QuizController controller = Get.put(QuizController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guessing Game'),
      ),
      body: Obx(() {
        if (controller.questions.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        final question = controller.questions[controller.currentQuestionIndex.value];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...question.answers.map((answer) {
              return RadioListTile<int>(
                title: Text(answer.answer),
                value: answer.id,
                groupValue: controller.selectedAnswerId.value,
                onChanged: (value) {
                  controller.selectedAnswerId.value = value!;
                },
              );
            }).toList(),
            SizedBox(height: 20),
            Obx(() => Text('Time remaining: ${controller.timeRemaining.value} seconds')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.submitAnswer,
              child: Text("Submit"),
            ),
          ],
        );
      }),
    );
  }
}

