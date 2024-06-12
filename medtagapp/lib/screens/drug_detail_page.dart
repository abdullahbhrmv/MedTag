import 'package:flutter/material.dart';
import 'package:medtagapp/services/api_service.dart';

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
        title: Text(
          drugName,
          style: const TextStyle(
            fontFamily: "Brand-Regular",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF67b8de),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        color: const Color(0xFFE8F8FF),
        padding: const EdgeInsets.all(16.0),
        child: _translatedDrugInfo != null
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.drug['Image URL'] != null)
                      Center(
                        child: Material(
                          elevation: 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              widget.drug['Image URL'],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                              'Kullanım', _translatedDrugInfo!['uses']),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildInfoCard('Yan Etkiler',
                              _translatedDrugInfo!['side_effects']),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildInfoCard('Üretici',
                              widget.drug['Manufacturer'] ?? 'Bilgi Yok'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : _error != null
                ? Center(
                    child: Text(
                      'Hata: $_error',
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
      ),
      backgroundColor: const Color(0xFFE8F8FF),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: "Brand-Regular",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16, fontFamily: "Brand-Regular"),
            ),
          ],
        ),
      ),
    );
  }
}
