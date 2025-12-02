import '../../../../core/errors/exceptions.dart';
import '../models/example_model.dart';

abstract class ExampleLocalDataSource {
  Future<ExampleModel> getLastExample();
  Future<void> cacheExample(ExampleModel example);
}

class ExampleLocalDataSourceImpl implements ExampleLocalDataSource {
  // In a real app, this would use SharedPreferences, Hive, or similar
  ExampleModel? _cachedExample;

  @override
  Future<ExampleModel> getLastExample() async {
    if (_cachedExample != null) {
      return _cachedExample!;
    } else {
      throw const CacheException('No cached data found');
    }
  }

  @override
  Future<void> cacheExample(ExampleModel example) async {
    _cachedExample = example;
  }
}


