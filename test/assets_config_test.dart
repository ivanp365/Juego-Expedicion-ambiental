import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Clasificaton assets are declared in pubspec', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();

    expect(pubspec, contains('assets/images/clasificaton/'));
    expect(pubspec, contains('assets/images/clasificaton/bins/'));
    expect(pubspec, contains('assets/images/clasificaton/covers/'));
    expect(pubspec, contains('assets/images/clasificaton/cards/level1/'));
    expect(pubspec, contains('assets/images/clasificaton/cards/level2/'));
    expect(pubspec, contains('assets/images/clasificaton/waste/'));
  });

  test('Intro cover path matches an existing asset file', () {
    final routerFile = File('lib/app/router.dart').readAsStringSync();
    final expectedPath =
        'assets/images/clasificaton/covers/portada_nivel_1.jpeg';

    expect(routerFile, contains(expectedPath));
    expect(File(expectedPath).existsSync(), isTrue);
  });
}
