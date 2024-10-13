import '../../core/constants/constants.dart';

class UiExtra {
  final int index;
  final String value;
  final bool isSelected;

  UiExtra({
    required this.value,
    required this.isSelected,
    required this.index,
  });

  @override
  String toString() {
    return '(Extras name: $value is selected: $isSelected index: $index)';
  }
}

class TypedExtra {
  final int groupIndex;
  final ExtrasType type;
  final String title;
  final List<UiExtra> uiExtras;

  TypedExtra(this.type, this.uiExtras, this.title, this.groupIndex);

  @override
  String toString() {
    return '(Extras type: $type ui extras: $uiExtras title: $title group index: $groupIndex})';
  }
}
