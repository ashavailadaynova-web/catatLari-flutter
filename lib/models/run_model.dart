class RunModel {
  final int? id; // null kalo belum masuk DB, Tahap 3 baru kepake
  final double distance; // dalam KM
  final String duration; // format "HH:MM:SS"
  final String date; // format "dd/MM/yyyy"
  final String? notes; 

  RunModel({
    this.id,
    required this.distance,
    required this.duration,
    required this.date,
    this.notes,
  });

  // Data dummy buat Tahap 1 & 2 - biar Home gak kosong
  static List<RunModel> get dummyData => [
    RunModel(
      id: 1,
      distance: 3.0,
      duration: '2:16:10',
      date: '14/05/2026',
      notes: 'Lari pagi di GBK',
    ),
    RunModel(
      id: 2,
      distance: 5.2,
      duration: '00:35:45',
      date: '12/05/2026',
      notes: 'Tempo run',
    ),
    RunModel(id: 3, distance: 4.3, duration: '00:28:12', date: '10/05/2026'),
  ];

  // Buat Tahap 3 nanti - convert dari Map SQLite ke Object
  factory RunModel.fromMap(Map<String, dynamic> map) {
    return RunModel(
      id: map['id'],
      // Gunakan .toDouble() supaya aman kalau DB ngasih angka int
      distance: (map['distance'] as num).toDouble(),
      duration: map['duration'],
      date: map['date'],
      notes: map['notes'],
    );
  }

  // Buat Tahap 3 nanti - convert dari Object ke Map buat simpen ke SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'distance': distance,
      'duration': duration,
      'date': date,
      'notes': notes,
    };
  }
}
