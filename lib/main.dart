final tgl = DateFormat('dd MMM yyyy, HH:mm')
    .format(DateTime.parse(r['tanggal']).toLocal());
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
                color: r['jenis'] == 'Ziyadah'
                    ? const Color(0xFFECFDF5)
                    : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                r['jenis'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: r['jenis'] == 'Ziyadah'
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
              idx < (r['bintang'] ?? 0)
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
