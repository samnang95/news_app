import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class TtsService extends GetxService {
  final FlutterTts _flutterTts = FlutterTts();

  final RxBool isPlaying = false.obs;
  final RxBool isPaused = false.obs;
  final RxDouble speechRate = 0.5.obs; // 0.0 to 1.0
  final RxDouble volume = 1.0.obs; // 0.0 to 1.0
  final RxDouble pitch = 1.0.obs; // 0.0 to 2.0

  String? _currentArticleId;
  String? _currentText;

  @override
  void onInit() {
    super.onInit();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    // Set default settings
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(speechRate.value);
    await _flutterTts.setVolume(volume.value);
    await _flutterTts.setPitch(pitch.value);

    // Set up completion handler
    _flutterTts.setCompletionHandler(() {
      _onSpeechCompleted();
    });

    // Set up error handler
    _flutterTts.setErrorHandler((error) {
      _onSpeechError(error);
    });

    // Set up start handler
    _flutterTts.setStartHandler(() {
      isPlaying.value = true;
      isPaused.value = false;
    });

    // Set up pause handler
    _flutterTts.setPauseHandler(() {
      isPaused.value = true;
      isPlaying.value = false;
    });

    // Set up continue handler
    _flutterTts.setContinueHandler(() {
      isPlaying.value = true;
      isPaused.value = false;
    });
  }

  Future<void> speakArticle(
    String articleId,
    String title,
    String description,
  ) async {
    // Stop any current speech
    if (isPlaying.value || isPaused.value) {
      await stop();
    }

    _currentArticleId = articleId;
    _currentText = "$title. $description";

    await _flutterTts.speak(_currentText!);
  }

  Future<void> pause() async {
    if (isPlaying.value) {
      await _flutterTts.pause();
    }
  }

  Future<void> resume() async {
    if (isPaused.value) {
      // In this version, resume by speaking again from current position
      // Note: FlutterTts may not support resuming from exact position
      if (_currentText != null) {
        await _flutterTts.speak(_currentText!);
      }
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _resetState();
  }

  Future<void> setSpeechRate(double rate) async {
    speechRate.value = rate;
    await _flutterTts.setSpeechRate(rate);
  }

  Future<void> setVolume(double vol) async {
    volume.value = vol;
    await _flutterTts.setVolume(vol);
  }

  Future<void> setPitch(double p) async {
    pitch.value = p;
    await _flutterTts.setPitch(p);
  }

  Future<void> setLanguage(String language) async {
    await _flutterTts.setLanguage(language);
  }

  Future<List<String>> getAvailableLanguages() async {
    return await _flutterTts.getLanguages;
  }

  bool isCurrentlyPlaying(String articleId) {
    return isPlaying.value && _currentArticleId == articleId;
  }

  bool isCurrentlyPaused(String articleId) {
    return isPaused.value && _currentArticleId == articleId;
  }

  void _onSpeechCompleted() {
    _resetState();
  }

  void _onSpeechError(dynamic error) {
    _resetState();
    Get.snackbar(
      'Speech Error',
      'Failed to play speech: $error',
      duration: const Duration(seconds: 3),
    );
  }

  void _resetState() {
    isPlaying.value = false;
    isPaused.value = false;
    _currentArticleId = null;
    _currentText = null;
  }

  @override
  void onClose() {
    stop();
    super.onClose();
  }
}
