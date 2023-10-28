
# AssemblyAI Flutter SDK

A Flutter SDK to interact with the AssemblyAI API for audio transcription.

## Getting Started

### Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  assemblyai_flutter_sdk: ^0.0.1
```

### Usage

Initialize the AssemblyAI client with your API key:

`final api = AssemblyAI('YOUR_API_KEY');`


Submit a transcription:

```
final transcription = await api.submitTranscription({
  'audio_url': 'AUDIO_URL',
  'language_code': 'en_us',
  'punctuate': true,
});
print(transcription);

```

Retrieve a transcription:

```
final transcriptionResult = await api.getTranscription('TRANSCRIPT_ID');
print(transcriptionResult);
```

### Testing

To run tests, navigate to your package directory and use:

## Examples

For a deeper dive into how to use this package, check out the `examples` directory in the package repository.


### Contribution

Contributions are welcome! If you find a bug or want to suggest a new feature, open an issue. If you want to submit a PR, ensure that it passes all tests and adheres to the code style of the project.


# assemblyai_flutter_sdk
