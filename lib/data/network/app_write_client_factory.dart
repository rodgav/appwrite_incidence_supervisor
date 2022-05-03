import 'package:appwrite/appwrite.dart';
import 'package:appwrite_incidence_supervisor/app/constants.dart';

class AppWriteClientFactory {
  Future<Client> getClient() async {
    Client client = Client();
    client
        .setEndpoint(Constant.baseUrl)
        .setProject(Constant.projectId)
        .setSelfSigned(status: false);
    return client;
  }
}
