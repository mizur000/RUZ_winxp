import 'dart:io';
import 'dart:convert';

void main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);
  print('Proxy running on http://localhost:3000');
  print('Press Ctrl+C to stop\n');

  await for (HttpRequest request in server) {
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    request.response.headers.add('Access-Control-Allow-Headers', '*');
    request.response.headers.add('Content-Type', 'application/json; charset=utf-8');

    if (request.method == 'OPTIONS') {
      request.response.statusCode = 200;
      await request.response.close();
      continue;
    }

    try {
      final path = request.uri.path;
      final query = request.uri.query;
      
      String apiUrl;
      
      if (path == '/search') {
        apiUrl = 'https://ruz.fa.ru/api/search?$query';
        print('[SEARCH] $apiUrl');
      } 
      else if (path.startsWith('/api/schedule/')) {
        apiUrl = 'https://ruz.fa.ru$path';
        if (query.isNotEmpty) apiUrl += '?$query';
        print('[SCHEDULE] $apiUrl');
      }
      else {
        request.response.statusCode = 404;
        request.response.write('{"error": "Route not found"}');
        await request.response.close();
        continue;
      }

      final client = HttpClient();
      final req = await client.getUrl(Uri.parse(apiUrl));
      req.headers.add('User-Agent', 'Mozilla/5.0');
      final res = await req.close();
      
      final body = await res.transform(utf8.decoder).join();
      
      request.response.statusCode = res.statusCode;
      request.response.write(body);
      client.close();
      
      print('  -> Status: ${res.statusCode}');
      
    } catch (e) {
      print('ERROR: $e');
      request.response.statusCode = 500;
      request.response.write('{"error": "$e"}');
    }
    
    await request.response.close();
  }
}