import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RoundedRectangleBorder _defaultDialogShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)
      )
    );

    return Center(
        child: SizedBox(
          width: 120,
          height: 120,
          child: Material(
            elevation: 0,
            color: Color(0x00FFFFFF),
            type: MaterialType.card,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ),
            shape: _defaultDialogShape,
          ),
        ),
      );
  }
}