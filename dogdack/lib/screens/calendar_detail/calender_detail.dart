import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:dogdack/controllers/walk_controller.dart';
import 'package:dogdack/screens/calendar_detail/widget/beauty/beauty_icon.dart';
import 'package:dogdack/screens/calendar_detail/widget/diary/diary_widget.dart';
import 'package:dogdack/screens/calendar_detail/widget/cal_detail_title.dart';
import 'package:dogdack/screens/calendar_detail/widget/cal_edit_button.dart';
import 'package:dogdack/screens/calendar_detail/widget/walk/cal_walk_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/input_controller.dart';
import '../../controllers/mypage_controller.dart';
import '../../controllers/user_controller.dart';

class CalenderDetail extends StatefulWidget {
  const CalenderDetail({super.key});

  @override
  State<CalenderDetail> createState() => _CalenderDetailState();
}

class _CalenderDetailState extends State<CalenderDetail> {
  final controller = Get.put(InputController());
  final mypageStateController = Get.put(MyPageStateController());
  final walkController = Get.put(WalkController());
  final userController = Get.put(UserController());

  Future<void> getImage() async {
    var dogDoc = await FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets')
        .doc(controller.dognames[controller.selectedValue].toString())
        .collection('Calendar')
        .doc(DateFormat('yyMMdd').format(controller.date))
        .get();

    imgList = dogDoc['imageUrl'];
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets')
        .doc(controller.dognames[controller.selectedValue].toString())
        .collection('Calendar')
        .doc(DateFormat('yyMMdd').format(controller.date))
        .get()
        .then((value) {
      imgList = value['imageUrl'];
      // print("이닛 함수 실행");
      // print(imgList);
      // print(imgList.length);
      setState(() {
        if (imgList.length != 0) {
          imageUrl = imgList[0] as String;
        }
      });
    });

    super.initState();
  }

// 캘린더에서 받아온 데이터
  String docId = '짬뽕';
  bool bath = false;
  bool beauty = false;
  String diary = "오늘의 일기";
  List<Object?> imgList = [];
  var imageUrl = '';

  ////////////////////////////////////파이어 베이스 연결 끝/////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    // getImage().then((value) {
    //  if(tempImg.toList().length!=0){
    //    imageUrl = tempImg.toList()[0].toString();
    //  }
    // });
    Color grey = const Color.fromARGB(255, 80, 78, 91);
    Color violet = const Color.fromARGB(255, 100, 92, 170);
    late Color hairColor = grey;
    late Color bathColor = grey;

    if (controller.beauty == true) {
      hairColor = violet;
    } else {
      hairColor = grey;
    }
    if (controller.bath == true) {
      bathColor = violet;
    } else {
      bathColor = grey;
    }

    Widget imageWidge =  Image.asset('images/login/login_image.png');

    if(imageUrl.length!=0){
      imageWidge = DiaryWidget(diaryImage: imageUrl, diaryText: controller.diary);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: grey,
        ),
        title: Text(
          mypageStateController.myPageStateType == MyPageStateType.Create
              ? '추가하기'
              : '캘린더 상세페이지',
          style: TextStyle(
            color: grey,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //산책 타이틀 +  편집 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CalDetailTitleWidget(
                    name: controller.selectedValue, title: "산책"),
                CalEditButtonWidget(),
              ],
            ),
            //날짜
            Padding(
              padding: const EdgeInsets.only(left: 18, bottom: 15),
              child: Column(
                children: const [
                  // 등록한 날짜가 나와야 함
                  // CalDetailDateWidget(
                  //     time:
                  //     "${controller.date.year}년 ${controller.date.month}월 ${controller.date.day}일 ${controller.date.hour}시 ${controller.date.second}분에서"),
                  // CalDetailDateWidget(
                  //     time:
                  //     "${controller.date.year}년 ${controller.date.month}월 ${controller.date.day}일 ${controller.date.hour}시 ${controller.date.second}분까지")
                ],
              ),
            ),
            // 산책 카드
            CalWalkCardWidget(
              distance: controller.distance,
              // 나중에 여러개로 바꿔야됨
              imageUrl: imageUrl,
              place: controller.place,
              totalTimeMin: controller.time,
            ),
            CalDetailTitleWidget(
              name: controller.selectedValue,
              title: "뷰티도장",
            ),

            BeautyWidget(
              hair_color: hairColor,
              bath_color: bathColor,
            ),
            CalDetailTitleWidget(
              name: controller.selectedValue,
              title: "오늘의 일기",
            ),
            // 나중에 여러개로 바꿔야됨
            imageWidge

            ,
          ],
        ),
      ),
    );
  }
}
