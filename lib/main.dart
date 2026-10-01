import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

void main() {
  runApp(const MyApp());
}

// Entry point khusus untuk jendela melayang (Karakter Anime Alya)
@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OverlayWidget(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime AI Overlay',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOverlayActive = false;

  @override
  void initState() {
    super.initState();
    _checkOverlayStatus();
  }

  Future<void> _checkOverlayStatus() async {
    final bool isActive = await FlutterOverlayWindow.isActive();
    setState(() {
      _isOverlayActive = isActive;
    });
  }

  Future<void> _toggleOverlay() async {
    final bool? status = await FlutterOverlayWindow.isPermissionGranted();
    if (status == null || !status) {
      await FlutterOverlayWindow.requestPermission();
      return;
    }

    if (_isOverlayActive) {
      await FlutterOverlayWindow.closeOverlay();
      setState(() {
        _isOverlayActive = false;
      });
    } else {
      // Mengatur ukuran jendela overlay agar pas dengan gelembung/kotak interaktif
      await FlutterOverlayWindow.showOverlay(
        height: 350,
        width: 320,
        alignment: OverlayAlignment.center,
        flag: OverlayFlag.defaultFlag,
        visibility: NotificationVisibility.visibilityPublic,
        positionGravity: PositionGravity.auto,
      );
      setState(() {
        _isOverlayActive = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alya Anime AI Assistant')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, size: 80, color: Colors.pinkAccent),
              const SizedBox(height: 20),
              const Text(
                'Alya-san AI Melayang',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tekan tombol di bawah untuk memunculkan gelembung karakter Alya di atas layar!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _toggleOverlay,
                icon: Icon(_isOverlayActive ? Icons.close : Icons.play_arrow),
                label: Text(_isOverlayActive ? 'Matikan AI Alya' : 'Aktifkan AI Alya'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tampilan Gelembung Melayang Karakter Alya
class OverlayWidget extends StatefulWidget {
  const OverlayWidget({super.key});

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  String _response = "Moshi-moshi! Ada tugas atau soal yang mau dibantu sama Alya, Senpai? (umu)";
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: _isOpen
            ? Container(
                width: 280,
                height: 260,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.pinkAccent, width: 2),
                  boxShadow: const [
                    BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 2)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.pinkAccent,
                              child: Icon(Icons.favorite, size: 16, color: Colors.white),
                            ),
                            SizedBox(width: 8),
                            Text('Alya AI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () async {
                            // Menutup total overlay atau kembali ke bentuk gelembung
                            setState(() {
                              _isOpen = false;
                            });
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(_response, style: const TextStyle(fontSize: 14)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 32),
                      ),
                      onPressed: () {
                        setState(() {
                          _response = "Ganbatte! Ketik saja pertanyaanmu, Alya siap bantu jawab ya! (✨ω✨)";
                        });
                      },
                      child: const Text('Tanya Alya', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              )
            : GestureDetector(
                onTap: () {
                  setState(() {
                    _isOpen = true;
                  });
                },
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(color: Colors.black38, blurRadius: 6, spreadRadius: 2)
                    ],
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.favorite, // Ikon karakter Alya/Anime
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
