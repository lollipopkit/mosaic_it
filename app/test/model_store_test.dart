import 'package:flutter_test/flutter_test.dart';
import 'package:unseen/src/model_store.dart';

void main() {
  test('pairs the model with its own sidecar', () {
    expect(pickModelFiles(['/a/m.onnx', '/a/other.json', '/a/m.onnx.json']), (
      '/a/m.onnx',
      '/a/m.onnx.json',
    ));
  });

  test('accepts a single json under another name', () {
    expect(pickModelFiles(['/a/m.onnx', '/b/meta.json']), (
      '/a/m.onnx',
      '/b/meta.json',
    ));
  });

  test('rejects missing or ambiguous picks', () {
    expect(
      () => pickModelFiles(['/a/m.onnx.json']),
      throwsA(isA<ModelPickError>()),
    );
    expect(
      () => pickModelFiles(['/a/m.onnx', '/a/n.onnx', '/a/m.onnx.json']),
      throwsA(isA<ModelPickError>()),
    );
    expect(() => pickModelFiles(['/a/m.onnx']), throwsA(isA<ModelPickError>()));
    expect(
      () => pickModelFiles(['/a/m.onnx', '/a/x.json', '/a/y.json']),
      throwsA(isA<ModelPickError>()),
    );
  });
}
