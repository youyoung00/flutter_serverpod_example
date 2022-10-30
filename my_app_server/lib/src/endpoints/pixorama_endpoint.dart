import 'dart:async';
import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
// import '../generated/protocol.dart';

const _pixelAddedChannel = 'pixel-added';

const _imageWidth = 64;
const _imageHeight = 64;
const _imageSize = _imageWidth * _imageHeight;
var _pixels = Uint8List(_imageSize)..fillRange(0, _imageSize, 2);

class Pixoramaendpoint extends Endpoint {
  @override
  Future<void> streamOpened(
    StreamingSession session,
  ) async {
    // client opens a perstent connection

    final image = ImageData(
      pixels: _pixels.buffer.asByteData(),
      width: _imageWidth,
      height: _imageHeight,
    );

    sendStreamMessage(session, image);

    session.messages.addListener(_pixelAddedChannel, (update) {
      sendStreamMessage(session, update);
    });
  }

  @override
  Future<void> handleStreamMessage(
    StreamingSession session,
    SerializableEntity message,
  ) async {
    // client sands message
    if (message is ImageUpdate) {
      session.log('Received Image Update');
      _pixels[message.pixelIndex] = message.colorIndex;

      sendStreamMessage(session, message);

      session.messages.postMessage(_pixelAddedChannel, message, local: true);
    }
  }
}
