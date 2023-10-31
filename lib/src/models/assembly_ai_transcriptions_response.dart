class AssemblyAiResponse {
  final String id;
  final String languageModel;
  final String acousticModel;
  final String languageCode;
  final String status;
  final String audioUrl;
  final String text;
  final List<Word> words;
  final dynamic utterances; // TODO: Update to correct type
  final double confidence;
  final int audioDuration;
  final bool punctuate;

  AssemblyAiResponse({
    required this.id,
    required this.languageModel,
    required this.acousticModel,
    required this.languageCode,
    required this.status,
    required this.audioUrl,
    required this.text,
    required this.words,
    this.utterances,
    required this.confidence,
    required this.audioDuration,
    required this.punctuate,
  });

  factory AssemblyAiResponse.fromJson(Map<String, dynamic> json) {
    return AssemblyAiResponse(
      id: json['id'],
      languageModel: json['language_model'],
      acousticModel: json['acoustic_model'],
      languageCode: json['language_code'],
      status: json['status'],
      audioUrl: json['audio_url'],
      text: json['text'],
      words: (json['words'] as List)
          .map((e) => Word.fromJson(e as Map<String, dynamic>))
          .toList(),
      utterances: json['utterances'],
      confidence: json['confidence'].toDouble(),
      audioDuration: json['audio_duration'],
      punctuate: json['punctuate'],
    );
  }
}

class Word {
  final String text;
  final int start;
  final int end;
  final double confidence;
  final dynamic speaker; // TODO: Figure out correct type

  Word({
    required this.text,
    required this.start,
    required this.end,
    required this.confidence,
    this.speaker,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      text: json['text'],
      start: json['start'],
      end: json['end'],
      confidence: json['confidence'].toDouble(),
      speaker: json['speaker'],
    );
  }
}
