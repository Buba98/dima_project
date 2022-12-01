class Filter {
  Filter({
    required this.parameter,
    required this.field,
    required this.filterType,
  });

  final FilterType filterType;
  final String field;
  final Object parameter;
}

enum FilterType {
  lessThan,
  lessOrEqual,
  equalTo,
  greaterThan,
  greaterOrEqualTo,
  notEqualTo,
  arrayContains,
  arrayContainsAny,
  isIn,
  isNotIn,
}
