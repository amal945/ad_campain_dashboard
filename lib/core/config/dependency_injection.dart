import 'dart:io';

import 'package:ad_campaign_dashboard/core/api/dio_client.dart';
import 'package:ad_campaign_dashboard/core/api/request_handler.dart';
import 'package:ad_campaign_dashboard/core/services/cache_service.dart';
import 'package:ad_campaign_dashboard/core/services/notification_service.dart';
import 'package:ad_campaign_dashboard/features/alerts/data/alerts_remote_data_source.dart';
import 'package:ad_campaign_dashboard/features/alerts/provider/alerts_provider.dart';
import 'package:ad_campaign_dashboard/features/alerts/repository/alerts_repository.dart';
import 'package:ad_campaign_dashboard/features/campaigns/data/campaign_remote_data_source.dart';
import 'package:ad_campaign_dashboard/features/campaigns/provider/campaign_detail_provider.dart';
import 'package:ad_campaign_dashboard/features/campaigns/provider/campaign_list_provider.dart';
import 'package:ad_campaign_dashboard/features/campaigns/repository/campaign_repository.dart';
import 'package:ad_campaign_dashboard/features/dashboard/data/dashboard_remote_data_source.dart';
import 'package:ad_campaign_dashboard/features/dashboard/provider/dashboard_provider.dart';
import 'package:ad_campaign_dashboard/features/dashboard/repository/dashboard_repository.dart';
import 'package:ad_campaign_dashboard/features/forecast/data/forecast_remote_data_source.dart';
import 'package:ad_campaign_dashboard/features/forecast/repository/forecast_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

abstract final class DependencyInjection {
  static Future<void> init() async {
    getIt.registerLazySingleton<DioClient>(DioClient.new);
    getIt.registerLazySingleton<RequestHandler>(RequestHandler.new);

    final cacheService = CacheService();
    await cacheService.init();
    getIt.registerSingleton<CacheService>(cacheService);

    final notifications = NotificationService(
      Platform.isAndroid ? FlutterLocalNotificationsPlugin() : null,
    );
    await notifications.init();
    getIt.registerSingleton<NotificationService>(notifications);

    getIt.registerLazySingleton<CampaignRemoteDataSource>(
      () => CampaignRemoteDataSource(getIt<DioClient>().instance),
    );
    getIt.registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSource(getIt<DioClient>().instance),
    );
    getIt.registerLazySingleton<ForecastRemoteDataSource>(
      () => ForecastRemoteDataSource(getIt<DioClient>().instance),
    );
    getIt.registerLazySingleton<AlertsRemoteDataSource>(
      () => AlertsRemoteDataSource(getIt<DioClient>().instance),
    );

    getIt.registerLazySingleton<CampaignRepository>(
      () => CampaignRepository(
        getIt<CampaignRemoteDataSource>(),
        getIt<RequestHandler>(),
        getIt<CacheService>(),
      ),
    );
    getIt.registerLazySingleton<DashboardRepository>(
      () => DashboardRepository(getIt<DashboardRemoteDataSource>(), getIt<RequestHandler>()),
    );
    getIt.registerLazySingleton<ForecastRepository>(
      () => ForecastRepository(getIt<ForecastRemoteDataSource>(), getIt<RequestHandler>()),
    );
    getIt.registerLazySingleton<AlertsRepository>(
      () => AlertsRepository(getIt<AlertsRemoteDataSource>(), getIt<RequestHandler>()),
    );

    getIt.registerFactory<CampaignListProvider>(() => CampaignListProvider(getIt<CampaignRepository>()));
    getIt.registerFactory<CampaignDetailProvider>(
      () => CampaignDetailProvider(getIt<CampaignRepository>(), getIt<ForecastRepository>()),
    );
    getIt.registerFactory<DashboardProvider>(() => DashboardProvider(getIt<DashboardRepository>()));
    getIt.registerFactory<AlertsProvider>(
      () => AlertsProvider(getIt<AlertsRepository>(), getIt<NotificationService>()),
    );
  }
}
