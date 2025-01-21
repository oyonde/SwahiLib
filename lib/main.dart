import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'common/utils/app_util.dart';
import 'common/utils/env/flavor_config.dart';
import 'common/utils/env/environments.dart';
import 'core/di/injectable.dart';

const supabaseUrl = String.fromEnvironment("supabaseUrl");
const supabaseAnonKey = String.fromEnvironment("supabaseAnonKey");

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig(
    flavor: Flavor.production,
    name: 'PROD',
    color: Colors.transparent,
    values: const FlavorValues(
      logNetworkInfo: false,
      showFullErrorMessages: false,
    ),
  );
  logger('Starting app from main.dart');
  await configureDependencies(Environments.production);

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://704a7eba4e654566beb30a98e786da51@o1365314.ingest.sentry.io/6660908';
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );
}
