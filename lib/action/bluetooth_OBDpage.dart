import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class bluetooth_OBDpage extends StatefulWidget {
  final String vehicleName;
  final String vehicleType;
  const bluetooth_OBDpage(
      {super.key, required this.vehicleName, required this.vehicleType});

  @override
  State<bluetooth_OBDpage> createState() => _bluetooth_OBDpageState();
}

class _bluetooth_OBDpageState extends State<bluetooth_OBDpage> {
  List<BluetoothDevice> devicesList = [];
  BluetoothConnection? connection;
  late Stream<String> _obdStream;
  BluetoothDevice? selectedDevice;

  String rpm = "-";
  String speed = "-";
  String coolantTemp = "-";
  String throttle = "-";
  String voltage = "-";
  String intakeTemp = "-";
  String maf = "-";
  String fuelLevel = "-";
  String engineLoad = "-";
  String timingAdvance = "-";
  String fuelPressure = "-";
  String intakeManifoldPress = "-";
  String barometricPressure = "-";
  String runTime = "-";
  String distMILOn = "-";
  String ambientTemp = "-"; // Ambient Air Temperature
  List<String> dtcCodes = []; // DTC codes list
  String rawData = "-";
  String shortFuel = "-";
  String longFuel = "-";
  String fuelStatus = "-";
  String monitorStatus = "-";
  String distanceSinceClear = "-";
  String runTimeSinceClear = "-";
  String fuelRailPressure = "-";
  String railPressure = "-";
  String relativeEngineLoad = "-";
  String actualEngineTorque = "-";
  String fuelRate = "-";

  bool isConnected = false;
  bool isLoading = false;

  //

  addReport() async {
    try {
      setState(() {
        isLoading = true;
      });
      CollectionReference report =
          FirebaseFirestore.instance.collection('report');
      isLoading = false;
      DocumentReference result = await report.add({
        "user_id": FirebaseAuth.instance.currentUser!.uid,
        "vehicle_Name": widget.vehicleName,
        "vehicle_Type": widget.vehicleType,
        'created_at': FieldValue.serverTimestamp(),
        "rpm": rpm,
        "speed": speed,
        "coolantTemp": coolantTemp,
        "throttle": throttle,
        "voltage": voltage,
        "intakeTemp": intakeTemp,
        "maf": maf,
        "fuelLevel": fuelLevel,
        "engineLoad": engineLoad,
        "timingAdvance": timingAdvance,
        "fuelPressure": fuelPressure,
        "intakeManifoldPress": intakeManifoldPress,
        "barometricPressure": barometricPressure,
        "runTime": runTime,
        "distMILOn": distMILOn,
        "ambientTemp": ambientTemp,
        "dtcCodes": dtcCodes, // هذا قائمة، وليس String
        "rawData": rawData,
        "shortFuel": shortFuel,
        "longFuel": longFuel,
        "fuelStatus": fuelStatus,
        "monitorStatus": monitorStatus,
        "distanceSinceClear": distanceSinceClear,
        "runTimeSinceClear": runTimeSinceClear,
        "fuelRailPressure": fuelRailPressure,
        "railPressure": railPressure,
        "relativeEngineLoad": relativeEngineLoad,
        "actualEngineTorque": actualEngineTorque,
        "fuelRate": fuelRate,
      });
      Navigator.of(context).pushReplacementNamed("reportpage");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _discoverDevices();
    FlutterBluetoothSerial.instance.requestEnable();
  }

  Future<void> _discoverDevices() async {
    var devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {
      devicesList = devices;
    });
  }

  void _connect(BluetoothDevice device) async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);
      _obdStream = connection!.input!
          .map((d) => String.fromCharCodes(d))
          .asBroadcastStream();
      setState(() {
        isConnected = true;
        selectedDevice = device;
      });
      print('✅ تم الاتصال بالجهاز');
    } catch (e) {
      print('❌ فشل الاتصال: $e');
    }
  }

  Future<String> _sendCommand(String cmd) async {
    if (connection == null) throw Exception('No connection');
    final completer = Completer<String>();
    String buffer = '';
    late StreamSubscription sub;

    connection!.output.add(Uint8List.fromList(utf8.encode('$cmd\r')));
    sub = _obdStream.listen((chunk) {
      buffer += chunk;
      if (buffer.contains('>') && !completer.isCompleted) {
        completer.complete(buffer);
        sub.cancel();
      }
    }, onError: (e) {
      if (!completer.isCompleted) completer.completeError(e);
    });

    return completer.future;
  }

  void _fetchAll() async {
    if (!isConnected || connection == null) return;
    setState(() => isLoading = true);

    try {
      rawData = '';
      dtcCodes.clear();
      var cmds = [
        '010C', // RPM
        '010D', // Speed
        '0105', // Coolant Temp
        '0111', // Throttle
        '0142', // Voltage
        '010F', // Intake Air Temp
        '0110', // MAF
        '012F', // Fuel Level
        '0104', // Engine Load
        '010E', // Timing Advance
        '010A', // Fuel Pressure
        '010B', // Intake Manifold Pressure
        '0133', // Barometric Pressure
        '011F', // Run Time Since Start
        '0121', // Distance with MIL On
        '0146', // Ambient Air Temperature
        '03', // Get DTC codes
        '0106', // Short Fuel Trim
        '0107', // Long Fuel Trim
        '0103', // Fuel System Status
        '0101', // Monitor Status
        '0123', // Distance since DTC clear
        '0124', // Run time since DTC clear
        '012C', // Fuel Rail Pressure
        '0130', // Rail Pressure (Diesel)
        '0143', // Relative Engine Load
        '0144', // Actual Engine Torque
        '015C', // Fuel Rate
      ];
      for (var cmd in cmds) {
        var resp = await _sendCommand(cmd);
        print("📥 [$cmd] → $resp");
        rawData += resp + '\n';
        _parsePid(resp);
        await Future.delayed(Duration(milliseconds: 200));
      }
    } catch (e) {
      print('⚠️ خطأ عند القراءة: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _parsePid(String resp) {
    var text = resp.replaceAll('\r', '').replaceAll('>', '').trim();
    var parts = text.split(RegExp(r'\s+'));
    if (parts.isEmpty) return;

    // Mode 03: DTC codes
    if (parts[0] == '43') {
      for (int i = 1; i + 1 < parts.length; i += 2) {
        int A = int.parse(parts[i], radix: 16);
        int B = int.parse(parts[i + 1], radix: 16);
        int type = (A & 0xC0) >> 6;
        String ch1 = ['P', 'C', 'B', 'U'][type];
        String ch2 = ((A & 0x30) >> 4).toRadixString(16);
        String ch3 = (A & 0x0F).toRadixString(16);
        String ch4 = ((B & 0xF0) >> 4).toRadixString(16);
        String ch5 = (B & 0x0F).toRadixString(16);
        dtcCodes.add((ch1 + ch2 + ch3 + ch4 + ch5).toUpperCase());
      }
      return;
    }

    if (parts.length < 3 || parts[0] != '41') return;
    var pid = parts[1];

    switch (pid) {
      case '0C': // RPM
        var A = int.parse(parts[2], radix: 16);
        var B = int.parse(parts[3], radix: 16);
        rpm = (((A * 256) + B) / 4).toStringAsFixed(0);
        break;
      case '0D':
        speed = int.parse(parts[2], radix: 16).toString();
        break;
      case '05':
        coolantTemp = (int.parse(parts[2], radix: 16) - 40).toString();
        break;
      case '11':
        throttle =
            ((int.parse(parts[2], radix: 16) * 100) / 255).toStringAsFixed(1);
        break;
      case '42':
        var A2 = int.parse(parts[2], radix: 16);
        var B2 = int.parse(parts[3], radix: 16);
        voltage = (((A2 * 256) + B2) / 1000).toStringAsFixed(2);
        break;
      case '0F':
        intakeTemp = (int.parse(parts[2], radix: 16) - 40).toString();
        break;
      case '10':
        var A3 = int.parse(parts[2], radix: 16);
        var B3 = int.parse(parts[3], radix: 16);
        maf = (((A3 * 256) + B3) / 100).toStringAsFixed(2);
        break;
      case '2F':
        fuelLevel =
            ((int.parse(parts[2], radix: 16) * 100) / 255).toStringAsFixed(1);
        break;
      case '04':
        engineLoad =
            ((int.parse(parts[2], radix: 16) * 100) / 255).toStringAsFixed(1);
        break;
      case '0E':
        timingAdvance = (int.parse(parts[2], radix: 16) - 128).toString();
        break;
      case '0A':
        fuelPressure = (int.parse(parts[2], radix: 16) * 3).toString();
        break;
      case '0B':
        intakeManifoldPress = int.parse(parts[2], radix: 16).toString();
        break;
      case '33':
        barometricPressure = int.parse(parts[2], radix: 16).toString();
        break;
      case '1F':
        var A4 = int.parse(parts[2], radix: 16);
        var B4 = int.parse(parts[3], radix: 16);
        runTime = ((A4 * 256) + B4).toString() + ' s';
        break;
      case '21':
        var C = int.parse(parts[2], radix: 16);
        var D = int.parse(parts[3], radix: 16);
        distMILOn = ((C * 256) + D).toString() + ' km';
        break;
      case '46':
        ambientTemp = (int.parse(parts[2], radix: 16) - 40).toString();
        break;
      case '06':
        shortFuel = ((int.parse(parts[2], radix: 16) * 100) / 128 - 100)
            .toStringAsFixed(1);
        break;
      case '07':
        longFuel = ((int.parse(parts[2], radix: 16) * 100) / 128 - 100)
            .toStringAsFixed(1);
        break;
      case '03':
        fuelStatus = int.parse(parts[2], radix: 16).toString();
        break;
      case '01':
        monitorStatus =
            int.parse(parts[2], radix: 16).toRadixString(2).padLeft(8, '0');
        break;
      case '23':
        distanceSinceClear = ((int.parse(parts[2], radix: 16) * 256) +
                int.parse(parts[3], radix: 16))
            .toString();
        break;
      case '24':
        runTimeSinceClear = ((int.parse(parts[2], radix: 16) * 256) +
                int.parse(parts[3], radix: 16))
            .toString();
        break;
      case '2C':
        fuelRailPressure =
            ((int.parse(parts[2], radix: 16)) * 100 / 255).toStringAsFixed(1);
        break;
      case '30':
        railPressure = ((int.parse(parts[2], radix: 16) * 256) +
                int.parse(parts[3], radix: 16))
            .toString();
        break;
      case '43':
        relativeEngineLoad =
            ((int.parse(parts[2], radix: 16) * 100) / 255).toStringAsFixed(1);
        break;
      case '44':
        actualEngineTorque =
            ((int.parse(parts[2], radix: 16) * 100) / 255).toStringAsFixed(1);
        break;
      case '5C':
        fuelRate = (((int.parse(parts[2], radix: 16) * 256) +
                    int.parse(parts[3], radix: 16)) /
                20)
            .toStringAsFixed(2);
        break;
    }
    setState(() {});
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OBD2 Bluetooth')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButton<BluetoothDevice>(
              hint: Text('اختر جهاز OBD2'),
              value: selectedDevice,
              items: devicesList.map((d) {
                return DropdownMenuItem(
                  child: Text(d.name ?? 'Unknown'),
                  value: d,
                );
              }).toList(),
              onChanged: (d) => d != null ? _connect(d) : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isConnected && !isLoading ? _fetchAll : null,
              child: Text('🔄 تحديث البيانات'),
            ),
            if (isLoading) ...[
              SizedBox(height: 20),
              CircularProgressIndicator(),
            ],
            SizedBox(height: 20),
            _buildRow('🚗 RPM', rpm),
            _buildRow('🏎️ سرعة', '$speed km/h'),
            _buildRow('🌡️ حرارة المحرك', '$coolantTemp °C'),
            _buildRow('🎛️ دواسة البنزين', '$throttle %'),
            _buildRow('🔋 جهد البطارية', '$voltage V'),
            _buildRow('🍃 Intake Temp', '$intakeTemp °C'),
            _buildRow('🌡️ Ambient Temp', '$ambientTemp °C'),
            _buildRow('🌀 MAF', '$maf g/s'),
            _buildRow('⛽ Fuel Level', '$fuelLevel %'),
            _buildRow('📊 Engine Load', '$engineLoad %'),
            _buildRow('⏱ Timing Advance', '$timingAdvance°'),
            _buildRow('⛽ Fuel Pressure', '$fuelPressure kPa'),
            _buildRow('🔧 Intake Manifold Press', '$intakeManifoldPress kPa'),
            _buildRow('🌎 Baro Pressure', '$barometricPressure kPa'),
            _buildRow('⏳ Run Time', runTime),
            _buildRow('📏 Distance MIL On', distMILOn),
            _buildRow("💨 Short Fuel", "$shortFuel %"),
            _buildRow("💨 Long Fuel", "$longFuel %"),
            _buildRow("🧪 حالة الوقود", fuelStatus),
            _buildRow("🧩 حالة النظام", monitorStatus),
            _buildRow("📏 منذ مسح DTC", "$distanceSinceClear km"),
            _buildRow("⏱ منذ التشغيل بعد مسح DTC", "$runTimeSinceClear s"),
            _buildRow("📉 ضغط الوقود (Rail)", "$fuelRailPressure %"),
            _buildRow("📈 ضغط السكك (DI)", "$railPressure kPa"),
            _buildRow("📋 تحميل المحرك النسبي", "$relativeEngineLoad %"),
            _buildRow("🛠 تحميل المحرك الفعلي", "$actualEngineTorque %"),
            _buildRow("⛽ معدل الوقود", "$fuelRate g/km"),
            _buildRow('⚠️ DTC Codes',
                dtcCodes.isEmpty ? 'لا توجد أعطال' : dtcCodes.join(', ')),
            Divider(),
            Text('📥 RAW:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(rawData),
            MaterialButton(
              child: Text("save report"),
              onPressed: () {
                addReport();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) => Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text(value)],
        ),
      );
}
