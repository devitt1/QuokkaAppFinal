import 'package:quokka_mobile_app/constants.dart';
import 'package:quokka_mobile_app/services/http_client.dart';
import 'package:quokka_mobile_app/utils/debug.dart';

Future<bool> isOnline(String ipAddressOrUniqueId,
    {bool isPublic = false}) async {
  final httpClient = HTTPClient();

  String url = isPublic
      ? PUBLIC_ADDRESS.replaceFirst(DOMAIN_VARIABLE, ipAddressOrUniqueId)
      : LOCAL_ADDRESS.replaceFirst(LOCAL_VARIABLE, ipAddressOrUniqueId);

  final APIRequest apiRequest = APIRequest(type: RequestType.GET, fullUrl: url);
  final response = await httpClient.get(apiRequest);
  printDebug('GET $url: ${response.statusCode} ${response.errorMessage}');
  if (response.statusCode != 200) return false;

  printDebug('response:\n${response.result}');

  return true;
}
