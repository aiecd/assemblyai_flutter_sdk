import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'models/assembly_ai_transcriptions_response.dart';

// import 'models/assembly_ai_transcriptions_response.dart';

class AssemblyAI {
  final String _apiKey;
  http.Client client;
  static const String _baseUrl = 'https://api.assemblyai.com/v2';

  /// Constructor to initialize the AssemblyAI client with an API key.
  AssemblyAI(this._apiKey, {http.Client? client})
      : client = client ?? http.Client();

  /// Upload a local audio file to AssemblyAI.
  ///
  /// Provide the local file path to upload the audio file.
  Future<String> uploadAudio(String filePath) async {
    final file = File(filePath);
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/upload'),
    );
    request.headers.addAll({'authorization': _apiKey});
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      await file.readAsBytes(),
      filename: file.uri.pathSegments.last,
    ));

    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    if (responseBody.statusCode == 200) {
      final jsonData = json.decode(responseBody.body);
      return jsonData['upload_url'];
    } else {
      throw AssemblyAIException('Failed to upload audio file');
    }
  }

  /// Submitting a new transcription job.
  ///
  /// Parameters should include `audio_url` and other optional configurations.

  Future<AssemblyAiResponse> submitTranscription(
      Map<String, dynamic> parameters) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/transcript'),
      headers: {
        'authorization': _apiKey,
        'content-type': 'application/json',
      },
      body: json.encode(parameters),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData != null) {
        return AssemblyAiResponse.fromJson(jsonData);
      } else {
        throw AssemblyAIException('Received null response from the server');
      }
    } else {
      throw AssemblyAIException('Failed to submit transcription');
    }
  }

  /// Retrieving the transcription results by providing the `transcriptId`.
  Future<AssemblyAiResponse> getTranscription(String transcriptId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/transcript/$transcriptId'),
      headers: {
        'authorization': _apiKey,
      },
    );

    if (response.statusCode == 200) {
      return AssemblyAiResponse.fromJson(json.decode(response.body));
    } else {
      throw AssemblyAIException('Failed to retrieve transcription');
    }
  }

  /// Retrieving the sentences from the transcription using `transcriptId`.
  Future<Map<String, dynamic>> getTranscriptionSentences(
      String transcriptId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/transcript/$transcriptId/sentences'),
      headers: {
        'authorization': _apiKey,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw AssemblyAIException(
          'Failed to retrieve sentences from transcription');
    }
  }

  /// Retrieving the paragraphs from the transcription using `transcriptId`.
  Future<Map<String, dynamic>> getTranscriptionParagraphs(
      String transcriptId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/transcript/$transcriptId/paragraphs'),
      headers: {
        'authorization': _apiKey,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw AssemblyAIException(
          'Failed to retrieve paragraphs from transcription');
    }
  }

  /// Export the transcription to subtitles/closed captions.
  ///
  /// Provide `transcriptId` and the desired `subtitleFormat` (srt or vtt).
  Future<Map<String, dynamic>> exportTranscription(
      String transcriptId, String subtitleFormat) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/transcript/$transcriptId/$subtitleFormat'),
      headers: {
        'authorization': _apiKey,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw AssemblyAIException(
          'Failed to export transcription to $subtitleFormat format');
    }
  }

  /// Get the redacted audio after PII redaction.
  ///
  /// Provide the `transcriptId` to retrieve the redacted audio.
  Future<Map<String, dynamic>> getRedactedAudio(String transcriptId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/transcript/$transcriptId/redacted-audio'),
      headers: {
        'authorization': _apiKey,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw AssemblyAIException('Failed to retrieve redacted audio');
    }
  }
}

/// Custom exception for AssemblyAI related errors.
class AssemblyAIException implements Exception {
  final String message;

  AssemblyAIException(this.message);

  @override
  String toString() => 'AssemblyAIException: $message';
}

// Usage example:
// final api = AssemblyAI('YOUR_API_KEY');
// final transcription = await api.submitTranscription({
//   'audio_url': 'AUDIO_URL',
//   'language_code': 'en_us',
//   'punctuate': true,
//   ...
// });
// print(transcription);
