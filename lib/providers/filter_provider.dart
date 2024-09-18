import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meals_prover.dart';

enum Filter {
  glutonFree,
  lactoseFree,
  vegeterian,
  vegan,
}

class FilterNotifier extends StateNotifier<Map<Filter, bool>> {
  FilterNotifier()
      : super({
          Filter.glutonFree: false,
          Filter.lactoseFree: false,
          Filter.vegeterian: false,
          Filter.vegan: false,
        });

  void setFilters(Map<Filter, bool> chosenFilter) {
    state = chosenFilter;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }
}

final filtersProvider =
    StateNotifierProvider<FilterNotifier, Map<Filter, bool>>(
        (ref) => FilterNotifier());

final filterMealsProvider = Provider((ref) {
  final meals = ref.watch(mealProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where((meal) {
    if (activeFilters[Filter.glutonFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    if (activeFilters[Filter.vegeterian]! && !meal.isVegetarian) {
      return false;
    }
    return true;
  }).toList();
});
