// import 'package:educationbd/Controller/AuthController.dart';
// import 'package:educationbd/Models/CourseModel.dart';
// import 'package:educationbd/Screens/Code/CheckLogin.dart';
// import 'package:educationbd/Services/Database.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:responsive_flutter/responsive_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import 'UI_Colors.dart';
//
// class NavigationDrawer extends StatefulWidget {
//   @override
//   _NavigationDrawerState createState() => _NavigationDrawerState();
// }
//
// class _NavigationDrawerState extends State<NavigationDrawer> {
//
//   final localData = GetStorage();
//
//   List<CourseModel> courses = [];
//
//   @override
//   void initState() {
//     Database().getCourses().then((value) {
//       setState(() {
//         courses = value;
//       });
//     });
//     super.initState();
//   }
//
//   _launchURL() async {
//     const url = 'https://quicktech-ltd.com/';
//     if (await canLaunch(url)) {
//       await launch(
//         url,
//       );
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Drawer(
//         child: Container(
//           color: Colors.white,
//           child: Column(
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: SingleChildScrollView(
//                   physics: BouncingScrollPhysics(),
//                   child: ListView(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       children: <Widget>[
//                         Container(
//                           color: Colors.white,
//                           child: Column(
//                             children: <Widget>[
//                               Container(
//                                   width: Get.width,
//                                   height: 120,
//                                   color: UIColors.primaryColor2,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         localData.read('userName'),
//                                         style: TextStyle(
//                                             fontSize:
//                                                 ResponsiveFlutter.of(context)
//                                                     .fontSize(2.5),
//                                             color: Colors.white),
//                                       ),
//                                       SizedBox(
//                                         height: 2,
//                                       ),
//                                       Text(
//                                         localData.read('userMobile'),
//                                         style: TextStyle(
//                                             fontSize:
//                                                 ResponsiveFlutter.of(context)
//                                                     .fontSize(2.2),
//                                             color: Colors.white),
//                                       ),
//                                     ],
//                                   )),
//                               FractionalTranslation(
//                                   translation: Offset(0.0, -0.3),
//                                   child: Container(
//                                     padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Expanded(
//                                           flex: 1,
//                                           child: Card(
//                                             child: InkWell(
//                                               onTap: () {
//                                                 Get.back();
//                                                 courseDialog();
//                                               },
//                                               child: Container(
//                                                 padding: EdgeInsets.fromLTRB(
//                                                     0, 5, 0, 5),
//                                                 child: Column(
//                                                   mainAxisSize:
//                                                       MainAxisSize.min,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Icon(Icons
//                                                         .arrow_drop_down_circle_outlined),
//                                                     SizedBox(
//                                                       height: 5,
//                                                     ),
//                                                     Text(
//                                                       "Course",
//                                                       style: TextStyle(
//                                                           fontSize:
//                                                               ResponsiveFlutter
//                                                                       .of(
//                                                                           context)
//                                                                   .fontSize(
//                                                                       1.7)),
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 1,
//                                           child: Card(
//                                             child: InkWell(
//                                               onTap: () {
//                                                 Get.offAndToNamed('/profile');
//                                               },
//                                               child: Container(
//                                                 padding: EdgeInsets.fromLTRB(
//                                                     0, 5, 0, 5),
//                                                 child: Column(
//                                                   mainAxisSize:
//                                                       MainAxisSize.min,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Icon(Icons
//                                                         .arrow_drop_down_circle_outlined),
//                                                     SizedBox(
//                                                       height: 5,
//                                                     ),
//                                                     Text(
//                                                       "Profile",
//                                                       style: TextStyle(
//                                                           fontSize:
//                                                               ResponsiveFlutter
//                                                                       .of(
//                                                                           context)
//                                                                   .fontSize(
//                                                                       1.7)),
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 1,
//                                           child: Card(
//                                             child: InkWell(
//                                               onTap: () {
//                                                 Get.offAndToNamed(
//                                                     '/performance');
//                                               },
//                                               child: Container(
//                                                 padding: EdgeInsets.fromLTRB(
//                                                     0, 5, 0, 5),
//                                                 child: Column(
//                                                   mainAxisSize:
//                                                       MainAxisSize.min,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Icon(Icons
//                                                         .arrow_drop_down_circle_outlined),
//                                                     SizedBox(
//                                                       height: 5,
//                                                     ),
//                                                     Text(
//                                                       "Performance",
//                                                       style: TextStyle(
//                                                           fontSize:
//                                                               ResponsiveFlutter
//                                                                       .of(
//                                                                           context)
//                                                                   .fontSize(
//                                                                       1.7)),
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   )),
//                               ListTile(
//                                 title: Text(
//                                   "Notice",
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: ResponsiveFlutter.of(context)
//                                           .fontSize(2.2)),
//                                 ),
//                                 leading: Icon(
//                                   Icons.notifications_none_outlined,
//                                   color: Colors.black,
//                                 ),
//                                 trailing: Icon(
//                                   Icons.arrow_forward_ios,
//                                   color: UIColors.primaryColor,
//                                   size: 15,
//                                 ),
//                                 onTap: () {
//                                   Get.offAndToNamed('/noticeList');
//                                 },
//                               ),
//                               // ListTile(
//                               //   title: Text(
//                               //     "Bookmarked",
//                               //     style: TextStyle(
//                               //         color: Colors.black,
//                               //         fontSize: ResponsiveFlutter.of(context)
//                               //             .fontSize(2.2)),
//                               //   ),
//                               //   leading: Icon(
//                               //     Icons.star_border,
//                               //     color: Colors.black,
//                               //   ),
//                               //   trailing: Icon(
//                               //     Icons.arrow_forward_ios,
//                               //     color: UI_Colors.primaryColor,
//                               //     size: 15,
//                               //   ),
//                               //   onTap: () {
//                               //     //Get.offAndToNamed('/home');
//                               //   },
//                               // ),
//                               ListTile(
//                                 title: Text(
//                                   "General Questions",
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: ResponsiveFlutter.of(context)
//                                           .fontSize(2.2)),
//                                 ),
//                                 leading: Icon(
//                                   Icons.question_answer_outlined,
//                                   color: Colors.black,
//                                 ),
//                                 trailing: Icon(
//                                   Icons.arrow_forward_ios,
//                                   color: UIColors.primaryColor,
//                                   size: 15,
//                                 ),
//                                 onTap: () {
//                                   Get.offAndToNamed('/generalQuestions');
//                                 },
//                               ),
//                               ListTile(
//                                 title: Text(
//                                   "My Packages",
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: ResponsiveFlutter.of(context)
//                                           .fontSize(2.2)),
//                                 ),
//                                 leading: Icon(
//                                   Icons.wallet_giftcard_rounded,
//                                   color: Colors.black,
//                                 ),
//                                 trailing: Icon(
//                                   Icons.arrow_forward_ios,
//                                   color: UIColors.primaryColor,
//                                   size: 15,
//                                 ),
//                                 onTap: () {
//                                   Get.offAndToNamed('/packages/my');
//                                 },
//                               ),
//                               ListTile(
//                                 title: Text(
//                                   "Log Out",
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: ResponsiveFlutter.of(context)
//                                           .fontSize(2.2)),
//                                 ),
//                                 leading: Icon(
//                                   Icons.logout,
//                                   color: Colors.black,
//                                 ),
//                                 trailing: Icon(
//                                   Icons.arrow_forward_ios,
//                                   color: UIColors.primaryColor,
//                                   size: 15,
//                                 ),
//                                 onTap: () {
//                                   AuthController().signOut();
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ]),
//                 ),
//               ),
//               Container(
//                 width: Get.width,
//                 padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Design & Developed By',
//                       style: TextStyle(
//                         fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
//                         color: Colors.grey,
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         _launchURL();
//                       },
//                       child: Text(
//                         'QuickTech IT',
//                         style: TextStyle(
//                           fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   courseDialog() {
//     return Get.defaultDialog(
//         title: "Select Course",
//         content: Container(
//           child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: courses.length,
//               itemBuilder: (BuildContext ctxt, int index) {
//                 return RadioListTile(
//                   value: courses[index].id,
//                   groupValue: localData.read('userCourse'),
//                   onChanged: (val) {
//                     Database().updateUserCourse(courses[index].id).then((value) {
//                       CheckLogin().checkData();
//                     });
//                   },
//                   title: Text(courses[index].title),
//                 );
//               }),
//         ));
//   }
// }
