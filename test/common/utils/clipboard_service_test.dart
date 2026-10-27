import 'package:flutter/foundation.dart';
import 'package:flutter_quill/src/common/utils/quill_native_provider.dart';
import 'package:flutter_quill/src/editor_toolbar_controller_shared/clipboard/default_clipboard_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    QuillNativeProvider.instance = null;
  });

  test('OHOS skips unsupported native clipboard requests', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.ohos;
    final bridge = _ClipboardBridge();
    QuillNativeProvider.instance = bridge;
    final service = DefaultClipboardService();

    expect(await service.getHtmlText(), isNull);
    expect(await service.getHtmlFile(), isNull);
    expect(await service.getMarkdownFile(), isNull);
    expect(await service.getImageFile(), isNull);
    expect(await service.getGifFile(), isNull);
    await service.copyImage(Uint8List(0));

    expect(bridge.supportChecks, 0);
  });

  test('other platforms still query native clipboard support', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final bridge = _ClipboardBridge();
    QuillNativeProvider.instance = bridge;

    expect(await DefaultClipboardService().getHtmlText(), isNull);
    expect(bridge.supportChecks, 1);
  });
}

class _ClipboardBridge extends QuillNativeBridge {
  int supportChecks = 0;

  @override
  Future<bool> isSupported(QuillNativeBridgeFeature feature) async {
    supportChecks++;
    return false;
  }
}
