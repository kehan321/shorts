/*
************************ Product ************************
*/
import 'features/product/product_cubit.dart';
import 'features/product/product_navigator.dart';
import 'features/product/product_initial_params.dart';

/*
************************ Home ************************
*/
import 'features/home/home_cubit.dart';
import 'features/home/home_navigator.dart';
import 'features/home/home_initial_params.dart';

/*
************************ Fetching ************************
*/
/*
************************ FeedScreen ************************
*/
import 'package:get_it/get_it.dart';
import 'package:shorts/data/datasources/auth/user_data_sources.dart';

import '/domain/repositories/network/network_base_api_service.dart';
import '/domain/usecases/local/check_for_existing_user_use_case.dart';
import 'config/navigation/app_navigator.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'core/show/show/show.dart';
/*
 ************************ login ************************
*/
import 'data/datasources/theme/theme_data_source.dart';
import 'data/repositories/local/insecure_local_storage_repository.dart';
import 'data/repositories/network/dio/dio_network_repository.dart';
import 'domain/repositories/local/local_storage_base_api_service.dart';
import 'core/services/payment_service.dart';
import 'domain/usecases/auth/login/login_use_cases.dart';
import 'domain/usecases/theme/get_theme_use_case.dart';
import 'domain/usecases/theme/update_theme_use_case.dart';
import 'features/auth/login/login_cubit.dart';
import 'features/auth/login/login_initial_params.dart';
import 'features/auth/login/login_navigator.dart';
import 'features/feed_screen/feed_screen_cubit.dart';
import 'features/feed_screen/feed_screen_initial_params.dart';
import 'features/feed_screen/feed_screen_navigator.dart';
import 'features/fetching/fetching_cubit.dart';
import 'features/fetching/fetching_initial_params.dart';
import 'features/fetching/fetching_navigator.dart';
// import '/data/datasources/internet_connectivity/internet_connectivity_checker_data_sources.dart';

/*
 ************************ Splash ************************
*/
import 'features/splash/splash_cubit.dart';
import 'features/splash/splash_initial_params.dart';
import 'features/splash/splash_navigator.dart';
import 'features/video_player/video_player_cubit.dart';
import 'features/video_player/video_player_initial_params.dart';
/*
************************ VideoPlayer ************************
*/
import 'features/video_player/video_player_navigator.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerSingleton<AppNavigator>(AppNavigator());

  getIt.registerSingleton<UserDataSources>(UserDataSources());

  getIt.registerSingleton<LocalStorageRepository>(
    InsecureLocalStorageRepository(),
  );
  getIt.registerSingleton<NetworkBaseApiService>(
    DioNetworkRepository(getIt(), getIt()),
  );
  /*
************************ Theme ************************
*/

  getIt.registerSingleton<ThemeDataSources>(ThemeDataSources());
  getIt.registerSingleton<GetThemeUseCase>(GetThemeUseCase(getIt(), getIt()));
  getIt.registerSingleton<UpdateThemeUseCase>(
    UpdateThemeUseCase(getIt(), getIt()),
  );
  //  getIt.registerSingleton<Connectivity>(Connectivity());
  getIt.registerSingleton<Show>(Show());
  getIt.registerSingleton<PaymentService>(PaymentService());

  // getIt.registerSingleton<InternetConnectivityCheckerDataSources>(
  //     InternetConnectivityCheckerDataSources(getIt(), getIt()));

  /*
************************ Splash ************************
*/
  getIt.registerSingleton<SplashNavigator>(SplashNavigator(getIt()));
  getIt.registerFactoryParam<SplashCubit, SplashInitialParams, dynamic>(
    (params, _) => SplashCubit(params, getIt(), getIt(), getIt()),
  );
  /*
************************ login ************************
*/
  getIt.registerSingleton<CheckForExistingUserUseCase>(
    CheckForExistingUserUseCase(getIt(), getIt()),
  );
  getIt.registerSingleton<UserUseCases>(UserUseCases(getIt(), getIt()));
  getIt.registerSingleton<LoginNavigator>(LoginNavigator(getIt()));
  getIt.registerFactoryParam<LoginCubit, LoginInitialParams, dynamic>(
    (params, _) => LoginCubit(params, getIt(), getIt(), getIt(), getIt()),
  );

  /*
************************ VideoPlayer ************************
*/
  getIt.registerSingleton<VideoPlayerNavigator>(VideoPlayerNavigator(getIt()));
  getIt.registerFactoryParam<
    VideoPlayerCubit,
    VideoPlayerInitialParams,
    
    dynamic
  >(
        (params, _) => VideoPlayerCubit(
          params,
          getIt<NetworkBaseApiService>(),
          getIt<VideoPlayerNavigator>(),
          getIt<UserDataSources>(),
          getIt<LocalStorageRepository>(),
        ),
      );
  /*
************************ FeedScreen ************************
*/
  getIt.registerSingleton<FeedScreenNavigator>(FeedScreenNavigator(getIt()));
  getIt.registerFactoryParam<FeedScreenCubit, FeedScreenInitialParams, dynamic>(
    (params, _) => FeedScreenCubit(params, getIt(), getIt()),
  );
  /*
************************ Fetching ************************
*/
  getIt.registerSingleton<FetchingNavigator>(FetchingNavigator(getIt()));
  getIt.registerFactoryParam<FetchingCubit, FetchingInitialParams, dynamic>(
    (params, _) => FetchingCubit(params, getIt(), getIt())..fetching(),
  );
/*
************************ Home ************************
*/
  getIt.registerSingleton<HomeNavigator>(HomeNavigator(getIt()));
  getIt.registerFactoryParam<HomeCubit, HomeInitialParams, dynamic>(
      (params, _) => HomeCubit(params, getIt()
      , getIt()
      
      )
      ..home()
      );

/*
************************ Product ************************
*/
  getIt.registerSingleton<ProductNavigator>(ProductNavigator(getIt()));
  getIt.registerFactoryParam<ProductCubit, ProductInitialParams, dynamic>(
      (params, _) => ProductCubit(params, getIt()
      , getIt()
      
      )
      ..product()
      );

}
