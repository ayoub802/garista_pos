import 'package:garista_pos/src/models/models.dart';
import 'package:flutter/material.dart';

import 'size_item.dart';

class ToppingOptions extends StatelessWidget {
  final int groupIndex;
  final List<ToppingOptionData> toppingOptions;
  final Function(ToppingOptionData) onUpdate;

  const ToppingOptions({
    super.key,
    required this.groupIndex,
    required this.toppingOptions,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: toppingOptions.length,
      itemBuilder: (BuildContext context, int index) {
        final ToppingOptionData option = toppingOptions[index];
        return SizeItem(
          onTap: () {
            if (option.isSelected) {
              return;
            }
            onUpdate(option);
          },
          isActive: option.isSelected,
          title: '${option.name} (${option.price})',
        );
      },
    );
  }
}
