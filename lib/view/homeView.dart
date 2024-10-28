// ignore_for_file: prefer_const_constructors
import 'package:echologger_exp/model/BLEService.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final BLEService _bleService = BLEService();
  int? _selectedBits = 16;
  int? _selectedSR = 16000;
  int _selectedVolume = 5; // Valor inicial do volume de 0 a 10

  @override
  void initState() {
    super.initState();
    _connectToBLEDevices();
  }

  // Conecta aos dispositivos BLE quando a tela é inicializada
  void _connectToBLEDevices() async {
    await _bleService.connectToDevices();
  }

  // Função para enviar os dados para o dispositivo
  void _sendData() async {
    if (_selectedBits != null && _selectedSR != null) {
      await _bleService.sendData(_selectedBits!, _selectedSR!, _selectedVolume);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dados enviados: $_selectedBits bits, $_selectedSR Sample Rate, Volume $_selectedVolume')),
      );
    }
  }

  @override
  void dispose() {
    // Desconecta dos dispositivos quando a tela é fechada
    _bleService.disconnectFromDevices();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Echologger'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButton<int>(
                    value: _selectedBits,
                    items: <int>[16, 32].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value Bits'),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedBits = newValue!;
                      });
                    },
                  ),
                ),
                SizedBox(width: 8),
                Text('Bits', style: TextStyle(fontSize: 16)),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<int>(
                    value: _selectedSR,
                    items: <int>[16000, 22050].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value Sample Rate'),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedSR = newValue!;
                      });
                    },
                  ),
                ),
                SizedBox(width: 8),
                Text('Sample Rate', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 16),
            // Controle de Volume com Slider de 0 a 10
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _selectedVolume.toDouble(),
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: _selectedVolume.toString(),
                    onChanged: (value) {
                      setState(() {
                        _selectedVolume = value.toInt();
                      });
                    },
                  ),
                ),
                SizedBox(width: 8),
                Text('Volume', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 16),
            Text('Dispositivos BLE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ListTile(
              title: Text('EchoLogger - 1'),
              trailing: Icon(Icons.circle, color: Colors.green), // Indicador de conexão
            ),
            Divider(),
            ListTile(
              title: Text('EchoLogger - 2'),
              trailing: Icon(Icons.circle, color: Colors.green), // Indicador de conexão
            ),
            Center(
              child: ElevatedButton(
                onPressed: _sendData,
                child: Text('Enviar'),
              ),
            ),
            Spacer(),
            Center(
              child: Text('Conectado - Echologger 1 e 2', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
