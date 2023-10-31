import 'package:assemblyai_flutter_sdk/assemblyai_flutter_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const apiKey = 'YOUR_API_KEY';
  const testTranscriptId = 'TEST_TRANSCRIPT_ID';
  const testAudioUrl = 'TEST_AUDIO_URL';

  test('Submit transcription successfully', () async {
    final api = AssemblyAI(apiKey);

    api.client = MockClient((request) async {
      return http.Response('{"id": "$testTranscriptId"}', 200);
    });

    final transcription = await api.submitTranscription({
      'audio_url': testAudioUrl,
      'language_code': 'en_us',
      'punctuate': true,
    });

    expect(transcription.id, testTranscriptId);
  });

  test('Get transcription successfully', () async {
    final api = AssemblyAI(apiKey);

    api.client = MockClient((request) async {
      return http.Response(
          '{"id": "$testTranscriptId", "text": "This is a test transcription."}',
          200);
    });

    final transcription = await api.getTranscription(testTranscriptId);
    expect(transcription.text, 'This is a test transcription.');
  });

  // Add more tests for other methods in a similar fashion.
}
