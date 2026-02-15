import 'package:a_and_w/core/router/router.dart';
import 'package:a_and_w/features/history/presentation/cubit/history_cubit.dart';
import 'package:a_and_w/features/history/presentation/cubit/history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().watchHistory();
  }

  Color _getStatusColor(String status) {
    final s = status.toLowerCase();
    if (s == 'settlement' || s == 'capture') return Colors.green;
    if (s == 'pending') return Colors.orange;
    if (s == 'deny' || s == 'cancel' || s == 'expire' || s == 'failure') {
      return Colors.red;
    }
    return Colors.grey;
  }

  String _formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Pesanan')),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryError) {
            return Center(child: Text(state.message));
          } else if (state is HistoryLoaded) {
            if (state.history.isEmpty) {
              return const Center(child: Text('Belum ada riwayat pesanan'));
            }
            return ListView.builder(
              reverse: true,
              itemCount: state.history.length,
              itemBuilder: (context, index) {
                final history = state.history[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    onTap: () {
                      context.goNamed(
                        AppRouter.detailHistory,
                        pathParameters: {'orderId': history.orderId},
                      );
                    },
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      'Order ID: ${history.orderId}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          DateFormat(
                            'dd MMM yyyy, HH:mm',
                          ).format(history.createdAt),
                        ),
                        const SizedBox(height: 4),
                        Text('${history.items.length} Barang'),
                        const SizedBox(height: 4),
                        Text(
                          _formatCurrency(history.grossAmount),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(history.status).withAlpha(25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getStatusColor(history.status),
                        ),
                      ),
                      child: Text(
                        history.status.toUpperCase(),
                        style: TextStyle(
                          color: _getStatusColor(history.status),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
