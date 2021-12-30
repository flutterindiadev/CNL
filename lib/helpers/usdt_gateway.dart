import 'package:http/http.dart' as http;

const url = 'https://api.cryptapi.io/trx/info/';

const receiverAdd = 'TDGz9gVETTc29egZ2aiy9qdveA8Lbp8nXV';

Future getCoinsList() async {
  http.get(Uri.parse(url)).then((response) => print(response.body));
}

Future createAddress(callback, address) async {
  final addUrl =
      'https://api.cryptapi.io/trc20/usdt/create/?callback=$callback&address=$address';

  http.get(Uri.parse(addUrl)).then((response) => print(response.body));
}

Future generateQr(addressIn) async {
  final qrUrl = 'https://api.cryptapi.io/trc20/usdt/qrcode/?address=$addressIn';
  http.get(Uri.parse(qrUrl)).then((response) => print(response.body));
}
