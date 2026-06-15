import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;

import '../../providers/campaign_provider.dart';

class NotesStep extends ConsumerStatefulWidget {
  const NotesStep({super.key});

  @override
  ConsumerState<NotesStep> createState() => _NotesStepState();
}

class _NotesStepState extends ConsumerState<NotesStep> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  int _secondsRecorded = 0;
  double _playbackProgress = 0.0;
  Timer? _timer;
  String? _recordingPath;
  Duration _audioDuration = Duration.zero;

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getTemporaryDirectory();

        final path =
            '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: path,
        );

        setState(() {
          _recordingPath = path;
          _isRecording = true;
          _secondsRecorded = 0;
        });

        _timer?.cancel();

        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (mounted) {
            setState(() {
              _secondsRecorded++;
            });
          }
        });
      }
    } catch (e) {
      debugPrint('Recording Error: $e');
    }
  }

  Future<String?> convertM4aToMp3(String inputPath) async {
    try {
      final outputPath = inputPath.replaceAll('.m4a', '.mp3');

      final command =
          '-i "$inputPath" -codec:a libmp3lame -qscale:a 2 "$outputPath"';

      final session = await FFmpegKit.execute(command);

      final returnCode = await session.getReturnCode();

      if (returnCode?.isValueSuccess() ?? false) {
        print('MP3 Created: $outputPath');
        return outputPath;
      } else {
        print('MP3 Conversion Failed');
        return null;
      }
    } catch (e) {
      print('Conversion Error: $e');
      return null;
    }
  }

  Future<void> _stopRecording() async {
    try {
      _timer?.cancel();

      final recordedPath = await _audioRecorder.stop();

      setState(() {
        _isRecording = false;
      });

      if (recordedPath == null) return;

      // Create MP3 output path
      final mp3Path = p.join(
        p.dirname(recordedPath),
        '${p.basenameWithoutExtension(recordedPath)}.mp3',
      );

      debugPrint('Input File: $recordedPath');
      debugPrint('Output File: $mp3Path');

      // Convert M4A/AAC -> MP3
      final session = await FFmpegKit.execute(
        '-i "$recordedPath" -codec:a libmp3lame -q:a 2 "$mp3Path"',
      );

      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        debugPrint('MP3 conversion successful');

        ref
            .read(campaignProvider.notifier)
            .setVoiceNote(mp3Path, _secondsRecorded);
      } else {
        debugPrint('MP3 conversion failed');

        final logs = await session.getAllLogsAsString();
        debugPrint(logs);

        // fallback to original file
        ref
            .read(campaignProvider.notifier)
            .setVoiceNote(recordedPath, _secondsRecorded);
      }
    } catch (e) {
      debugPrint('Stop Recording Error: $e');
    }
  }

  Future<void> _startPlayback() async {
    final voicePath = ref.read(campaignProvider).voiceNotePath;

    if (voicePath == null) return;

    final file = File(voicePath);

    if (!await file.exists()) {
      debugPrint('Audio file not found');
      return;
    }

    try {
      await _audioPlayer.stop();

      setState(() {
        _isPlaying = true;
        _playbackProgress = 0;
      });

      await _audioPlayer.play(DeviceFileSource(voicePath));
    } catch (e) {
      debugPrint('Playback Error: $e');
    }
  }

  Future<void> _stopPlayback() async {
    await _audioPlayer.stop();

    setState(() {
      _isPlaying = false;
      _playbackProgress = 0;
    });
  }

  Future<void> _deleteRecording() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Recording?',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete this voice note? This action cannot be undone.',
          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE5212A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await _stopPlayback();

    final path = ref.read(campaignProvider).voiceNotePath;

    if (path != null) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }

    ref.read(campaignProvider.notifier).deleteVoiceNote();

    if (!mounted) return;

    setState(() {
      _isRecording = false;
      _isPlaying = false;
      _secondsRecorded = 0;
      _playbackProgress = 0.0;
      _recordingPath = null;
    });
  }

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((duration) {
      _audioDuration = duration;
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (_audioDuration.inMilliseconds > 0 && mounted) {
        setState(() {
          _playbackProgress =
              position.inMilliseconds / _audioDuration.inMilliseconds;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _playbackProgress = 1.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    _audioPlayer.dispose();

    _audioRecorder.dispose();

    super.dispose();
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainder = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainder.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(campaignProvider);
    final viewModel = ref.read(campaignProvider.notifier);

    final hasVoiceNote =
        state.voiceNotePath != null && state.voiceNotePath!.isNotEmpty;
    final isRecording = _isRecording;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STEP · SPECIAL INSTRUCTIONS',
            style: GoogleFonts.inter(
              color: const Color(0xFFE5212A),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Anything we should know?',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add notes on brand guidelines, setup constraints, or apartment-specific requests.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          Text(
            'NOTES FOR THE ADINN TEAM',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            maxLines: 6,
            onChanged: viewModel.updateNotes,
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: state.notes,
                selection: TextSelection.collapsed(offset: state.notes.length),
              ),
            ),
            decoration: InputDecoration(
              hintText:
                  'E.g. brand colour palette is matte black & red, no music after 7 PM, vegetarian giveaways only.',
              hintStyle: GoogleFonts.inter(
                color: Colors.grey[400],
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: Colors.black),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'VOICE NOTE INSTRUCTION',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),

          // Voice Note Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                if (!hasVoiceNote && !isRecording)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF0EF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mic,
                          color: Color(0xFFE5212A),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Record voice note',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Explain guidelines via audio',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _startRecording,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Record',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  )
                else if (isRecording)
                  Row(
                    children: [
                      // Pulsing Red Dot Indicator
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: (value * 2 % 2 - 1).abs(),
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE5212A),
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Text(
                        _formatDuration(_secondsRecorded),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Animated audio waves
                      Expanded(
                        child: SizedBox(
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(15, (index) {
                              final randHeight = (index % 3 + 1) * 6.0;
                              return Container(
                                width: 2,
                                height: _isRecording ? randHeight : 4,
                                color: const Color(0xFFE5212A),
                              );
                            }),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(
                          Icons.stop,
                          color: Colors.black,
                          size: 28,
                        ),
                        onPressed: _stopRecording,
                      ),
                    ],
                  )
                else if (hasVoiceNote)
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: const Color(0xFFE5212A),
                          size: 32,
                        ),
                        onPressed: () {
                          if (_isPlaying) {
                            _stopPlayback();
                          } else {
                            _startPlayback();
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Voice note instructions',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  _formatDuration(state.voiceNoteDuration ?? 0),
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: _isPlaying ? _playbackProgress : 0.0,
                              backgroundColor: Colors.grey[200],
                              color: const Color(0xFFE5212A),
                              borderRadius: BorderRadius.circular(4),
                              minHeight: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.grey,
                          size: 24,
                        ),
                        onPressed: _deleteRecording,
                      ),
                    ],
                  ),
              ],
            ),
          ),

          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
