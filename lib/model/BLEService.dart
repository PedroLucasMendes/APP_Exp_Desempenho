import 'package:flutter_blue/flutter_blue.dart';

class BLEService {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  BluetoothDevice? device1;
  BluetoothDevice? device2;

  // Inicializa a conexão com os dispositivos
  Future<void> connectToDevices() async {
    _flutterBlue.startScan(timeout: Duration(seconds: 5));

    _flutterBlue.scanResults.listen((results) async {
      for (ScanResult r in results) {
        if (r.device.name == 'EchoLogger - 1') {
          device1 = r.device;
          await device1?.connect();
          print('Conectado ao EchoLogger - 1');
        } else if (r.device.name == 'EchoLogger - 2') {
          device2 = r.device;
          await device2?.connect();
          print('Conectado ao EchoLogger - 2');
        }
      }
    });

    _flutterBlue.stopScan();
  }

  // Envia os dados para os dispositivos conectados
  Future<void> sendData(int bits, int sampleRate, int volume) async {
    String data = "cf:$bits;$sampleRate;$volume";
    List<int> bytes = data.codeUnits;

    if (device1 != null) {
      BluetoothCharacteristic? characteristic1 = await _findWriteCharacteristic(device1!);
      if (characteristic1 != null) {
        await characteristic1.write(bytes);
        print('Dados enviados para EchoLogger - 1');
      }
    }

    if (device2 != null) {
      BluetoothCharacteristic? characteristic2 = await _findWriteCharacteristic(device2!);
      if (characteristic2 != null) {
        await characteristic2.write(bytes);
        print('Dados enviados para EchoLogger - 2');
      }
    }
  }

  // Encontra a característica de escrita do dispositivo
  Future<BluetoothCharacteristic?> _findWriteCharacteristic(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          return characteristic;
        }
      }
    }
    return null;
  }

  // Desconecta de todos os dispositivos
  Future<void> disconnectFromDevices() async {
    if (device1 != null) await device1?.disconnect();
    if (device2 != null) await device2?.disconnect();
    print('Desconectado de todos os dispositivos');
  }
}
