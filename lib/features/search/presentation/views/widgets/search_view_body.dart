import 'package:deals/features/search/presentation/views/widgets/deal.dart';
import 'package:deals/features/search/presentation/views/widgets/deal_card.dart';
import 'package:flutter/material.dart';





class SearchViewBody extends StatelessWidget {
  final List<Deal> deals;

  const SearchViewBody({
    super.key,
    required this.deals,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: deals.length,
      itemBuilder: (context, index) {
        return DealCard(
          deal: deals[index],
          onTap: () {
            // Implement your on-tap action here.
          },
        );
      },
    );
  }
}
