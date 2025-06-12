import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_marinabung/bloc/auth/auth_bloc.dart';
import 'package:flutter_marinabung/bloc/detail_saving/detail_saving_bloc.dart';
import 'package:flutter_marinabung/bloc/transaction/transaction_bloc.dart';
import 'package:flutter_marinabung/cubit/clear_search_cubit.dart';
import 'package:flutter_marinabung/cubit/index_bottom_cubit.dart';
import 'package:flutter_marinabung/bloc/photo/photo_bloc.dart';
import 'package:flutter_marinabung/bloc/saving/saving_bloc.dart';
import 'package:flutter_marinabung/cubit/select_estimation_cubit.dart';
import 'package:flutter_marinabung/pages/splash_page.dart';
import 'package:flutter_marinabung/repository/auth_repository.dart';
import 'package:flutter_marinabung/repository/photo_repository.dart';
import 'package:flutter_marinabung/repository/saving_repository.dart';
import 'package:flutter_marinabung/repository/transaction_repository.dart';
import 'package:flutter_marinabung/supabase/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SupabaseConfig.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthRepository()),
        ),
        BlocProvider(
          create: (context) => SavingBloc(SavingRepository()),
        ),
        BlocProvider(
          create: (context) => DetailSavingBloc(SavingRepository()),
        ),
        BlocProvider(
          create: (context) => PhotoBloc(PhotoRepository()),
        ),
        BlocProvider(
          create: (context) => TransactionBloc(TransactionRepository()),
        ),
        BlocProvider(create: (context) => IndexBottomCubit()),
        BlocProvider(create: (context) => SelectEstimationCubit()),
        BlocProvider(create: (context) => ClearSearchCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "MariNabung",
        home: SplashPage(),
      ),
    );
  }
}
