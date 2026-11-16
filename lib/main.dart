import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      {
        'tanggal': '2026-11-16T08:30:00',
        'surah': 'Al-Mulk',
        'ayat': '2',
        'jenis': 'Ziyadah',
        'bintang': 4,
        'catatan': 'Bagus, hafalan lancar.',
        'guru_nama': 'Ust. Arif',
      },
      {
        'tanggal': '2026-11-17T09:15:00',
        'surah': 'Al-Baqarah',
        'ayat': '10',
        'jenis': 'Tahfidz',
        'bintang': 5,
        'catatan': null,
        'guru_nama': 'Ust. Riza',
      },
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tahfiz'),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final r = data[index];
            final tanggal = r['tanggal'] as String;
            final bintang = (r['bintang'] as num?)?.toInt() ?? 0;
            final jenis = r['jenis'] as String;
            final isZiyadah = jenis == 'Ziyadah';

            final tgl = DateFormat('dd MMM yyyy, HH:mm')
                .format(DateTime.parse(tanggal).toLocal());

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'QS. ${r['surah']} : ${r['ayat']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isZiyadah
                                ? const Color(0xFFECFDF5)
                                : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            jenis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isZiyadah
                                  ? const Color(0xFF065F46)
                                  : Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        5,
                        (idx) => Icon(
                          idx < bintang
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ),
                    ),
                    if (r['catatan'] != null &&
                        r['catatan'].toString().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Catatan: ${r['catatan']}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const Divider(height: 18),
                    Text(
                      'Penguji: ${r['guru_nama']} • $tgl',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
