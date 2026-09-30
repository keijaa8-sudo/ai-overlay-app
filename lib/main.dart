import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FloatingWidget(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("AI Assistant Overlay")),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              bool status = await FlutterOverlayWindow.isPermissionGranted();
              if (!status) {
                await FlutterOverlayWindow.requestPermission();
              } else {
                await FlutterOverlayWindow.showOverlay(
                  height: 300,
                  width: 300,
                  alignment: OverlayAlignment.centerRight,
                  flag: OverlayFlag.defaultFlag,
                );
              }
            },
            child: const Text("Aktifkan AI Melayang"),
          ),
        ),
      ),
    );
  }
}

class FloatingWidget extends StatefulWidget {
  const FloatingWidget({super.key});

  @override
  State<FloatingWidget> createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget> {
  String _response = "Tekan tombol untuk menjawab soal";
  bool _isLoading = false;

  final String _apiKey = "YOUR_GEMINI_API_KEY";

  Future<void> _getAnswerFromAI(String questionText) async {
    setState(() {
      _isLoading = true;
      _response = "Menganalisis soal...";
    });

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _apiKey,
      );
      
      final prompt = "Jawab soal berikut secara singkat dan akurat:\n$questionText";
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        _response = response.text ?? "Tidak ada jawaban.";
      });
    } catch (e) {
      setState(() {
        _response = "Gagal mengambil jawaban: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 10)
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "🤖 AI Penjawab",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => FlutterOverlayWindow.closeOverlay(),
                )
              ],
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _response,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : () {
                _getAnswerFromAI("Hari Olahraga Nasional diperingati setiap tanggal?");
              },
              child: _isLoading 
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text("Jawab Soal"),
            )
          ],
        ),
      ),
    );
  }
}
