import 'package:flutter/foundation.dart';

/// State for AI story generation. Prepared for future API integration.
class AiStoryProvider extends ChangeNotifier {
  String _prompt = '';
  String _generatedStory = '';
  bool _isLoading = false;
  String? _error;

  String get prompt => _prompt;
  String get generatedStory => _generatedStory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setPrompt(String value) {
    if (_prompt != value) {
      _prompt = value;
      notifyListeners();
    }
  }

  void clear() {
    _prompt = '';
    _generatedStory = '';
    _error = null;
    notifyListeners();
  }

  /// Call this when integrating with your API.
  /// Replace the Future with your actual API call.
  Future<void> generateStory() async {
    if (_prompt.trim().isEmpty) {
      _error = 'Please enter a prompt';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      // Example: final response = await http.post(apiUrl, body: {'prompt': _prompt});
      await Future<void>.delayed(const Duration(seconds: 2));

      _generatedStory = 'Story generated from prompt: "$_prompt"\n\n'
          'This is placeholder content. Connect your AI API to generate real stories.';
      _error = null;
    } catch (e) {
      _error = e.toString();
      _generatedStory = '';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
