import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educationbd/Models/AnswerModel.dart';
import 'package:educationbd/Models/CentralTestExamModel.dart';
import 'package:educationbd/Models/ExamResultModel.dart';
import 'package:educationbd/Models/CentralTestRulesModel.dart';
import 'package:educationbd/Models/CourseModel.dart';
import 'package:educationbd/Models/FlashCardModel.dart';
import 'package:educationbd/Models/FreeVideoModel.dart';
import 'package:educationbd/Models/LectureNoteModel.dart';
import 'package:educationbd/Models/LectureVideoModel.dart';
import 'package:educationbd/Models/MCQPreparationModel.dart';
import 'package:educationbd/Models/NoticeModel.dart';
import 'package:educationbd/Models/PackagePayments.dart';
import 'package:educationbd/Models/PaymentMethodModel.dart';
import 'package:educationbd/Models/PerformanceModel.dart';
import 'package:educationbd/Models/SliderModel.dart';
import 'package:educationbd/Models/SubjectModel.dart';
import 'package:educationbd/Models/TopicModel.dart';
import 'package:educationbd/Models/UserModel.dart';
import 'package:educationbd/Models/GeneralQuestionModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final localData = GetStorage();

  Future<bool> createUser(UserModel user) async {
    String id = FirebaseAuth.instance.currentUser.uid;
    try {
      await _firestore.collection("users").doc(id).set({
        'id': id,
        'name': user.name,
        'collegeName': user.collegeName,
        'phoneNumber': user.phoneNumber,
        'email': user.email,
        'lastExamName': user.lastExamName,
        'passingYear': user.passingYear,
        'courseId': user.courseId,
        'bloodGroup': user.bloodGroup,
        'profilePic': user.profilePic,
        'point': user.point,
        'package': user.package,
        'time': FieldValue.serverTimestamp(),
      });
      updateDashboardStudent(1);
      createPerformance();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateDashboardStudent(int value) async {
    try {
      await _firestore.collection('dashboard').doc("summary").update({
        'totalStudent': FieldValue.increment(value),
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateUserCourse(String courseId) async {
    String id = FirebaseAuth.instance.currentUser.uid;
    try {
      await _firestore.collection("users").doc(id).update({
        'courseId': courseId,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserModel> getUserData() async {
    UserModel user;
    try {
      await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          user = UserModel.fromDocumentSnapshot(documentSnapshot);
        } else {
          print('Document does not exist on the database');
        }
      });
      return user;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> checkUserData() async {
    bool exists = false;
    String uid = FirebaseAuth.instance.currentUser.uid;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get()
          .then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createPerformance() async {
    String id = FirebaseAuth.instance.currentUser.uid;
    try {
      await _firestore.collection("performance").doc(id).set({
        'id': id,
        'totalAttendExam': 0,
        'totalQuestion': 0,
        'totalAnswer': 0,
        'totalNoAnswer': 0,
        'totalCorrectAnswer': 0,
        'totalWrongAnswer': 0,
        'totalMark': 0,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updatePerformance(PerformanceModel model) async {
    String id = FirebaseAuth.instance.currentUser.uid;
    try {
      await _firestore.collection("performance").doc(id).update({
        'totalAttendExam': FieldValue.increment(1),
        'totalQuestion': FieldValue.increment(model.totalQuestion),
        'totalAnswer': FieldValue.increment(model.totalAnswer),
        'totalNoAnswer': FieldValue.increment(model.totalNoAnswer),
        'totalCorrectAnswer': FieldValue.increment(model.totalCorrectAnswer),
        'totalWrongAnswer': FieldValue.increment(model.totalWrongAnswer),
        'totalMark': FieldValue.increment(model.totalMark),
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<PerformanceModel> getUserPerformance() async {
    PerformanceModel performance;
    try {
      await _firestore
          .collection('performance')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          performance = PerformanceModel.fromDocumentSnapshot(documentSnapshot);
        } else {
          print('Document does not exist on the database');
        }
      });
      return performance;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<CourseModel>> getCourses() async {
    List<CourseModel> courses = [];
    try {
      await _firestore.collection('courses').get().then((value) {
        value.docs.forEach((element) {
          CourseModel model = CourseModel.fromDocumentSnapshot(element);
          courses.add(model);
        });
        return value;
      });
      return courses;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<SliderModel>> getSliders() async {
    List<SliderModel> slider = [];
    try {
      await _firestore.collection('sliders').get().then((value) {
        value.docs.forEach((element) {
          SliderModel model = SliderModel.fromDocumentSnapshot(element);
          slider.add(model);
        });
        return value.docs[0];
      });
      return slider;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<PaymentMethodModel>> getPaymentProviders() async {
    List<PaymentMethodModel> providers = [];
    try {
      await _firestore.collection('payment_provider').get().then((value) {
        value.docs.forEach((element) {
          PaymentMethodModel model =
              PaymentMethodModel.fromDocumentSnapshot(element);
          providers.add(model);
        });
        return value;
      });
      return providers;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> createPackagePayment(PackagePayments model) async {
    String id;
    if (model.id == null) {
      id = _firestore.collection("package_payment").doc().id.toString();
    } else {
      id = model.id;
    }

    try {
      await _firestore.collection("package_payment").doc(id).set({
        'id': id,
        'packageId': model.packageId,
        'userId': model.userId,
        'providerName': model.providerName,
        'providerNumber': model.providerNumber,
        'amount': model.amount,
        'transactionId': model.transactionId,
        'accept': false,
        'acceptTime': null,
        'reject': false,
        'rejectReason': "",
        'rejectTime': null,
        'time': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<SubjectModel>> getSubjects() async {
    List<SubjectModel> subjects = [];
    try {
      await _firestore
          .collection('subjects')
          .where('courseId', isEqualTo: localData.read('userCourse'))
          .get()
          .then((value) {
        value.docs.forEach((element) {
          SubjectModel model = SubjectModel();
          model.id = element.get('id');
          model.title = element.get('title');
          model.isPremium = element.get('isPremium');
          model.courseId = element.get('courseId');
          subjects.add(model);
        });
        return value;
      });
      return subjects;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> checkPremiumPackage(String subjectId) async {
    bool exists = false;
    String uid = FirebaseAuth.instance.currentUser.uid;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection('packages')
          .doc(subjectId)
          .get()
          .then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  Future<List<TopicModel>> getTopicsBySubject(String subjectId) async {
    List<TopicModel> topics = [];
    try {
      await _firestore
          .collection('topics')
          .where('subjectId', isEqualTo: subjectId)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          TopicModel model = TopicModel();
          model.id = element.get('id');
          model.title = element.get('title');
          model.subjectId = element.get('subjectId');
          topics.add(model);
        });
        return value;
      });
      return topics;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<FreeVideoModel>> getFreeVideo() async {
    List<FreeVideoModel> freeVideo = [];
    try {
      await _firestore.collection('free_video').get().then((value) {
        value.docs.forEach((element) {
          FreeVideoModel model = FreeVideoModel.fromDocumentSnapshot(element);
          freeVideo.add(model);
        });
        return value;
      });
      return freeVideo;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<FreeVideoModel> getFreeVideoById(String id) async {
    FreeVideoModel video;
    try {
      await _firestore
          .collection('free_video')
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          video = FreeVideoModel.fromDocumentSnapshot(documentSnapshot);
        } else {
          print('Document does not exist on the database');
        }
      });
      return video;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<LectureVideoModel>> getLectureVideoByTopic(String topicId) async {
    List<LectureVideoModel> lectureVideo = [];
    try {
      await _firestore
          .collection('lecture_video')
          .where('courseId', isEqualTo: localData.read('userCourse'))
          .where('topicId', isEqualTo: topicId)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          LectureVideoModel model =
              LectureVideoModel.fromDocumentSnapshot(element);
          lectureVideo.add(model);
        });
        return value;
      });
      return lectureVideo;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<LectureVideoModel> getLectureVideoById(String id) async {
    LectureVideoModel video;
    try {
      await _firestore
          .collection('lecture_video')
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          video = LectureVideoModel.fromDocumentSnapshot(documentSnapshot);
        } else {
          print('Document does not exist on the database');
        }
      });
      return video;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<CentralTestRulesModel>> getCentralTestRules() async {
    List<CentralTestRulesModel> rules = [];
    try {
      await _firestore.collection('central_test_rules').get().then((value) {
        value.docs.forEach((element) {
          CentralTestRulesModel model = CentralTestRulesModel();
          model.id = element.get('id');
          model.title = element.get('title');
          model.description = element.get('description');
          rules.add(model);
        });
        return value;
      });
      return rules;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<CentralTestExamModel> getCentralTestExamById(String id) async {
    CentralTestExamModel exam;
    try {
      await _firestore
          .collection('central_text_exam')
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          exam = CentralTestExamModel.fromDocumentSnapshot(documentSnapshot);
        } else {
          print('Document does not exist on the database');
        }
      });
      return exam;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<String>> getCentralTestAnswers(String examId) async {
    List<String> answers = [];
    try {
      await _firestore
          .collection("central_text_exam")
          .doc(examId)
          .collection("answers")
          .get()
          .then((value) {
        value.docs.forEach((element) {
          String val = element.get('answer');

          answers.add(val);
        });
        return value;
      });
      return answers;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> createExamResult(
      ExamResultModel model, List<AnswerModel> answers) async {
    String id = "${model.examId}+-+${model.userId}";
    try {
      await _firestore.collection("exam_result").doc(id).set({
        'id': id,
        'examId': model.examId,
        'examName': model.examName,
        'userId': model.userId,
        'questionLink': model.questionLink,
        'totalQuestion': model.totalQuestion,
        'totalAnswer': model.totalAnswer,
        'totalNoAnswer': model.totalNoAnswer,
        'totalCorrectAnswer': model.totalCorrectAnswer,
        'totalWrongAnswer': model.totalWrongAnswer,
        'mark': model.mark,
        'negativeMark': model.negativeMark,
        'time': FieldValue.serverTimestamp(),
      });
      for (int i = 0; i < answers.length; i++) {
        await _firestore
            .collection("exam_result")
            .doc(id)
            .collection("answers")
            .doc(i.toString())
            .set({
          'answer': answers[i].answer,
          'correctAnswer': answers[i].correctAnswer,
        });
      }
      PerformanceModel performance = PerformanceModel(
        totalQuestion: model.totalQuestion,
        totalCorrectAnswer: model.totalCorrectAnswer,
        totalWrongAnswer: model.totalWrongAnswer,
        totalAnswer: model.totalAnswer,
        totalNoAnswer: model.totalNoAnswer,
        totalMark: model.mark,
      );
      updatePerformance(performance);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<ExamResultModel> getCentralTestResultById(String id) async {
    ExamResultModel result;
    try {
      await _firestore
          .collection('exam_result')
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          result = ExamResultModel.fromDocumentSnapshot(documentSnapshot);
        } else {
          print('Document does not exist on the database');
        }
      });
      return result;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<AnswerModel>> getCentralTestResultAnswers(String examId) async {
    List<AnswerModel> answers = [];
    try {
      await _firestore
          .collection("exam_result")
          .doc(examId)
          .collection("answers")
          .get()
          .then((value) {
        value.docs.forEach((element) {
          AnswerModel model = new AnswerModel(
              answer: element.get('answer'),
              correctAnswer: element.get('correctAnswer'));

          answers.add(model);
        });
        return value;
      });
      return answers;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<MCQPreparationModel>> getMCQPreparationsByTopic(
      String topicId) async {
    List<MCQPreparationModel> preparations = [];
    try {
      await _firestore
          .collection('mcq_preparation')
          .where('courseId', isEqualTo: localData.read('userCourse'))
          .where('topicId', isEqualTo: topicId)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          MCQPreparationModel model =
              MCQPreparationModel.fromDocumentSnapshot(element);
          preparations.add(model);
        });
        return value;
      });
      return preparations;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<MCQPreparationModel> getMCQPreparationsById(String id) async {
    MCQPreparationModel preparation;
    try {
      await _firestore
          .collection('mcq_preparation')
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          preparation =
              MCQPreparationModel.fromDocumentSnapshot(documentSnapshot);
        } else {
          print('Document does not exist on the database');
        }
      });

      return preparation;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<String>> getMCQPreparationAnswers(String examId) async {
    List<String> answers = [];
    try {
      await _firestore
          .collection("mcq_preparation")
          .doc(examId)
          .collection("answers")
          .get()
          .then((value) {
        value.docs.forEach((element) {
          String val = element.get('answer');

          answers.add(val);
        });
        return value;
      });
      return answers;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<FlashCardModel>> getFlashCardsByTopic(String topicId) async {
    List<FlashCardModel> flashCards = [];
    try {
      await _firestore
          .collection('flash_card')
          .where('topicId', isEqualTo: topicId)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          FlashCardModel model = FlashCardModel.fromDocumentSnapshot(element);
          flashCards.add(model);
        });
        return value;
      });
      return flashCards;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<LectureNoteModel>> getLectureNoteByTopic(String topicId) async {
    List<LectureNoteModel> lectureNotes = [];
    try {
      await _firestore
          .collection('lecture_note')
          .where('topicId', isEqualTo: topicId)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          LectureNoteModel model =
              LectureNoteModel.fromDocumentSnapshot(element);
          lectureNotes.add(model);
        });
        return value;
      });
      return lectureNotes;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<LectureNoteModel> getLectureNoteById(String id) async {
    LectureNoteModel notice;
    try {
      await _firestore
          .collection('lecture_note')
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          notice = LectureNoteModel.fromDocumentSnapshot(documentSnapshot);
        } else {
          print('Document does not exist on the database');
        }
      });

      return notice;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<GeneralQuestionModel>> getGeneralQuestions() async {
    List<GeneralQuestionModel> questions = [];
    try {
      await _firestore.collection('general_question').get().then((value) {
        value.docs.forEach((element) {
          GeneralQuestionModel model =
              GeneralQuestionModel.fromDocumentSnapshot(element);
          questions.add(model);
        });
        return value;
      });
      return questions;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<NoticeModel>> getNotices() async {
    List<NoticeModel> packages = [];
    try {
      await _firestore.collection('notice').where('courseId', isEqualTo: localData.read('userCourse')).get().then((value) {
        value.docs.forEach((element) {
          NoticeModel model = NoticeModel.fromDocumentSnapshot(element);
          packages.add(model);
        });
        return value;
      });
      return packages;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<NoticeModel> getNoticeById(String id) async {
    NoticeModel notice;
    try {
      await _firestore
          .collection('notice')
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          notice = NoticeModel.fromDocumentSnapshot(documentSnapshot);
        } else {
          print('Document does not exist on the database');
        }
      });

      return notice;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
