import 'db_service.dart';

class DbProvider<T>{
  final DbService<T> dbService;
  DbProvider({required this.dbService});


  Future<T?> getData() async {
    try {
      return await dbService.getAqiData();
    } catch (e) {
      print('Error retrieving elements: $e');
      return null;
    }
  }

  Future<void> insertData({required T post}) async {
    try {
      await dbService.insertItem(object: post);
    } catch (e) {
      print('Error inserting elements: $e');
    }
  }

  Future<bool> isDataAvailable() async {
    return await dbService.isDataAvailable();
  }
}