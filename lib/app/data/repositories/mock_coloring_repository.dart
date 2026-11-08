import 'dart:math' as math;
import 'dart:ui' show Offset, Path, PathFillType, Radius, Rect, RRect;

import 'coloring_repository.dart';
import '../models/coloring_picture.dart';
import '../models/coloring_region.dart';

/// Fake pictures source built from simple rounded normalized paths.
class MockColoringRepository implements ColoringRepository {
  static const String categoryNature = 'طبيعة';
  static const String categoryAnimals = 'حيوانات';
  static const String categoryShapes = 'أشكال';

  @override
  List<ColoringPicture> getPictures() {
    return <ColoringPicture>[
      _butterfly(),
      _flower(),
      _tree(),
      _sun(),
      _leaf(),
      _fish(),
      _cat(),
      _turtle(),
      _bird(),
      _heartPicture(),
      _starPicture(),
      _mandala(),
      _house(),
    ];
  }

  // ---------------------------------------------------------------------------
  // طبيعة
  // ---------------------------------------------------------------------------

  ColoringPicture _butterfly() {
    return ColoringPicture(
      id: 'butterfly',
      name: 'فراشة',
      title: 'فراشة في حديقتي',
      category: categoryNature,
      instruction: 'اختر لونًا، ثم المس جناح الفراشة.',
      regions: <ColoringRegion>[
        ColoringRegion(
          id: 'wingUpperRight',
          path: _oval(0.72, 0.30, 0.20, 0.17),
        ),
        ColoringRegion(
          id: 'wingUpperLeft',
          path: _oval(0.28, 0.30, 0.20, 0.17),
        ),
        ColoringRegion(
          id: 'wingLowerRight',
          path: _oval(0.68, 0.64, 0.15, 0.13),
        ),
        ColoringRegion(
          id: 'wingLowerLeft',
          path: _oval(0.32, 0.64, 0.15, 0.13),
        ),
        ColoringRegion(id: 'body', path: _oval(0.5, 0.52, 0.045, 0.30)),
        ColoringRegion(id: 'head', path: _circle(0.5, 0.16, 0.06)),
      ],
    );
  }

  ColoringPicture _flower() {
    final List<ColoringRegion> petals = <ColoringRegion>[];
    for (int i = 0; i < 6; i++) {
      final double angle = i * math.pi / 3;
      petals.add(
        ColoringRegion(
          id: 'petal$i',
          path: _circle(
            0.5 + math.cos(angle) * 0.19,
            0.34 + math.sin(angle) * 0.19,
            0.085,
          ),
        ),
      );
    }
    return ColoringPicture(
      id: 'flower',
      name: 'زهرة',
      title: 'زهرة الربيع',
      category: categoryNature,
      instruction: 'اختر لونًا، ثم المس بتلات الزهرة.',
      regions: <ColoringRegion>[
        ...petals,
        ColoringRegion(id: 'center', path: _circle(0.5, 0.34, 0.08)),
        ColoringRegion(id: 'stem', path: _roundedRect(0.47, 0.52, 0.06, 0.36, 0.03)),
        ColoringRegion(id: 'leafRight', path: _oval(0.62, 0.74, 0.10, 0.05)),
        ColoringRegion(id: 'leafLeft', path: _oval(0.38, 0.80, 0.10, 0.05)),
      ],
    );
  }

  ColoringPicture _tree() {
    return ColoringPicture(
      id: 'tree',
      name: 'شجرة',
      title: 'شجرة الحديقة',
      category: categoryNature,
      instruction: 'اختر لونًا، ثم المس أوراق الشجرة.',
      regions: <ColoringRegion>[
        ColoringRegion(id: 'crown', path: _circle(0.5, 0.34, 0.28)),
        ColoringRegion(id: 'trunk', path: _roundedRect(0.44, 0.56, 0.12, 0.32, 0.05)),
        ColoringRegion(id: 'apple', path: _circle(0.62, 0.26, 0.05)),
      ],
    );
  }

  ColoringPicture _sun() {
    final List<ColoringRegion> rays = <ColoringRegion>[];
    for (int i = 0; i < 8; i++) {
      final double angle = i * math.pi / 4;
      rays.add(
        ColoringRegion(
          id: 'ray$i',
          path: _circle(
            0.5 + math.cos(angle) * 0.40,
            0.5 + math.sin(angle) * 0.40,
            0.055,
          ),
        ),
      );
    }
    return ColoringPicture(
      id: 'sun',
      name: 'شمس',
      title: 'الشمس المبتسمة',
      category: categoryNature,
      instruction: 'اختر لونًا، ثم المس أشعة الشمس.',
      regions: <ColoringRegion>[
        ...rays,
        ColoringRegion(id: 'face', path: _circle(0.5, 0.5, 0.24)),
      ],
    );
  }

  ColoringPicture _leaf() {
    final Path leaf = Path()
      ..moveTo(0.20, 0.50)
      ..quadraticBezierTo(0.5, 0.08, 0.82, 0.50)
      ..quadraticBezierTo(0.5, 0.92, 0.20, 0.50)
      ..close;
    return ColoringPicture(
      id: 'leaf',
      name: 'ورقة',
      title: 'ورقة الشتاء',
      category: categoryNature,
      instruction: 'اختر لونًا، ثم المس مساحة الورقة.',
      regions: <ColoringRegion>[
        ColoringRegion(id: 'leaf', path: leaf),
        ColoringRegion(id: 'midrib', path: _oval(0.5, 0.5, 0.26, 0.015)),
        ColoringRegion(id: 'stem', path: _oval(0.12, 0.5, 0.07, 0.035)),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // حيوانات
  // ---------------------------------------------------------------------------

  ColoringPicture _fish() {
    final Path tail = Path()
      ..moveTo(0.66, 0.50)
      ..lineTo(0.88, 0.30)
      ..lineTo(0.88, 0.70)
      ..close;
    return ColoringPicture(
      id: 'fish',
      name: 'سمكة',
      title: 'سمكة البحيرة',
      category: categoryAnimals,
      instruction: 'اختر لونًا، ثم المس جسم السمكة وذيلها.',
      regions: <ColoringRegion>[
        ColoringRegion(id: 'body', path: _oval(0.44, 0.50, 0.26, 0.17)),
        ColoringRegion(id: 'tail', path: tail),
        ColoringRegion(id: 'fin', path: _oval(0.46, 0.30, 0.10, 0.05)),
        ColoringRegion(id: 'eye', path: _circle(0.30, 0.44, 0.035)),
      ],
    );
  }

  ColoringPicture _cat() {
    final Path earLeft = Path()
      ..moveTo(0.28, 0.38)
      ..lineTo(0.22, 0.14)
      ..lineTo(0.44, 0.28)
      ..close;
    final Path earRight = Path()
      ..moveTo(0.72, 0.38)
      ..lineTo(0.78, 0.14)
      ..lineTo(0.56, 0.28)
      ..close;
    return ColoringPicture(
      id: 'cat',
      name: 'قطة',
      title: 'قطة لطيفة',
      category: categoryAnimals,
      instruction: 'اختر لونًا، ثم المس أذني القطة.',
      regions: <ColoringRegion>[
        ColoringRegion(id: 'head', path: _circle(0.5, 0.55, 0.30)),
        ColoringRegion(id: 'earLeft', path: earLeft),
        ColoringRegion(id: 'earRight', path: earRight),
        ColoringRegion(id: 'eyeLeft', path: _circle(0.40, 0.50, 0.04)),
        ColoringRegion(id: 'eyeRight', path: _circle(0.60, 0.50, 0.04)),
        ColoringRegion(id: 'nose', path: _circle(0.5, 0.63, 0.04)),
      ],
    );
  }

  ColoringPicture _turtle() {
    return ColoringPicture(
      id: 'turtle',
      name: 'سلحفاة',
      title: 'سلحفاة سعيدة',
      category: categoryAnimals,
      instruction: 'اختر لونًا، ثم المس درع السلحفاة.',
      regions: <ColoringRegion>[
        ColoringRegion(id: 'shell', path: _oval(0.46, 0.55, 0.30, 0.24)),
        ColoringRegion(id: 'shellPattern', path: _oval(0.46, 0.55, 0.15, 0.11)),
        ColoringRegion(id: 'head', path: _circle(0.84, 0.52, 0.09)),
        ColoringRegion(id: 'legFront', path: _oval(0.30, 0.82, 0.08, 0.05)),
        ColoringRegion(id: 'legBack', path: _oval(0.62, 0.82, 0.08, 0.05)),
        ColoringRegion(id: 'tail', path: _oval(0.12, 0.58, 0.07, 0.04)),
      ],
    );
  }

  ColoringPicture _bird() {
    final Path beak = Path()
      ..moveTo(0.24, 0.48)
      ..lineTo(0.08, 0.55)
      ..lineTo(0.24, 0.61)
      ..close;
    return ColoringPicture(
      id: 'bird',
      name: 'عصفور',
      title: 'عصفور الغروب',
      category: categoryAnimals,
      instruction: 'اختر لونًا، ثم المس جناح العصفور.',
      regions: <ColoringRegion>[
        ColoringRegion(id: 'body', path: _oval(0.46, 0.55, 0.24, 0.18)),
        ColoringRegion(id: 'wing', path: _oval(0.44, 0.50, 0.12, 0.09)),
        ColoringRegion(id: 'beak', path: beak),
        ColoringRegion(id: 'eye', path: _circle(0.32, 0.47, 0.03)),
        ColoringRegion(id: 'tail', path: _oval(0.74, 0.40, 0.09, 0.05)),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // أشكال
  // ---------------------------------------------------------------------------

  ColoringPicture _heartPicture() {
    return ColoringPicture(
      id: 'heart',
      name: 'قلب',
      title: 'قلب كبير',
      category: categoryShapes,
      instruction: 'اختر لونًا، ثم المس القلب.',
      regions: <ColoringRegion>[
        ColoringRegion(id: 'heartBig', path: _heart(0.5, 0.5, 0.40)),
        ColoringRegion(id: 'heartSmallRight', path: _heart(0.86, 0.16, 0.12)),
        ColoringRegion(id: 'heartSmallLeft', path: _heart(0.14, 0.22, 0.12)),
      ],
    );
  }

  ColoringPicture _starPicture() {
    return ColoringPicture(
      id: 'star',
      name: 'نجمة',
      title: 'نجمة ساطعة',
      category: categoryShapes,
      instruction: 'اختر لونًا، ثم المس رؤوس النجمة.',
      regions: <ColoringRegion>[
        ColoringRegion(id: 'starBig', path: _star(0.5, 0.55, 0.34)),
        ColoringRegion(id: 'starTopRight', path: _star(0.84, 0.14, 0.09)),
        ColoringRegion(id: 'starTopLeft', path: _star(0.16, 0.18, 0.09)),
      ],
    );
  }

  ColoringPicture _mandala() {
    final Path outerRing = Path()
      ..fillType = PathFillType.evenOdd
      ..addOval(_rect(0.5, 0.5, 0.44))
      ..addOval(_rect(0.5, 0.5, 0.34));
    final Path innerRing = Path()
      ..fillType = PathFillType.evenOdd
      ..addOval(_rect(0.5, 0.5, 0.32))
      ..addOval(_rect(0.5, 0.5, 0.22));
    final List<ColoringRegion> petals = <ColoringRegion>[];
    for (int i = 0; i < 6; i++) {
      final double angle = i * math.pi / 3;
      petals.add(
        ColoringRegion(
          id: 'mandalaPetal$i',
          path: _circle(
            0.5 + math.cos(angle) * 0.28,
            0.5 + math.sin(angle) * 0.28,
            0.065,
          ),
        ),
      );
    }
    return ColoringPicture(
      id: 'mandala',
      name: 'ماندالا',
      title: 'ماندالا الزهور',
      category: categoryShapes,
      instruction: 'اختر لونًا، ثم المس حلقات الماندالا.',
      regions: <ColoringRegion>[
        ColoringRegion(id: 'ringOuter', path: outerRing),
        ColoringRegion(id: 'ringInner', path: innerRing),
        ...petals,
        ColoringRegion(id: 'mandalaCenter', path: _circle(0.5, 0.5, 0.10)),
      ],
    );
  }

  ColoringPicture _house() {
    final Path roof = Path()
      ..moveTo(0.12, 0.44)
      ..quadraticBezierTo(0.5, 0.02, 0.88, 0.44)
      ..close;
    return ColoringPicture(
      id: 'house',
      name: 'بيت',
      title: 'بيتنا الدافئ',
      category: categoryShapes,
      instruction: 'اختر لونًا، ثم المس سقف البيت والباب.',
      regions: <ColoringRegion>[
        ColoringRegion(id: 'walls', path: _roundedRect(0.24, 0.44, 0.52, 0.42, 0.03)),
        ColoringRegion(id: 'roof', path: roof),
        ColoringRegion(id: 'door', path: _roundedRect(0.44, 0.60, 0.12, 0.26, 0.04)),
        ColoringRegion(id: 'windowLeft', path: _roundedRect(0.29, 0.52, 0.12, 0.12, 0.02)),
        ColoringRegion(id: 'windowRight', path: _roundedRect(0.59, 0.52, 0.12, 0.12, 0.02)),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Path helpers (normalized 0..1 coordinates)
  // ---------------------------------------------------------------------------

  Rect _rect(double cx, double cy, double r) {
    return Rect.fromCircle(center: Offset(cx, cy), radius: r);
  }

  Path _circle(double cx, double cy, double r) {
    return Path()..addOval(_rect(cx, cy, r));
  }

  Path _oval(double cx, double cy, double rx, double ry) {
    return Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(cx, cy),
          width: rx * 2,
          height: ry * 2,
        ),
      );
  }

  Path _roundedRect(double left, double top, double w, double h, double r) {
    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, w, h),
          Radius.circular(r),
        ),
      );
  }

  Path _heart(double cx, double cy, double scale) {
    final Path path = Path()
      ..moveTo(cx, cy + 0.38 * scale)
      ..cubicTo(
        cx - 0.35 * scale, cy + 0.12 * scale,
        cx - 0.38 * scale, cy - 0.16 * scale,
        cx - 0.18 * scale, cy - 0.22 * scale,
      )
      ..cubicTo(
        cx - 0.08 * scale, cy - 0.26 * scale,
        cx, cy - 0.16 * scale,
        cx, cy - 0.12 * scale,
      )
      ..cubicTo(
        cx, cy - 0.16 * scale,
        cx + 0.08 * scale, cy - 0.26 * scale,
        cx + 0.18 * scale, cy - 0.22 * scale,
      )
      ..cubicTo(
        cx + 0.38 * scale, cy - 0.16 * scale,
        cx + 0.35 * scale, cy + 0.12 * scale,
        cx, cy + 0.38 * scale,
      )
      ..close;
    return path;
  }

  Path _star(double cx, double cy, double radius) {
    final Path path = Path();
    final double inner = radius * 0.45;
    for (int i = 0; i < 10; i++) {
      final double angle = -math.pi / 2 + i * math.pi / 5;
      final double r = i.isEven ? radius : inner;
      final double x = cx + math.cos(angle) * r;
      final double y = cy + math.sin(angle) * r;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    return path..close();
  }
}

