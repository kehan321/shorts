import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shorts/core/widgets/paginated_list_view.dart';
import 'package:shorts/data/models/product_model.dart';

import '/core/constants/status_switcher.dart';
import 'product_cubit.dart';
import 'product_state.dart';

class ProductPage extends StatefulWidget {
  final ProductCubit cubit;

  const ProductPage({super.key, required this.cubit});

  @override
  State<ProductPage> createState() => _ProductState();
}

class _ProductState extends State<ProductPage> {
  ProductCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: cubit.product,
        child: BlocBuilder(
          bloc: cubit,
          builder: (context, state) {
            state as ProductState;
            return state.response.toWidget(
              onCompleted: (context, data) {
                return PaginatedListView(
                  items: data.products,
                  isLoadingMore: state.isLoadingMore,
                  onLoadMore: cubit.loadMore,
                  itemBuilder: (context, item, index) =>
                      ProductDetailPage(dst: item),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.dst});

  final Product dst;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImageHeader(dst: dst),
          ProductInfoSection(dst: dst),
          Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          ProductDetailsSection(dst: dst),
          Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          ShippingPolicySection(dst: dst),
          Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          ReviewsSection(dst: dst),
          Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          MetaSection(dst: dst),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Image Header ────────────────────────────────────────────────────────────

class ProductImageHeader extends StatelessWidget {
  const ProductImageHeader({super.key, required this.dst});
  final Product dst;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 240,
      width: double.infinity,
      child: Stack(
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: dst.thumbnail,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: _Badge(
              label: dst.availabilityStatus,
              color: const Color(0xFFE6F4EA),
              textColor: const Color(0xFF1E7E34),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: _Badge(
              label: dst.discountPercentage.toString(),
              color: const Color(0xFFFFF3E0),
              textColor: const Color(0xFFE65100),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _Badge({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

// ─── Product Info ─────────────────────────────────────────────────────────────

class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({super.key, required this.dst});

  final Product dst;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${dst.category} · ${dst.brand}',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 0.8,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            dst.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            dst.description,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '\$${dst.price}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '\$${dst.discountPercentage}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            children: [...dst.tags.map((tag) => _TagChip(label: tag))],
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEDFE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF3C3489),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ─── Product Details Grid ─────────────────────────────────────────────────────

class ProductDetailsSection extends StatelessWidget {
  const ProductDetailsSection({super.key, required this.dst});

  final Product dst;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Product Details'),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DetailCard(label: 'SKU', value: dst.sku),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _DetailCard(label: 'Weight', value: '${dst.weight} g'),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _DetailCard(
                  label: 'Dimensions',
                  value:
                      '${dst.dimensions?.width} × ${dst.dimensions?.height} × ${dst.dimensions?.depth}',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _DetailCard(
                  label: 'Min. Order',
                  value: '${dst.minimumOrderQuantity} units',
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _DetailCard(label: 'Stock', value: '${dst.stock} units'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _DetailCard(label: 'Rating', value: '${dst.rating} / 5'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String label;
  final String value;

  const _DetailCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shipping & Policy ────────────────────────────────────────────────────────

class ShippingPolicySection extends StatelessWidget {
  const ShippingPolicySection({super.key, required this.dst});
  final Product dst;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Shipping & Policy'),
          const SizedBox(height: 12),
          _PolicyRow(
            icon: Icons.local_shipping_outlined,
            label: 'Shipping',
            value: dst.shippingInformation,
          ),
          const SizedBox(height: 10),
          _PolicyRow(
            icon: Icons.verified_outlined,
            label: 'Warranty',
            value: dst.warrantyInformation,
          ),
          const SizedBox(height: 10),
          _PolicyRow(
            icon: Icons.cancel_outlined,
            label: 'Returns',
            value: dst.returnPolicy,
            valueColor: const Color(0xFFC0392B),
          ),
        ],
      ),
    );
  }
}

class _PolicyRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _PolicyRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[500]),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF888888)),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: valueColor ?? const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}

// ─── Reviews ──────────────────────────────────────────────────────────────────

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key, required this.dst});
  final Product dst;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Reviews'),
          SizedBox(height: 12),

          Column(
            spacing: 12,

            children: dst.reviews
                .map(
                  (rev) => _ReviewCard(
                    name: rev.reviewerName,
                    rating: rev.rating,
                    comment: rev.comment,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;

  const _ReviewCard({
    required this.name,
    required this.rating,
    required this.comment,
  });

  Color get _starColor {
    if (rating >= 4) return const Color(0xFF27AE60);
    if (rating == 3) return const Color(0xFFF39C12);
    return const Color(0xFFE74C3C);
  }

  String get _stars => '★' * rating + '☆' * (5 - rating);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),

        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(_stars, style: TextStyle(fontSize: 13, color: _starColor)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            comment,
            style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }
}

// ─── Meta ─────────────────────────────────────────────────────────────────────

class MetaSection extends StatelessWidget {
  const MetaSection({super.key, required this.dst});
  final Product dst;

  @override
  Widget build(BuildContext context) {
    final meta = dst.meta;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Meta'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _MetaRow(
                      label: 'Barcode',
                      value: meta?.barcode ?? '',
                      mono: true,
                    ),
                    SizedBox(height: 8),
                    _MetaRow(
                      label: 'Created',
                      value: meta?.createdAt?.toLocal().toString() ?? '',
                    ),
                    SizedBox(height: 8),
                    _MetaRow(
                      label: 'Updated',
                      value: meta?.updatedAt?.toLocal().toString() ?? '',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  meta?.qrCode ?? '',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 64,
                    height: 64,
                    color: const Color(0xFFEEEEEE),
                    child: const Icon(
                      Icons.qr_code,
                      size: 32,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String? value;
  final bool mono;

  const _MetaRow({required this.label, this.value, this.mono = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
        ),
        Text(
          value ?? '',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1A1A1A),
            fontFamily: mono ? 'monospace' : null,
          ),
        ),
      ],
    );
  }
}

// ─── Shared ───────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF888888),
      ),
    );
  }
}
