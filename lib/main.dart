import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://rrzwqmdiuofhcpjidcph.supabase.co',
    anonKey: 'sb_publishable_kdshPspiLd5iV8bbCX7BoA_ls1i5Y90',
  );
  runApp(const TahfizRootApp());
}

final supabase = Supabase.instance.client;

class TahfizRootApp extends StatelessWidget {
  const TahfizRootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahfiz MTsN 6 Solok',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF059669),
          surface: const Color(0xFFF8FAFC),
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      home: const SplashIntroScreen(),
    );
  }
}

// ==========================================
// 1. ANIMASI PEMBUKA APLIKASI (SPLASH)
// ==========================================
class SplashIntroScreen extends StatefulWidget {
  const SplashIntroScreen({super.key});

  @override
  State<SplashIntroScreen> createState() => _SplashIntroScreenState();
}

class _SplashIntroScreenState extends State<SplashIntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _scaleAnim = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );

    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 550),
          pageBuilder: (_, __, ___) => const AuthScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: Stack(
        children: [
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(0xFF10B981).withOpacity(0.35),
                        ),
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        size: 64,
                        color: Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'E-TAHFIZ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Digital Mutabaah & Hafalan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 36,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                children: [
                  Text(
                    'craft by ZxD-9B',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. HALAMAN LOGIN
// ==========================================
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  Future<void> _handleLogin() async {
    final u = _userCtrl.text.trim();
    final p = _passCtrl.text.trim();
    if (u.isEmpty || p.isEmpty) {
      _toast('Isi username dan password terlebih dahulu');
      return;
    }

    setState(() => _loading = true);
    try {
      final res = await supabase
          .from('users')
          .select()
          .eq('username', u)
          .eq('password', p)
          .maybeSingle();

      if (res == null) {
        _toast('Akun tidak ditemukan atau password salah');
      } else {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeRouter(user: res)),
        );
      }
    } catch (e) {
      _toast('Koneksi ke database gagal: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E293B),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.verified_user_rounded,
                        size: 44,
                        color: Color(0xFF059669),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Masuk Sistem Tahfiz',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Gunakan akun Guru, Santri, atau Pimpinan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 28),
                      TextField(
                        controller: _userCtrl,
                        decoration: InputDecoration(
                          labelText: 'Username / NIS',
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passCtrl,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: 'Kata Sandi',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Masuk Sekarang',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'build by ZxD-9B',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. ROUTER DASHBOARD BERDASARKAN ROLE
// ==========================================
class HomeRouter extends StatelessWidget {
  final Map<String, dynamic> user;
  const HomeRouter({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final role = user['role'];
    if (role == 'guru') return GuruDashboard(guru: user);
    if (role == 'siswa') return SiswaDashboard(siswa: user);
    return KepalaDashboard(kepala: user);
  }
}

// ==========================================
// 4. PANEL GURU (KELOLA SANTRI & SETORAN)
// ==========================================
class GuruDashboard extends StatefulWidget {
  final Map<String, dynamic> guru;
  const GuruDashboard({super.key, required this.guru});

  @override
  State<GuruDashboard> createState() => _GuruDashboardState();
}

class _GuruDashboardState extends State<GuruDashboard> {
  List<dynamic> _siswaList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchSiswa();
  }

  Future<void> _fetchSiswa() async {
    setState(() => _loading = true);
    final data = await supabase
        .from('users')
        .select()
        .eq('role', 'siswa')
        .order('nama', ascending: true);
    setState(() {
      _siswaList = data;
      _loading = false;
    });
  }

  void _showTambahSiswaDialog() {
    final namaCtrl = TextEditingController();
    final nisCtrl = TextEditingController();
    final passCtrl = TextEditingController(text: '123456');
    final kelasCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tambah Akun Santri'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaCtrl,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
              ),
              TextField(
                controller: nisCtrl,
                decoration: const InputDecoration(labelText: 'NIS (Username)'),
              ),
              TextField(
                controller: kelasCtrl,
                decoration: const InputDecoration(labelText: 'Kelas (cth: IX-A)'),
              ),
              TextField(
                controller: passCtrl,
                decoration: const InputDecoration(labelText: 'Password Awal'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (namaCtrl.text.isEmpty || nisCtrl.text.isEmpty) return;
              await supabase.from('users').insert({
                'nama': namaCtrl.text.trim(),
                'username': nisCtrl.text.trim(),
                'password': passCtrl.text.trim(),
                'kelas': kelasCtrl.text.trim(),
                'role': 'siswa',
              });
              if (!mounted) return;
              Navigator.pop(context);
              _fetchSiswa();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showInputSetoranSheet(Map<String, dynamic> siswa) {
    final surahCtrl = TextEditingController();
    final ayatCtrl = TextEditingController();
    final catatanCtrl = TextEditingController();
    String jenis = 'Ziyadah';
    int bintang = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Setoran: ${siswa['nama']}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              Row(
                children: ['Ziyadah', 'Murajaah'].map((j) {
                  final active = jenis == j;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Center(child: Text(j)),
                        selected: active,
                        onSelected: (_) => setModalState(() => jenis = j),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: surahCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Surah (cth: An-Naba)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ayatCtrl,
                decoration: const InputDecoration(
                  labelText: 'Ayat (cth: 1 - 15)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return IconButton(
                    icon: Icon(
                      i < bintang ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: 34,
                    ),
                    onPressed: () => setModalState(() => bintang = i + 1),
                  );
                }),
              ),
              TextField(
                controller: catatanCtrl,
                decoration: const InputDecoration(
                  labelText: 'Catatan Tajwid / Kelancaran (Opsional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  if (surahCtrl.text.isEmpty || ayatCtrl.text.isEmpty) return;
                  await supabase.from('mutabaah').insert({
                    'siswa_id': siswa['id'],
                    'guru_nama': widget.guru['nama'],
                    'surah': surahCtrl.text.trim(),
                    'ayat': ayatCtrl.text.trim(),
                    'jenis': jenis,
                    'bintang': bintang,
                    'catatan': catatanCtrl.text.trim(),
                  });
                  if (!mounted) return;
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Setoran hafalan tersimpan!')),
                  );
                },
                child: const Text('Simpan Penilaian'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel Guru • ${widget.guru['nama']}'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AuthScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showTambahSiswaDialog,
        backgroundColor: const Color(0xFF059669),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Santri Baru'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _siswaList.length,
              itemBuilder: (ctx, i) {
                final s = _siswaList[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF10B981).withOpacity(0.15),
                      child: Text(
                        s['nama'][0].toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF059669),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      s['nama'],
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text('NIS: ${s['username']} • Kelas: ${s['kelas']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          onPressed: () => _showInputSetoranSheet(s),
                          child: const Text('Setor'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () async {
                            await supabase
                                .from('users')
                                .delete()
                                .eq('id', s['id']);
                            _fetchSiswa();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ==========================================
// 5. PANEL SANTRI (BUKU MUTABAAH PRIBADI)
// ==========================================
class SiswaDashboard extends StatefulWidget {
  final Map<String, dynamic> siswa;
  const SiswaDashboard({super.key, required this.siswa});

  @override
  State<SiswaDashboard> createState() => _SiswaDashboardState();
}

class _SiswaDashboardState extends State<SiswaDashboard> {
  List<dynamic> _riwayat = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMutabaah();
  }

  Future<void> _loadMutabaah() async {
    final data = await supabase
        .from('mutabaah')
        .select()
        .eq('siswa_id', widget.siswa['id'])
        .order('tanggal', ascending: false);
    setState(() {
      _riwayat = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buku Mutabaah Saya'),
        backgroundColor: const Color(0xFF059669),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AuthScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF059669),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.siswa['nama'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'NIS: ${widget.siswa['username']} • Kelas ${widget.siswa['kelas']}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _riwayat.isEmpty
                    ? const Center(child: Text('Belum ada catatan setoran.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _riwayat.length,
                        itemBuilder: (ctx, i) {
                          final r = _riwayat[i];
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                              ? Colors.emerald.shade50
                                              : Colors.blue.shade50,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          r['jenis'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: r['jenis'] == 'Ziyadah'
                                                ? Colors.emerald.shade800
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
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 6. PANEL KEPALA (REKAP KESELURUHAN)
// ==========================================
class KepalaDashboard extends StatefulWidget {
  final Map<String, dynamic> kepala;
  const KepalaDashboard({super.key, required this.kepala});

  @override
  State<KepalaDashboard> createState() => _KepalaDashboardState();
}

class _KepalaDashboardState extends State<KepalaDashboard> {
  List<dynamic> _allLogs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    final data = await supabase
        .from('mutabaah')
        .select('*, users(nama, kelas)')
        .order('tanggal', ascending: false);
    setState(() {
      _allLogs = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Kepala Madrasah'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AuthScreen()),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _allLogs.length,
              itemBuilder: (ctx, i) {
                final item = _allLogs[i];
                final siswa = item['users'] ?? {};
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(
                      '${siswa['nama'] ?? 'Santri'} (${siswa['kelas'] ?? '-'})',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${item['jenis']} • QS. ${item['surah']} (${item['ayat']})\nPenguji: ${item['guru_nama']}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber),
                        Text('${item['bintang']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
