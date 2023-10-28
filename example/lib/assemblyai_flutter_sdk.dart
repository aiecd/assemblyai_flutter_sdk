import 'package:assemblyai_flutter_sdk/assemblyai_flutter_sdk.dart';

void main() async {
  final apiKey = 'YOUR_API_KEY';
  final api = AssemblyAI(apiKey);

// 1. Upload an audio file
  const audioFilePath =
      './path_to_local_audio.mp3'; // Adjust path to your local audio file
  final uploadUrl = await api.uploadAudio(audioFilePath);

  print('Audio uploaded successfully! URL: $uploadUrl');

  // 2. Submit it for transcription
  final transcriptionData = {
    'audio_url': uploadUrl,
    // Add any other configurations if needed
  };
  final transcription = await api.submitTranscription(transcriptionData);

  print('Transcription submitted! ID: ${transcription['id']}');

  // 3. Retrieve the transcription (For simplicity, we'll immediately try to fetch. In a real-world scenario, you'd wait until it's completed)
  final transcriptionResult = await api.getTranscription(transcription['id']);

  print('Transcription text: ${transcriptionResult['text']}');
}
