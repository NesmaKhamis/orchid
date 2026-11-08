import 'package:flutter/material.dart' show Icons;

import '../../core/theme/app_colors.dart';
import 'song_repository.dart';
import '../models/song.dart';

/// Fake songs source. audioAsset values are placeholders until real
/// audio files exist; playback is simulated in the controller.
class MockSongRepository implements SongRepository {
  @override
  List<Song> getSongs() {
    return const <Song>[
      Song(
        id: 'grow',
        title: 'أنا أنمو كل يوم',
        durationSeconds: 100,
        description: 'كلمات مشجعة',
        icon: Icons.local_florist_rounded,
        color: AppColors.lavender,
        // TODO: replace with the real asset once exported.
        audioAsset: 'audio/grow.mp3',
        verses: <List<String>>[
          <String>['أنا أنمو كل يوم بخير', 'خطوة خطوة للأمام'],
          <String>['كالبذرة التي نبتت', 'وأنا أكبر يوماً يوماً'],
          <String>['الحديقة تنتظرني', 'وباهتمامي أحياها'],
        ],
      ),
      Song(
        id: 'breeze',
        title: 'نَفَسٌ مثل النسيم',
        durationSeconds: 130,
        description: 'هدوء واسترخاء',
        icon: Icons.air_rounded,
        color: AppColors.softMint,
        // TODO: replace with the real asset once exported.
        audioAsset: 'audio/breeze.mp3',
        verses: <List<String>>[
          <String>['أتنفّس مثل النسيم', 'متصالاً بهدوءٍ'],
          <String>['النجوم تضيء الليل', 'والأزهار تنام'],
          <String>['أمسِ كان تعباً', 'والليلة النوم جميل'],
        ],
      ),
      Song(
        id: 'joy',
        title: 'معاً نصنع فرحاً',
        durationSeconds: 115,
        description: 'تعاون وأمل',
        icon: Icons.wb_sunny_rounded,
        color: AppColors.softYellow,
        // TODO: replace with the real asset once exported.
        audioAsset: 'audio/joy.mp3',
        verses: <List<String>>[
          <String>['معاً نصنع فرحاً', 'يداً بيد وهنا'],
          <String>['نسقي الورد معاً', 'ونزرع الأرض زرعاً'],
          <String>['حديقتنا ستنمو', 'ويفيق الفرح كبيراً'],
        ],
      ),
    ];
  }
}
