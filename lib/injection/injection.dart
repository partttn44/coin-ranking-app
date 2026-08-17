import 'package:coin_ranking_app/viewmodels/coin_detail/coin_detail_cubit.dart';
import 'package:coin_ranking_app/viewmodels/coin_list/coin_list_bloc.dart';
import 'package:coin_ranking_data/data/datasource/coin_remote_data_source.dart';

import 'package:coin_ranking_data/data/network/dio_client.dart';
import 'package:coin_ranking_data/data/repositories/coin_repository_impl.dart';
import 'package:coin_ranking_data/domain/repositories/coin_repository.dart';

import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  getIt.registerLazySingleton<CoinRemoteDataSource>(
    () => CoinRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  getIt.registerLazySingleton<CoinRepository>(
    () => CoinRepositoryImpl(remoteDataSource: getIt<CoinRemoteDataSource>()),
  );

  getIt.registerFactory<CoinListBloc>(
    () => CoinListBloc(repository: getIt<CoinRepository>()),
  );

  getIt.registerFactory<CoinDetailCubit>(
    () => CoinDetailCubit(repository: getIt<CoinRepository>()),
  );
}
