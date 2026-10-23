// Generates lib/core/constants/image/image_constants.dart from assets/images/.
//
// Usage: dart run tool/generate_assets.dart
import 'dart:async';
import 'dart:io';

import 'package:flutter_assets/flutter_assets.dart';

const _codePath = 'lib/core/constants/image';
const _codeName = 'image_constants';

Future<void> main() async {
  // flutter_assets splits paths on '/', but Directory.list() yields '\' on
  // Windows. Run it with a Directory shim that normalises listed paths.
  await IOOverrides.runZoned(
    () => FlutterAssets.generate(
      projectPath: '.',
      imagePath: 'assets/images',
      codePath: _codePath,
      codeName: _codeName,
      className: 'ImageConstants',
    ),
    createDirectory: _SlashDirectory.new,
  );

  final file = File('$_codePath/$_codeName.dart');
  if (!file.existsSync()) return;
  final body = file.readAsStringSync().replaceFirst(
    RegExp(r'^(//.*\n)+\n'),
    '',
  );
  file.writeAsStringSync(
    '// GENERATED CODE - DO NOT MODIFY BY HAND\n'
    '// Run `dart run tool/generate_assets.dart` to regenerate.\n\n'
    '${body.trimRight()}\n',
  );
}

class _SlashDirectory implements Directory {
  _SlashDirectory(String path) : _path = path.replaceAll(r'\', '/');

  final String _path;

  // Real directory, created in the root zone so the override doesn't apply.
  Directory get _delegate => Zone.root.run(() => Directory(_path));

  @override
  String get path => _path;

  @override
  Future<bool> exists() => _delegate.exists();

  @override
  Future<Directory> create({bool recursive = false}) =>
      _delegate.create(recursive: recursive);

  @override
  Stream<FileSystemEntity> list({
    bool recursive = false,
    bool followLinks = true,
  }) => _delegate
      .list(recursive: recursive, followLinks: followLinks)
      .map((e) => e is File ? File(e.path.replaceAll(r'\', '/')) : e);

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnsupportedError('${invocation.memberName} not supported');
}
