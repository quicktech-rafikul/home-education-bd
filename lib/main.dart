import 'package:educationbd/Screens/CentralTest/CentralTestRules.dart';
import 'package:educationbd/Screens/MCQPreparation/MCQList.dart';
import 'package:educationbd/Screens/More/More.dart';
import 'package:educationbd/Screens/MyPackages/MyPackageDetails.dart';
import 'package:educationbd/Screens/MyPackages/MyPackageList.dart';
import 'package:educationbd/Screens/Notice/NoticeList.dart';
import 'package:educationbd/Screens/Notice/NoticeView.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:educationbd/Screens/Auth/Login.dart';
import 'package:educationbd/Screens/Auth/OTPVerification.dart';
import 'package:educationbd/Screens/Auth/Registration.dart';
import 'package:educationbd/Screens/CentralTest/AnswerPage.dart';
import 'package:educationbd/Screens/CentralTest/CentralTests.dart';
import 'package:educationbd/Screens/CentralTest/MeritPage.dart';
import 'package:educationbd/Screens/CentralTest/PreviousCentralTests.dart';
import 'package:educationbd/Screens/Dashboard/Dashboard.dart';
import 'package:educationbd/Screens/Dashboard/UpDashboard.dart';
import 'package:educationbd/Screens/Exam/ExamPage.dart';
import 'package:educationbd/Screens/FlashCard/FlashCardList.dart';
import 'package:educationbd/Screens/FlashCard/FlashCardSubjectList.dart';
import 'package:educationbd/Screens/FlashCard/FlashCardTopicList.dart';
import 'package:educationbd/Screens/LectureNotice/LectureNoticeList.dart';
import 'package:educationbd/Screens/LectureNotice/LectureNoticeSubjectList.dart';
import 'package:educationbd/Screens/LectureNotice/LectureNoticeTopicList.dart';
import 'package:educationbd/Screens/LectureNotice/LectureNoticeView.dart';
import 'package:educationbd/Screens/MCQPreparation/MCQPreparation.dart';
import 'package:educationbd/Screens/MCQPreparation/MCQSubjectList.dart';
import 'package:educationbd/Screens/MCQPreparation/MCQTopicList.dart';
import 'package:educationbd/Screens/Package/PackageDetails.dart';
import 'package:educationbd/Screens/Package/PackageList.dart';
import 'package:educationbd/Screens/Package/Payment.dart';
import 'package:educationbd/Screens/Performance/Performance.dart';
import 'package:educationbd/Screens/Profile/Profile.dart';
import 'package:educationbd/Screens/Profile/ProfileEdit.dart';
import 'package:educationbd/Screens/SplashScreen.dart';
import 'package:educationbd/Screens/Video/VideoLectureList.dart';
import 'package:educationbd/Screens/Video/VideoLectureSubject.dart';
import 'package:educationbd/Screens/Video/VideoLectureTopic.dart';
import 'package:educationbd/Screens/Video/VideoPlayerScreen.dart';
import 'package:educationbd/Screens/Video/OfflineVideoList.dart';
import 'package:educationbd/Screens/GeneralQuestions/GeneralQuestions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: UIColors.bgc1,
        statusBarIconBrightness: Brightness.light),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await FirebaseMessaging.instance.subscribeToTopic('educationBD');

  FirebaseMessaging.instance.getInitialMessage();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            styleInformation: BigTextStyleInformation(''),
            icon: 'launcher_icon',
          ),
        ),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    Get.toNamed('/');
  });

  await GetStorage.init();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    defaultTransition: Transition.noTransition,
    getPages: [
      GetPage(name: '/', page: () => QuickTechIT_SplashScreen()),
      GetPage(
          name: '/login',
          page: () => QuickTechIT_Login(),
          transition: Transition.zoom),
      GetPage(
          name: '/otpVerification/:phoneNumber',
          page: () => QuickTechIT_OTPVerification()),
      GetPage(name: '/reg', page: () => QuickTechIT_Registration()),
      GetPage(
          name: '/home',
          page: () => QuickTechIT_UpDashboard(),
          transition: Transition.zoom),
      GetPage(
          name: '/dashboard',
          page: () => QuickTechIT_Dashboard(),
          transition: Transition.zoom),
      GetPage(name: '/packages', page: () => QuickTechIT_Packages()),
      GetPage(
          name: '/package/details/:id',
          page: () => QuickTechIT_PackageDetails()),
      GetPage(name: '/payment/:packageId', page: () => QuickTechIT_Payment()),
      GetPage(name: '/examPage/:type/:id', page: () => QuickTechIT_ExamPage()),
      GetPage(name: '/centralTest', page: () => QuickTechIT_CentralTests()),
      GetPage(
          name: '/centralTest/previous',
          page: () => QuickTechIT_PreviousCentralTests()),
      GetPage(
          name: '/centralTest/rules',
          page: () => QuickTechIT_CentralTestRules()),
      GetPage(name: '/answerPage/:id', page: () => QuickTechIT_AnswerPage()),
      GetPage(name: '/meritPage/:id', page: () => QuickTechIT_MeritPage()),
      GetPage(
          name: '/videoLectureSubject',
          page: () => QuickTechIT_VideoLectureSubject()),
      GetPage(
          name: '/videoLectureTopic/:subjectId',
          page: () => QuickTechIT_VideoLectureTopic()),
      GetPage(
          name: '/videoLectureList/:topicId',
          page: () => QuickTechIT_VideoLectureList()),
      GetPage(
          name: '/offlineVideoList',
          page: () => QuickTechIT_OfflineVideoList()),
      GetPage(
          name: '/videoPlayer/:type/:id',
          page: () => QuickTechIT_VideoPlayerScreen()),
      GetPage(name: '/mcq', page: () => QuickTechIT_MCQPreparation()),
      GetPage(name: '/mcq/subject', page: () => QuickTechIT_MCQSubjectList()),
      GetPage(
          name: '/mcq/topic/:subjectId',
          page: () => QuickTechIT_MCQTopicList()),
      GetPage(name: '/mcq/list/:topicId', page: () => QuickTechIT_MCQList()),
      GetPage(
          name: '/flashCard/subjects',
          page: () => QuickTechIT_FlashCardSubjectList()),
      GetPage(
          name: '/flashCard/topics/:subjectId',
          page: () => QuickTechIT_FlashCardTopicList()),
      GetPage(
          name: '/flashCards/:topicId',
          page: () => QuickTechIT_FlashCardList()),
      GetPage(
          name: '/notice/subjects',
          page: () => QuickTechIT_LectureNoticeSubjectList()),
      GetPage(
          name: '/notice/topics/:subjectId',
          page: () => QuickTechIT_LectureNoticeTopicList()),
      GetPage(
          name: '/notice/list/:topicId',
          page: () => QuickTechIT_LectureNoticeList()),
      GetPage(
          name: '/noticeView/:id', page: () => QuickTechIT_LectureNoticeView()),
      GetPage(name: '/profile', page: () => QuickTechIT_Profile()),
      GetPage(name: '/profile/edit', page: () => QuickTechIT_ProfileEdit()),
      GetPage(name: '/performance', page: () => QuickTechIT_Performance()),
      GetPage(
          name: '/generalQuestions',
          page: () => QuickTechIT_GeneralQuestions()),
      GetPage(name: '/packages/my', page: () => QuickTechIT_MyPackageList()),
      GetPage(
          name: '/package/my/:id', page: () => QuickTechIT_MyPackageDetails()),
      GetPage(name: '/noticeList', page: () => QuickTechIT_NoticeList()),
      GetPage(name: '/notice/view/:id', page: () => QuickTechIT_NoticeView()),
      GetPage(name: '/more', page: () => QuickTechIT_More()),
    ],
  ));
}
