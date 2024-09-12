import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../model/model.dart';
import '../views/scoreScreen.dart';
import '../views/start.dart';

class QuizController extends GetxController {
  var questions = <Question>[].obs;
  var currentQuestionIndex = 0.obs;
  var timeRemaining = 30.obs;
  var selectedAnswerId = (-1).obs;
  var score = 0.obs;
  Timer? timer;  // Make timer nullable to handle cancellation

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
  }

  void loadQuestions() async {
    final String response = await rootBundle.loadString('assets/questions.json');
    final data = await json.decode(response) as List;
    questions.value = data.map((question) => Question.fromJson(question)).toList();

    if (questions.isNotEmpty) {
      startTimer(); // Start the timer only after ensuring questions are loaded
    }
  }

  void startTimer() {
    timer?.cancel();  // Cancel any existing timer before starting a new one
    timeRemaining.value = 30;  // Reset time for the new question
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.value > 0) {
        timeRemaining.value--;
      } else {
        nextQuestion();
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      if (selectedAnswerId.value == questions[currentQuestionIndex.value].correctAnswerId) {
        score.value++;
      }
      currentQuestionIndex.value++;
      selectedAnswerId.value = -1;
      startTimer();  // Restart the timer for the next question
    } else {
      timer?.cancel();
      Get.to(() => ScoreScreen(score: score.value, totalQuestions: questions.length));
    }
  }

  void submitAnswer() {
    if (selectedAnswerId.value == questions[currentQuestionIndex.value].correctAnswerId) {
      score.value++;
    }

    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      selectedAnswerId.value = -1; // Reset selected answer for the next question
      startTimer();  // Restart the timer for the next question
    } else {
      timer?.cancel();
      Get.to(() => ScoreScreen(score: score.value, totalQuestions: questions.length));
    }
  }

  void resetQuiz() {
    timer?.cancel();  // Cancel the timer when resetting the quiz
    currentQuestionIndex.value = 0;
    score.value = 0;
    timeRemaining.value = 30;
    selectedAnswerId.value = -1;
    Get.offAll(() => StartScreen());  // Return to the StartScreen
  }

  @override
  void onClose() {
    timer?.cancel();  // Ensure the timer is canceled when the controller is disposed of
    super.onClose();
  }
  @override
  void onReady(){
    _saveDeviceToken();
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('notification_icon');
    var initializationSettingsIOS = new DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {},
    );
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android;
      AppleNotification ios;
      if (GetPlatform.isIOS) {
        ios = message.notification!.apple!;
        if (notification != null && ios != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              const NotificationDetails(
                iOS: DarwinNotificationDetails(),
              ));
        }
      } else {
        android = message.notification!.android!;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  //color: AppColors.primaryColor,
                  icon: 'notification_icon',
                ),
              ));
        }
      }
      print("Message : ${message.data}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
  _saveDeviceToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM token : $fcmToken");
    if (fcmToken != null) {
      // await HiveStore().put(Keys.FCM, fcmToken);
      // Hive.box(HiveString.hiveName).put(HiveString.fcmToken,fcmToken);
    }
  }
}
