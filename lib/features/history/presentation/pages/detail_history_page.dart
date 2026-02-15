import 'package:a_and_w/core/router/router.dart';
import 'package:a_and_w/core/utils/validators.dart';
import 'package:a_and_w/core/widgets/button.dart';
import 'package:a_and_w/core/widgets/midtrans_dialog_response.dart';
import 'package:a_and_w/core/widgets/text_field.dart';
import 'package:a_and_w/features/history/presentation/cubit/history_cubit.dart';
import 'package:a_and_w/features/history/presentation/cubit/history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DetailHistoryPage extends StatefulWidget {
  final String orderId;

  const DetailHistoryPage({super.key, required this.orderId});

  @override
  State<DetailHistoryPage> createState() => _DetailHistoryPageState();
}

class _DetailHistoryPageState extends State<DetailHistoryPage> {
  final _manualFormKey = GlobalKey<FormState>();
  final _resiController = TextEditingController();
  final _kurirController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HistoryDetailCubit>().watchDetail(widget.orderId);
  }

  @override
  void dispose() {
    _resiController.dispose();
    _kurirController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan')),
      body: BlocConsumer<HistoryDetailCubit, HistoryDetailState>(
        listener: (context, state) {
          if (state is HistoryDetailLoaded) {
            _kurirController.text = state.history.shipping.code;
            _phoneController.text = state.history.customer.phoneNumber;
          }
        },
        builder: (context, state) {
          if (state is HistoryDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryDetailError) {
            return Center(child: Text(state.message));
          } else if (state is HistoryDetailLoaded) {
            final history = state.history;
            final isPending = history.status.toLowerCase() == 'pending';
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      spacing: 24,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatusSection(history),
                        _buildShippingSection(history),
                        _buildItemsSection(history),
                        _buildPaymentSection(history),
                      ],
                    ),
                  ),
                ),
                if (isPending)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(13),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => DialogBayar(
                              riderectUrl: history.midtransRedirectUrl,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Bayar Sekarang',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 120),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildStatusSection(dynamic history) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(history.status).withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor(history.status)),
      ),
      child: Column(
        children: [
          Text(
            history.status.toUpperCase(),
            style: TextStyle(
              color: _getStatusColor(history.status),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Order ID: ${history.orderId}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            DateFormat('dd MMMM yyyy, HH:mm').format(history.createdAt),
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingSection(dynamic history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi Pengiriman',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_shipping_outlined, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${history.shipping.name} - ${history.shipping.service}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),
                Text('Penerima: ${history.customer.displayName}'),
                Text('Email: ${history.customer.email}'),
                Text('No HP: ${history.customer.phoneNumber}'),
                Text('Kota: ${history.customer.city}'),
                if (history.noResi != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Resi: ${history.noResi}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  MyButton(
                    text: "Lacak Resi",
                    onPressed: () {
                      context.goNamed(
                        AppRouter.lacak,
                        pathParameters: {
                          'orderId': history.orderId,
                          'waybill': history.noResi ?? '',
                          'courier': history.shipping.code ?? '',
                          'lastPhoneNumber': history.customer.phoneNumber ?? '',
                        },
                      );
                    },
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Barang belum dikirimkan / resi belum diupload',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Anda bisa lacak resi manual:'),
                  const SizedBox(height: 8),
                  Form(
                    key: _manualFormKey,
                    child: Column(
                      spacing: 8,
                      children: [
                        MyTextField(
                          label: "No Resi",
                          controller: _resiController,
                          validator: Validators.required,
                        ),
                        MyTextField(
                          label: "Kode Kurir",
                          controller: _kurirController,
                          validator: Validators.required,
                        ),
                        MyTextField(
                          label: "Nomor HP Anda",
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: Validators.phone,
                        ),
                        MyButton(
                          text: "Lacak Resi",
                          onPressed: () {
                            if (_manualFormKey.currentState!.validate()) {
                              context.goNamed(
                                AppRouter.lacak,
                                pathParameters: {
                                  'orderId': history.orderId,
                                  'waybill': _resiController.text.trim(),
                                  'courier': _kurirController.text.trim(),
                                  'lastPhoneNumber': _phoneController.text
                                      .trim(),
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSection(dynamic history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rincian Pesanan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = history.items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(
                  '${item.quantity} x ${_formatCurrency(item.price)}',
                ),
                trailing: Text(
                  _formatCurrency(item.subtotal),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSection(dynamic history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rincian Pembayaran',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Harga Barang'),
                    Text(_formatCurrency(history.totalPrice)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Biaya Pengiriman'),
                    Text(_formatCurrency(history.shippingCost)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _formatCurrency(history.grossAmount),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
