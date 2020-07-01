import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  LocalAuthentication _localAuth = LocalAuthentication();

  List<BiometricType> availableBiometricType;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text("出勤"),
        onPressed: () => _authenticate(context),
      ),
    );
  }

  /// 生体認証可能なタイプを取得
  Future<List<BiometricType>> _getAvailableBiometricTypes() async {
    List<BiometricType> availableBiometricTypes;
    try {
      availableBiometricTypes = await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      // TODO
    }
    return availableBiometricTypes;
  }

  /// 生体認証実行
  Future<bool> _authenticate(BuildContext context) async {
    bool result = false;

    List<BiometricType> availableBiometricTypes = await _getAvailableBiometricTypes();

    try {
      if (availableBiometricTypes.contains(BiometricType.face) || availableBiometricTypes.contains(BiometricType.fingerprint)) {
        result = await _localAuth.authenticateWithBiometrics(localizedReason: "認証してください");
        if (result) {
          print(result);
          _showAlertDialog(context);
        }
      } else {
        _showAlertDialog(context);
      }
    } on PlatformException catch (e) {
      // TODO
    }
    return result;
  }

  /// 生体認証可能かどうか
  Future<bool> canCheckBiometrics() async {
    return await _localAuth.canCheckBiometrics;
  }

  Future _showAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('出勤完了'),
          content: Text('出勤完了しました'),
          actions: <Widget>[
            FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context)
            )
          ],
        );
      },
    );
  }

}
