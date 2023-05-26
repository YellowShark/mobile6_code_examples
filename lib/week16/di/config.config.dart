// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:objectbox/objectbox.dart' as _i6;

import '../../week22/data/interactor/default_recipe_interactor.dart' as _i9;
import '../../week22/data/service/http_recipe_service.dart' as _i5;
import '../../week22/domain/interactor/recipe_interactor.dart' as _i8;
import '../../week22/domain/service/recipe_service.dart' as _i4;
import '../../week22/ui/recipes/recipes_store.dart' as _i10;
import '../repository/notes_repository.dart' as _i3;
import '../ui/main_store.dart' as _i7;
import 'database_module.dart' as _i11; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final databaseModule = _$DatabaseModule();
  gh.lazySingleton<_i3.NotesRepository>(() => _i3.NotesRepository());
  gh.singleton<_i4.RecipeService>(_i5.HttpRecipeService());
  await gh.singletonAsync<_i6.Store>(
    () => databaseModule.store,
    preResolve: true,
  );
  gh.factory<_i7.MainStore>(() => _i7.MainStore(get<_i3.NotesRepository>()));
  gh.factory<_i8.RecipeInteractor>(
      () => _i9.DefaultRecipeInteractor(get<_i4.RecipeService>()));
  gh.factory<_i10.RecipesStore>(
      () => _i10.RecipesStore(get<_i8.RecipeInteractor>()));
  return get;
}

class _$DatabaseModule extends _i11.DatabaseModule {}
