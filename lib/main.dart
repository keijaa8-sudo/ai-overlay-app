import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

void main() {
  runApp(const MyApp());
}

// Wajib ada agar sistem Android bisa mengenali jendela melayang di luar aplikasi
@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AlyaOverlayWidget(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alya AI Assistant',
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
  bool _isOverlayRunning = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final bool isActive = await FlutterOverlayWindow.isActive();
    setState(() {
      _isOverlayRunning = isActive;
    });
  }

  Future<void> _toggleOverlay() async {
    // Memastikan izin tampil di atas aplikasi lain sudah diberikan
    final bool? hasPermission = await FlutterOverlayWindow.isPermissionGranted();
    if (hasPermission == null || !hasPermission) {
      await FlutterOverlayWindow.requestPermission();
      return;
    }

    if (_isOverlayRunning) {
      await FlutterOverlayWindow.closeOverlay();
      setState(() {
        _isOverlayRunning = false;
      });
    } else {
      // Membuka jendela melayang dengan ukuran kotak yang pas
      await FlutterOverlayWindow.showOverlay(
        height: 320,
        width: 300,
        alignment: OverlayAlignment.center,
        flag: OverlayFlag.defaultFlag,
        visibility: NotificationVisibility.visibilityPublic,
        positionGravity: PositionGravity.auto,
      );
      setState(() {
        _isOverlayRunning = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alya AI Assistant')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, size: 80, color: Colors.pinkAccent),
              const SizedBox(height: 20),
              const Text(
                'Gelembung Alya-san',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tekan tombol di bawah, lalu keluar ke menu utama (Home) untuk melihat gelembung Alya!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _toggleOverlay,
                icon: Icon(_isOverlayRunning ? Icons.close : Icons.play_arrow),
                label: Text(_isOverlayRunning ? 'Sembunyikan Alya' : 'Tampilkan Gelembung Alya'),
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

// Widget Tampilan Gelembung Karakter Alya di Luar Aplikasi
class AlyaOverlayWidget extends StatefulWidget {
  const AlyaOverlayWidget({super.key});

  @override
  State<AlyaOverlayWidget> createState() => _AlyaOverlayWidgetState();
}

class _AlyaOverlayWidgetState extends State<AlyaOverlayWidget> {
  bool _isExpanded = false;
  String _message = "Moshi-moshi! Ada tugas atau soal yang mau dibantu sama Alya, Senpai? (✨ω✨)";

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: _isExpanded
            ? Container(
                width: 270,
                height: 240,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.pinkAccent, width: 2.5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black45, blurRadius: 10, spreadRadius: 2)
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
                          onPressed: () {
                            setState(() {
                              _isExpanded = false;
                            });
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(_message, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 30),
                      ),
                      onPressed: () {
                        setState(() {
                          _message = "Ganbatte ne! Ketik saja pertanyaannya, Alya siap bantu jawab! (•̀ᴗ•́)و";
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
                    _isExpanded = true;
                  });
                },
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(color: Colors.black45, blurRadius: 8, spreadRadius: 2)
                    ],
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
