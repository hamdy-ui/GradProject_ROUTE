import '../../domain/entities/splash_entity.dart';
import '../../domain/repo/splash_repo.dart';
import '../data_source/splash_local_data_source.dart';

class SplashRepoImpl implements SplashRepo {
  final SplashLocalDataSource _dataSource;

  const SplashRepoImpl(this._dataSource);

  @override
  Future<SplashEntity> checkInitialStatus() async {
    return await _dataSource.getInitialStatus();
  }
}
