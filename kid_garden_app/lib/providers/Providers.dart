import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/Child/ChildViewModel.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';

import '../presentation/ui/Home/HomeViewModel.dart';
import '../presentation/ui/childActions/ChildActionViewModel.dart';

final childViewModelProvider = Provider<ChildViewModel>((ref) => ChildViewModel());
final ChildActionViewModelProvider = Provider.autoDispose<ChildActionViewModel>((ref) => ChildActionViewModel());
final HomeViewModelProvider = Provider<HomeViewModel>((ref) => HomeViewModel());
final childRepositoryProvider = Provider<ChildRepository>((ref) => ChildRepository());
