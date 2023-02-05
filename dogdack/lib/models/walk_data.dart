import 'package:cloud_firestore/cloud_firestore.dart';

class WalkData {
  WalkData({
    this.name,
    this.imageUrl,
    this.startTime,
    this.endTime,
    this.totalTime,
    this.isAuto,
    this.place,
    this.distance,
  });

  final String? name; // 반려견 이름
  final String? imageUrl; // 산책 경로 이미지 Url
  final Timestamp? startTime; // 산책 시작 시간
  final Timestamp? endTime; // 산책 종료 시간
  final num? totalTime; // 실제로 산책한 시간. 분 단위 (일시정지 있는 경우 필요)
  final bool? isAuto; // 해당 산책 Document 기록이 자동입력인지 수동입력인지
  final String? place; // 대표 산책 장소
  final num? distance; // 이동 거리

  WalkData.fromJson(Map<String, dynamic> json)
      : this(
          name: json['name']! as String,
          imageUrl: json['imageUrl']! as String,
          startTime: json['startTime']! as Timestamp,
          endTime: json['endTime']! as Timestamp,
          totalTime: json['totalTime'] as num,
          isAuto: json['isAuto'] as bool,
          place: json['place']! as String,
          distance: json['distance']! as num,
        );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'startTime': startTime,
      'endTime': endTime,
      'totalTime': totalTime,
      'isAuto': isAuto,
      'place': place,
      'distance': distance,
    };
  }
}
