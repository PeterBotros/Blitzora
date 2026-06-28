import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../products/presentation/bloc/product_bloc.dart';
import '../../../products/presentation/bloc/product_event.dart';

class HomeSearchBar extends StatelessWidget {
  final Color cardColor;
  final Color mutedForegroundColor;
  final Color foregroundColor;

  const HomeSearchBar({
    super.key,
    required this.cardColor,
    required this.mutedForegroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          // Pre-load products then navigate
          context.read<ProductBloc>().add(const LoadProductsEvent());
          Navigator.pushNamed(context, AppRoutes.products);
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: mutedForegroundColor.withOpacity(0.2)),
          ),
          child: Row(children: [
            const SizedBox(width: 14),
            Icon(Icons.search_rounded, color: mutedForegroundColor, size: 22),
            const SizedBox(width: 10),
            Text('Search medicines, vitamins…',
                style: TextStyle(color: mutedForegroundColor, fontSize: 14)),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: mutedForegroundColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.tune_rounded, color: mutedForegroundColor, size: 16),
            ),
          ]),
        ),
      ),
    );
  }
}
