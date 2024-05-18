import 'package:flutter/material.dart';
import 'services/api_service.dart'; // fetchDrugInfo ve translateText fonksiyonlarını buraya dahil ediyoruz

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _drugInfo;
  String? _error;

  void _searchDrug() async {
    setState(() {
      _error = null;
    });

    try {
      final drugInfo = await fetchDrugInfo(_controller.text);
      setState(() {
        _drugInfo = drugInfo;
        _translateDrugInfo(); // Tercüme işlemi
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _drugInfo = null;
      });
    }
  }

  void _translateDrugInfo() async {
    if (_drugInfo != null) {
      try {
        final brandName = await translateText(
            _drugInfo!['openfda']?['brand_name']?[0] ?? 'Bilinmiyor', 'tr');
        final purpose = await translateText(
            _drugInfo!['purpose']?[0] ?? 'Bilgi Yok', 'tr');
        final usage = await translateText(
            _drugInfo!['indications_and_usage']?[0] ?? 'Bilgi Yok', 'tr');
        final warnings = await translateText(
            _drugInfo!['warnings']?[0] ?? 'Bilgi Yok', 'tr');

        setState(() {
          _drugInfo!['openfda']['brand_name'][0] = 'İlaç Adı: $brandName';
          _drugInfo!['purpose'] = ['Amaç: $purpose'];
          _drugInfo!['indications_and_usage'] = ['Kullanım: $usage'];
          _drugInfo!['warnings'] = ['Uyarılar: $warnings'];
        });
      } catch (e) {
        setState(() {
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İlaç Bilgi Uygulaması'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'İlaç adını girin',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchDrug,
              child: const Text('Ara'),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(
                'Hata: $_error',
                style: const TextStyle(color: Colors.red),
              ),
            Expanded(
              child: _drugInfo != null
                  ? SingleChildScrollView(
                      child: DrugInfoDisplay(drugInfo: _drugInfo!),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}

class DrugInfoDisplay extends StatelessWidget {
  final Map<String, dynamic> drugInfo;

  DrugInfoDisplay({required this.drugInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          drugInfo['openfda']?['brand_name']?[0] ?? 'Bilinmiyor',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          drugInfo['purpose']?[0] ?? 'Amaç: Bilgi Yok',
        ),
        Text(
          drugInfo['indications_and_usage']?[0] ?? 'Kullanım: Bilgi Yok',
        ),
        Text(
          drugInfo['warnings']?[0] ?? 'Uyarılar: Bilgi Yok',
        ),
        // Diğer bilgiler burada gösterilebilir
      ],
    );
  }
}
