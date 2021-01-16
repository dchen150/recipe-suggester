import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:googleapis_auth/auth_io.dart";

void authenticate() async {
  print("before loading env");
  await DotEnv.load(fileName: ".env");
  print("after loading env");
  final accountCredentials = new ServiceAccountCredentials.fromJson({
    "private_key_id": env['PRIVATE_KEY_ID'],
    "private_key": "ask derek",
    "client_email": env['CLIENT_EMAIL'],
    "client_id": env['CLIENT_ID'],
    "type": "service_account"
  });
  List<String> scopes = [];
  print("trynna print private key rn");
  clientViaServiceAccount(accountCredentials, scopes).then((AuthClient client) {
    print("inside THEN");
    print(client);
    client.close();
  }).catchError((Object onError) {
    print('HERE IS SOME ERROR');
    print(onError);
  });
}
