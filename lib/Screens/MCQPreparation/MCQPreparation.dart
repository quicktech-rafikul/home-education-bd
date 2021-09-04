/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:educationbd/Screens/Utils/BottomBar.dart';
import 'package:educationbd/Screens/Utils/NavigationDrawer.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_MCQPreparation extends StatefulWidget {
  @override
  _QuickTechIT_MCQPreparationState createState() => _QuickTechIT_MCQPreparationState();
}

class _QuickTechIT_MCQPreparationState extends State<QuickTechIT_MCQPreparation> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          padding: EdgeInsets.all(15),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: UIColors.primaryColor2,
            size: 20,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'MCQ Preparation',
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            color: UIColors.primaryColor,
          ),
        ),
        backgroundColor: UIColors.backgroundColor,
        elevation: 0.0,
        // actions: <Widget>[
        //   IconButton(
        //     padding: EdgeInsets.all(15),
        //     icon: Icon(
        //       Icons.menu_rounded,
        //       color: UIColors.primaryColor2,
        //     ),
        //     onPressed: () {
        //       _scaffoldKey.currentState.openEndDrawer();
        //     },
        //   ),
        // ],
      ),
      // endDrawer: NavigationDrawer(),
      bottomNavigationBar: BottomBar(),
      backgroundColor: UIColors.backgroundColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(
          children: [
            Container(
              width: Get.width,
              child: TextButton(
                  onPressed: () {
                    Get.toNamed('/mcqSubject');
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(UIColors.primaryColor2),
                      padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(0, 20, 0, 20))
                  ),
                  child: Text(
                    "Subject Wise",
                    style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                        color: Colors.white),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 13,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Column(
                    children: [
                      Container(
                        width: Get.width,
                        child: TextButton(
                            onPressed: () {
                              Get.toNamed('/mcqTopic');
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(UIColors.primaryColor2),
                                padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(0, 20, 0, 20))
                            ),
                            child: Text(
                              "Category $index",
                              style: TextStyle(
                                  fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                                  color: Colors.white),
                            )),
                      ),
                      SizedBox(height: 10,)
                    ],
                  );
                }),

          ],
        ),
        // StreamBuilder<List<DocumentSnapshot>>(
        //   stream: _streamController.stream,
        //   builder: (BuildContext context,
        //       AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        //     if (snapshot.hasError)
        //       return new Text('Error: ${snapshot.error}');
        //     switch (snapshot.connectionState) {
        //       case ConnectionState.waiting:
        //         return new CircularProgressIndicator();
        //       default:
        //         log("Items: " + snapshot.data.length.toString());
        //         return GridView.count(
        //           physics: BouncingScrollPhysics(),
        //           crossAxisCount: 2,
        //           childAspectRatio: .7,
        //           shrinkWrap: true,
        //           children: snapshot.data
        //               .map<Widget>((DocumentSnapshot document) {
        //             List<dynamic> data = document['units'];
        //
        //             List<ProductUnitModel> units = [];
        //
        //             for (int i = 0; i < data.length; i++) {
        //               units.add(ProductUnitModel(
        //                 unit: data[i]['unit'],
        //                 stock: data[i]['stock'],
        //                 price: data[i]['price'],
        //                 oldPrice: data[i]['oldPrice'],
        //                 discount: data[i]['discount'],
        //               ));
        //             }
        //
        //             ProductModel item = ProductModel(
        //               id: document.get('id'),
        //               name: document.get('name'),
        //               units: units,
        //               category: document.get('category'),
        //               subCategory: document.get('subCategory'),
        //               description: document.get('description'),
        //               rating: document.get('rating'),
        //               ratedPeople: document.get('ratedPeople'),
        //               images: List.from(document.get('images')),
        //               time: document.get('time'),
        //             );
        //
        //             return productItemUI(item);
        //           }).toList(),
        //         );
        //     }
        //   },
        // ),
        // if (_isLoading)
        //   Container(
        //       padding: EdgeInsets.only(bottom: 100),
        //       child: CircularProgressIndicator()),
      ),
    );
  }
}
