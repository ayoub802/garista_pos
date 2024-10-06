import 'package:get_it/get_it.dart';
import '../../repository/repository.dart';
import '../handlers/handlers.dart';

final GetIt getIt = GetIt.instance;

void setUpDependencies() {
  getIt.registerLazySingleton<HttpService>(() => HttpService());
  getIt.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl());
  getIt.registerSingleton<ProductsRepository>(ProductsRepositoryImpl());
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  getIt.registerSingleton<UsersRepository>(UsersRepositoryImpl());
  getIt.registerSingleton<CurrenciesRepository>(CurrenciesRepositoryImpl());
  getIt.registerSingleton<CategoriesRepository>(CategoriesRepositoryImpl());
  getIt.registerSingleton<BrandsRepository>(BrandsRepositoryImpl());
}

final dioHttp = getIt.get<HttpService>();
final settingsRepository = getIt.get<SettingsRepository>();
final authRepository = getIt.get<AuthRepository>();
final usersRepository = getIt.get<UsersRepository>();
final currenciesRepository = getIt.get<CurrenciesRepository>();
final brandsRepository = getIt.get<BrandsRepository>();
final categoriesRepository = getIt.get<CategoriesRepository>();
final productsRepository = getIt.get<ProductsRepository>();
