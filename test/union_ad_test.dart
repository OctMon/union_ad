import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_ad/union_ad.dart';

void main() {
  const MethodChannel channel = MethodChannel('union_ad');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await UnionAd.platformVersion, '42');
  });
}
