import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../home/domain/entities/category_entity.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_state.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';

class ProductsPage extends StatefulWidget {
  final String? initialCategoryId;
  final String? initialCategoryName;
  /// When true, the search bar receives focus immediately (used by Search tab).
  final bool focusSearch;
  const ProductsPage({
    super.key,
    this.initialCategoryId,
    this.initialCategoryName,
    this.focusSearch = false,
  });

  @override
  State<ProductsPage> createState() => ProductsPageState();
}

/// Public state so MainWrapper can call [focusSearch] and [selectCategory] via a GlobalKey.
class ProductsPageState extends State<ProductsPage> {
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();
  String? _activeCategoryId;
  String _searchQuery = '';

  /// Called by MainWrapper when the Search tab is tapped to open the keyboard.
  void focusSearch() => _searchFocus.requestFocus();

  /// Called by MainWrapper when a home-page category is tapped.
  /// Clears any active search, sets the category filter and reloads products.
  void selectCategory(String? categoryId) {
    // Clear search state so the new category shows fresh results
    _searchCtrl.clear();
    setState(() {
      _activeCategoryId = categoryId;
      _searchQuery = '';
    });
    context.read<ProductBloc>().add(LoadProductsEvent(categoryId: categoryId));
  }

  @override
  void initState() {
    super.initState();
    _activeCategoryId = widget.initialCategoryId;
    context.read<ProductBloc>().add(LoadProductsEvent(categoryId: _activeCategoryId));
    if (widget.focusSearch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocus.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onCategoryTap(String? id) {
    setState(() => _activeCategoryId = id);
    context.read<ProductBloc>().add(LoadProductsEvent(categoryId: id, search: _searchQuery.isEmpty ? null : _searchQuery));
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query);
    if (query.isEmpty) {
      context.read<ProductBloc>().add(LoadProductsEvent(categoryId: _activeCategoryId));
    } else {
      context.read<ProductBloc>().add(SearchProductsEvent(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary(dark);
    final bg = AppColors.background(dark);
    final card = AppColors.card(dark);
    final fg = AppColors.fg(dark);
    final muted = AppColors.muted(dark);
    final border = AppColors.border(dark);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('products'.tr(), style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(children: [
        // ── Search bar ──────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: card, borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
            child: TextField(
              controller: _searchCtrl,
              focusNode: _searchFocus,
              onChanged: _onSearch,
              style: TextStyle(color: fg, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'search_medicines'.tr(),
                hintStyle: TextStyle(color: muted, fontSize: 13),
                prefixIcon: Icon(Icons.search_rounded, color: muted, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close, color: muted, size: 18),
                        onPressed: () { _searchCtrl.clear(); _onSearch(''); })
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
              ),
            ),
          ),
        ),

        // ── Category chips ──────────────────────────────────────────────────
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, homeState) {
            final cats = homeState is HomeLoaded ? homeState.categories : <CategoryEntity>[];
            return SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _CategoryChip(
                    label: 'All',
                    active: _activeCategoryId == null,
                    primary: primary, card: card, border: border, muted: muted,
                    onTap: () => _onCategoryTap(null),
                  ),
                  ...cats.map((c) => _CategoryChip(
                    label: c.name,
                    active: _activeCategoryId == c.id,
                    primary: primary, card: card, border: border, muted: muted,
                    onTap: () => _onCategoryTap(c.id),
                  )),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 12),

        // ── Products grid ───────────────────────────────────────────────────
        Expanded(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ProductError) {
                return _ErrorView(message: state.message, onRetry: () {
                  context.read<ProductBloc>().add(LoadProductsEvent(categoryId: _activeCategoryId));
                });
              }
              if (state is ProductLoaded) {
                if (state.products.isEmpty) {
                  return Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.medication_outlined, color: muted, size: 64),
                      const SizedBox(height: 16),
                      Text('No products found', style: TextStyle(color: fg, fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text('Try a different search or category', style: TextStyle(color: muted, fontSize: 13)),
                    ]),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ProductBloc>().add(LoadProductsEvent(categoryId: _activeCategoryId, refresh: true));
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.70,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (_, i) => ProductCard(
                      product: state.products[i],
                      primary: primary, card: card, fg: fg, muted: muted, border: border,
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => ProductDetailPage(product: state.products[i]))),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ]),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool active;
  final Color primary, card, border, muted;
  final VoidCallback onTap;
  const _CategoryChip({required this.label, required this.active,
      required this.primary, required this.card, required this.border,
      required this.muted, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? primary.withOpacity(0.15) : card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? primary.withOpacity(0.4) : border)),
        child: Text(label,
          style: TextStyle(
            color: active ? primary : muted,
            fontSize: 12, fontWeight: active ? FontWeight.w600 : FontWeight.w400))),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final muted = AppColors.muted(dark);
    final fg = AppColors.fg(dark);
    final primary = AppColors.primary(dark);
    return Center(child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.wifi_off_rounded, color: muted, size: 56),
        const SizedBox(height: 16),
        Text('Failed to load products', style: TextStyle(color: fg, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(message, style: TextStyle(color: muted, fontSize: 12), textAlign: TextAlign.center),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Try again'),
          style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white)),
      ])));
  }
}
