import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';

/// Generates and plays simple sine-wave tones entirely in memory.
/// No audio asset files are needed.
class SoundService {
  // Pool of players for merge sounds to allow rapid overlapping without overhead.
  static final List<AudioPlayer> _mergePlayers = List.generate(
    4,
    (_) => AudioPlayer(),
  );
  static int _mergePlayerIndex = 0;
  static final AudioPlayer _winPlayer = AudioPlayer();

  /// Short blip played every time two tiles merge.
  /// Rotates through a pool of players for overlapping sounds on fast moves.
  static Future<void> playMerge() async {
    try {
      final player = _mergePlayers[_mergePlayerIndex];
      _mergePlayerIndex = (_mergePlayerIndex + 1) % _mergePlayers.length;

      final bytes = _generateWav(
        segments: [
          const _Segment(frequency: 523.25, durationMs: 80, amplitude: 0.35),
        ],
      );
      player.play(BytesSource(bytes), volume: 0.6);
    } catch (_) {}
  }

  /// Ascending arpeggio played when the player creates the 2048 tile.
  static Future<void> playWin() async {
    try {
      // C5 → E5 → G5 → C6  (major chord arpeggio)
      final bytes = _generateWav(
        segments: [
          const _Segment(frequency: 523.25, durationMs: 150, amplitude: 0.5),
          const _Segment(frequency: 659.25, durationMs: 150, amplitude: 0.5),
          const _Segment(frequency: 783.99, durationMs: 150, amplitude: 0.5),
          const _Segment(frequency: 1046.50, durationMs: 350, amplitude: 0.5),
        ],
      );
      await _winPlayer.play(BytesSource(bytes), volume: 0.9);
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // WAV generation helpers
  // ---------------------------------------------------------------------------

  /// Concatenates multiple tone segments into one WAV blob.
  static Uint8List _generateWav({required List<_Segment> segments}) {
    const int sampleRate = 44100;
    const int numChannels = 1;
    const int bitsPerSample = 16;
    const int bytesPerSample = bitsPerSample ~/ 8;

    // Build raw PCM samples for all segments.
    final List<int> samples = [];
    for (final seg in segments) {
      final int n = (sampleRate * seg.durationMs ~/ 1000);
      for (int i = 0; i < n; i++) {
        final double t = i / sampleRate;
        // Linear fade-out envelope to avoid clicks at the end of each segment.
        final double env = 1.0 - (i / n);
        final double value =
            sin(2 * pi * seg.frequency * t) * seg.amplitude * env;
        samples.add((value * 32767).round().clamp(-32768, 32767));
      }
    }

    final int dataSize = samples.length * numChannels * bytesPerSample;
    final buffer = ByteData(44 + dataSize);
    int o = 0;

    // RIFF header
    _writeString(buffer, o, 'RIFF');
    o += 4;
    buffer.setUint32(o, 36 + dataSize, Endian.little);
    o += 4;
    _writeString(buffer, o, 'WAVE');
    o += 4;

    // fmt chunk
    _writeString(buffer, o, 'fmt ');
    o += 4;
    buffer.setUint32(o, 16, Endian.little);
    o += 4;
    buffer.setUint16(o, 1, Endian.little);
    o += 2; // PCM
    buffer.setUint16(o, numChannels, Endian.little);
    o += 2;
    buffer.setUint32(o, sampleRate, Endian.little);
    o += 4;
    buffer.setUint32(
      o,
      sampleRate * numChannels * bytesPerSample,
      Endian.little,
    );
    o += 4;
    buffer.setUint16(o, numChannels * bytesPerSample, Endian.little);
    o += 2;
    buffer.setUint16(o, bitsPerSample, Endian.little);
    o += 2;

    // data chunk
    _writeString(buffer, o, 'data');
    o += 4;
    buffer.setUint32(o, dataSize, Endian.little);
    o += 4;
    for (final s in samples) {
      buffer.setInt16(o, s, Endian.little);
      o += 2;
    }

    return buffer.buffer.asUint8List();
  }

  static void _writeString(ByteData buf, int offset, String s) {
    for (int i = 0; i < s.length; i++) {
      buf.setUint8(offset + i, s.codeUnitAt(i));
    }
  }
}

class _Segment {
  final double frequency;
  final int durationMs;
  final double amplitude;
  const _Segment({
    required this.frequency,
    required this.durationMs,
    required this.amplitude,
  });
}
