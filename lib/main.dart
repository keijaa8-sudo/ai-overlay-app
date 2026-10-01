import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

void main() {
  runApp(const MyApp());
}

// Entry point khusus untuk jendela melayang (Gelembung Anime AI)
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
      await FlutterOverlayWindow.showOverlay(
        height: 320,
        width: 300,
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
      appBar: AppBar(title: const Text('Anime AI Assistant')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.face_retouching_natural, size: 80, color: Colors.pinkAccent),
              const SizedBox(height: 20),
              const Text(
                'Waifu/Karakter Anime AI',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tekan tombol di bawah untuk memunculkan gelembung karakter anime di atas layar!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _toggleOverlay,
                icon: Icon(_isOverlayActive ? Icons.close : Icons.play_arrow),
                label: Text(_isOverlayActive ? 'Matikan AI Anime' : 'Aktifkan AI Anime'),
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

// Tampilan Gelembung Melayang Karakter Anime
class OverlayWidget extends StatefulWidget {
  const OverlayWidget({super.key});

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  String _response = "Konnichiwa! Ada tugas atau soal yang perlu kubantu hari ini, Senpai?";
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
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.pinkAccent, width: 2),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)
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
                              child: Icon(Icons.face_retouching_natural, size: 16, color: Colors.white),
                            ),
                            SizedBox(width: 8),
                            Text('Anime AI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
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
                          _response = "Ganbatte ne! Ketik atau tanyakan soalmu, aku siap bantu jawab! (✨ω✨)";
                        });
                      },
                      child: const Text('Minta Bantuan', style: TextStyle(fontSize: 12)),
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
                      Icons.face_retouching_natural, // Ikon karakter anime/wajah
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
