import 'package:hive/hive.dart';

class DbService<T> {
  final String key;
  final TypeAdapter<T> adapter;

  late final Box<T> box;

  DbService({required this.key, required this.adapter});

  bool _isInitialized = false;

  Future<void> _initDbOnce() async {
    if (_isInitialized) return;

    try {
      if (!Hive.isAdapterRegistered(adapter.typeId)) {
        Hive.registerAdapter<T>(adapter);
      }
      box = await Hive.openBox<T>(key);
      _isInitialized = true;
    } catch (e) {
      print('Error initializing DB: $e');
    }
  }

  Future<T?> getAqiData() async {
    try {
      await _initDbOnce();
      if (box.isOpen && box.isNotEmpty) {
        return box.get(key);
      }
    } catch (e) {
      print('Error reading from database: $e');
    }
    return null;
  }

  Future<void> insertItem({required T object}) async {
    try {
      await _initDbOnce();
      await box.put(key, object);
    } catch (e) {
      print('Error inserting into database: $e');
    }
  }

  Future<bool> isDataAvailable() async {
    try {
      await _initDbOnce();
      return box.isNotEmpty;
    } catch (e) {
      print('Error checking if box is empty: $e');
      return false;
    }
  }
}
