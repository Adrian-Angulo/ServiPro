import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/widgets/filters/request_filter_chip.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_filter_provider.dart';

class ListRequestFilterChip extends ConsumerWidget {
  const ListRequestFilterChip({
    super.key,
    required this.selectedFilter,
    required this.counts,
  });

  final RequestFilterType selectedFilter;
  final Map<RequestFilterType, int> counts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
        ),
        itemCount: RequestFilterType.values.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final filter = RequestFilterType.values[index];
          return RequestFilterChip(
            label: filter.label,
            isSelected: selectedFilter == filter,
            count: counts[filter],
            onTap: () {
              ref.read(requestFilterProvider.notifier).state =
                  filter;
            },
          );
        },
      ),
    );
  }
}