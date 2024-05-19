import 'package:flutter/material.dart';
import 'package:medtag/services/api_service.dart';

class DrugDetailPage extends StatefulWidget {
  final Map<String, dynamic> drug;

  const DrugDetailPage({super.key, required this.drug});

  @override
  _DrugDetailPageState createState() => _DrugDetailPageState();
}

class _DrugDetailPageState extends State<DrugDetailPage> {
  Map<String, dynamic>? _translatedDrugInfo;
  String? _error;

  @override
  void initState() {
    super.initState();
    _translateDrugInfo();
  }

  void _translateDrugInfo() async {
    try {
      final purpose =
          await translateText(widget.drug['Uses'] ?? 'Bilgi Yok', 'tr');
      final sideEffects =
          await translateText(widget.drug['Side_effects'] ?? 'Bilgi Yok', 'tr');

      setState(() {
        _translatedDrugInfo = {
          'uses': purpose,
          'side_effects': sideEffects,
        };
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final drugName = widget.drug['Medicine Name'] ?? 'Bilinmiyor';

    return Scaffold(
      appBar: AppBar(
        title: Text(drugName),
        backgroundColor: const Color(0xFFAFF2F2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _translatedDrugInfo != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.drug['Image URL'] != null)
                    Image.network(widget.drug['Image URL']),
                  const SizedBox(height: 8),
                  Text(
                    'Kullanım: ${_translatedDrugInfo!['uses'] ?? 'Bilgi Yok'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Yan Etkiler: ${_translatedDrugInfo!['side_effects'] ?? 'Bilgi Yok'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Üretici: ${widget.drug['Manufacturer'] ?? 'Bilgi Yok'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              )
            : _error != null
                ? Text(
                    'Hata: $_error',
                    style: const TextStyle(color: Colors.red),
                  )
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
