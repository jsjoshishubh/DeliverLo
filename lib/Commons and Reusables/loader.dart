import 'dart:ui';
import 'package:flutter/material.dart';

class Loader {
  OverlayState? overlayState;
  OverlayEntry? overlayEntry;
  BuildContext? context;

  static final Loader _singleton = Loader._private();

  static Loader getInstance() {
    return _singleton;
  }

  Loader._private();

  showOverlay(BuildContext context) async {
    if (overlayState == null) {
      this.context = context;
      overlayState = Overlay.of(context);
      overlayEntry = OverlayEntry(
        builder:
            (context) => GestureDetector(
              onTap: () {},
              child: Container(
                height: 150,
                width: 150,
                color: Colors.transparent,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade500.withOpacity(0.3),
                          //                        color: MyColors.ThemeColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
      );

      // WidgetsBinding.instance.addPostFrameCallback((_) => overlayState?.insert(overlayEntry));
      overlayState?.insert(overlayEntry!);
    }
  }

  dismissOverlay() {
    if (overlayState != null) {
      overlayEntry?.remove();
      overlayEntry = null;
      overlayState = null;
    }
  }
}
