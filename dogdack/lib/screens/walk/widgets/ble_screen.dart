import 'dart:io';

import 'package:dogdack/screens/walk/widgets/data.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/walk_controller.dart';

class Ble extends StatefulWidget {
  const Ble({Key? key}) : super(key: key);

  @override
  State<Ble> createState() => _BleState();
}

class _BleState extends State<Ble> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult> scanResultList = [];
  int scanMode = 2;
  bool _isScanning = false;

  final walkController = Get.put(WalkController());

  @override
  void initState() {
    super.initState();
  }

  void initBle() {
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  void toggleState() {
    _isScanning = !_isScanning;

    if (_isScanning) {
      flutterBlue.startScan(
          scanMode: ScanMode(scanMode), allowDuplicates: true);
      scan();
    } else {
      flutterBlue.stopScan();
    }
    if (mounted) {
      setState(() {});
    }
  }

  void scan() async {
    if (_isScanning) {
      flutterBlue.scanResults.listen((results) {
        scanResultList = results;
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  Widget deviceSignal(ScanResult r) {
    return Text(r.rssi.toString());
  }

  /* 장치의 MAC 주소 위젯  */
  Widget deviceMacAddress(ScanResult r) {
    return Text(r.device.id.id);
  }

  /* 장치의 명 위젯  */
  Widget deviceName(ScanResult r) {
    String name;

    if (r.device.name.isNotEmpty) {
      // device.name에 값이 있다면
      name = r.device.name;
    } else if (r.advertisementData.localName.isNotEmpty) {
      // advertisementData.localName에 값이 있다면
      name = r.advertisementData.localName;
    } else {
      // 둘다 없다면 이름 알 수 없음...
      name = 'N/A';
    }
    return Text(name);
  }

  /* BLE 아이콘 위젯 */
  Widget leading(ScanResult r) {
    return const CircleAvatar(
      backgroundColor: Colors.cyan,
      child: Icon(
        Icons.bluetooth,
        color: Colors.white,
      ),
    );
  }

  /* 장치 아이템을 탭 했을때 호출 되는 함수 */
  void onTap(ScanResult r) async {
    // 단순히 이름만 출력
    print('This device is ${r.device.name}');

    flutterBlue.stopScan();
    try {
      // await r.device.connect();
      // List<BluetoothService> services = await r.device.discoverServices();
      walkController.connectBle(r.device);

      Navigator.pop(context);
    } catch (e) {
      print('Can\'t not connect ${r.device.name}. error: $e');
      throw (e);
    }
    // r.device.di
  }

  /* 장치 아이템 위젯 */
  Widget listItem(ScanResult r) {
    if (r.device.name != 'N/A') {
      return ListTile(
        onTap: () => onTap(r),
        leading: leading(r),
        title: deviceName(r),
        subtitle: deviceMacAddress(r),
        trailing: deviceSignal(r),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLE'),
      ),
      body: Center(
        /* 장치 리스트 출력 */
        child: ListView.separated(
          itemCount: scanResultList.length,
          itemBuilder: (context, index) {
            return listItem(scanResultList[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        ),
      ),
      /* 장치 검색 or 검색 중지  */
      floatingActionButton: FloatingActionButton(
        onPressed: toggleState,
        // 스캔 중이라면 stop 아이콘을, 정지상태라면 search 아이콘으로 표시
        child: Icon(_isScanning ? Icons.stop : Icons.search),
      ),
    );
  }
}
