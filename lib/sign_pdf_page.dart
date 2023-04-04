import 'dart:ui' as ui;
// import 'dart:html' as html;
import 'dart:async';

///Package import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///Signature pad imports.
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

/// Local imports

// import '../shared/mobile_image_converter.dart'
//     if (dart.library.html) '../shared/web_image_converter.dart';

///Renders the signature pad widget.
class GettingStartedSignaturePad extends StatefulWidget {
  /// Creates getting started signature pad.
  const GettingStartedSignaturePad({Key? key}) : super(key: key);

  @override
  _GettingStartedSignaturePadState createState() =>
      _GettingStartedSignaturePadState();
}

class _GettingStartedSignaturePadState
    extends State<GettingStartedSignaturePad> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  List<SignModel> signutures = [SignModel(), SignModel()];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showPopup(SignModel signModel) {
    signModel.isSigned = false;

    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(12.0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Draw your signature',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Medium')),
                  InkWell(
                    //ignore: sdk_version_set_literal
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.clear,
                        color: Color.fromRGBO(0, 0, 0, 0.54), size: 24.0),
                  )
                ],
              ),
              titlePadding: const EdgeInsets.all(16.0),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width < 306
                      ? MediaQuery.of(context).size.width
                      : 306,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width < 306
                            ? MediaQuery.of(context).size.width
                            : 306,
                        height: 172,
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: SfSignaturePad(
                            minimumStrokeWidth: 1.5,
                            maximumStrokeWidth: 4.0,
                            onDrawStart: () {
                              signModel.isSigned = true;
                              return false;
                            },
                            key: _signaturePadKey),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              actionsPadding: const EdgeInsets.all(8.0),
              buttonPadding: EdgeInsets.zero,
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _handleClearButtonPressed(signModel);
                  },
                  child: const Text(
                    'CLEAR',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto-Medium'),
                  ),
                ),
                const SizedBox(width: 8.0),
                TextButton(
                  onPressed: () {
                    _handleSaveButtonPressed(signModel);
                    Navigator.of(context).pop();
                  },
                  child: const Text('SAVE',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Medium')),
                )
              ],
            );
          },
        );
      },
    );
  }

  void _handleClearButtonPressed(SignModel signModel) {
    _signaturePadKey.currentState!.clear();
    signModel.isSigned = false;
  }

  Future<void> _handleSaveButtonPressed(SignModel signModel) async {
    late Uint8List data;

    if (kIsWeb) {
      final RenderSignaturePad renderSignaturePad =
          _signaturePadKey.currentState!.context.findRenderObject()!
              as RenderSignaturePad;
      data =
          await ImageConverter.toImage(renderSignaturePad: renderSignaturePad);
    } else {
      final ui.Image imageData =
          await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
      final ByteData? bytes =
          await imageData.toByteData(format: ui.ImageByteFormat.png);
      if (bytes != null) {
        data = bytes.buffer.asUint8List();
      }
    }

    setState(
      () {
        signModel.sign = data;
      },
    );
  }

  Widget getSignatureListView() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20.0, 20, 20.0, 10),
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ...signutures.map(
              (e) => InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                //ignore: sdk_version_set_literal
                onTap: () {
                  _showPopup(e);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  height: 78,
                  width: 138,
                  child: e.isSigned && e.sign != null
                      ? Image.memory(e.sign!)
                      : const Center(
                          child: Text(
                            'Tap here to sign',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    //ignore: unused_local_variable
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(250, 250, 250, 1),
        child: Center(
          child: SingleChildScrollView(
              child: SizedBox(
            width: double.infinity,
            height: 625,
            child: Column(children: <Widget>[getSignatureListView()]),
          )),
        ),
      ),
    );
  }
}

class ImageConverter {
  /// toImage
  static Future<Uint8List> toImage(
      {required RenderSignaturePad renderSignaturePad}) async {
    return Uint8List.fromList(<int>[0]);
  }
}

class SignModel {
  bool isSigned = false;
  late Uint8List? sign;
}

// ignore: avoid_classes_with_only_static_members
/// Convert to image format.
// class ImageConverterWeb {
//   /// toImage
//   static Future<Uint8List> toImage(
//       {required RenderSignaturePad renderSignaturePad}) async {
//     final html.CanvasElement canvas = html.CanvasElement(
//         width: renderSignaturePad.size.width.toInt(),
//         height: renderSignaturePad.size.height.toInt());
//     final html.CanvasRenderingContext2D context = canvas.context2D;
//     renderSignaturePad.renderToContext2D(context);
//     final html.Blob blob = await canvas.toBlob('image/jpeg', 1.0);
//     final Completer<Uint8List> completer = Completer<Uint8List>();
//     final html.FileReader reader = html.FileReader();
//     reader.readAsArrayBuffer(blob);
//     reader.onLoad
//         .listen((_) => completer.complete(reader.result! as Uint8List));
//     return completer.future;
//   }
// }
