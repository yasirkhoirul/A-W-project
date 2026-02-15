import 'package:a_and_w/core/widgets/error_retry.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_track_entity.dart';
import 'package:a_and_w/features/pengantaran/presentation/bloc/pengantara_check_track_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LacakPage extends StatefulWidget {
  final String waybill;
  final String courier;
  final int lastPhoneNumber;

  const LacakPage({
    super.key,
    required this.waybill,
    required this.courier,
    required this.lastPhoneNumber,
  });

  @override
  State<LacakPage> createState() => _LacakPageState();
}

class _LacakPageState extends State<LacakPage> {
  @override
  void initState() {
    super.initState();
    _loadTracking();
  }

  void _loadTracking() {
    context.read<PengantaraCheckTrackBloc>().add(
      OnPengantaranCheckTrack(
        dataTrackRequestEntity: DataTrackRequestEntity(
          waybill: widget.waybill,
          courier: widget.courier,
          lastPhoneNumber: widget.lastPhoneNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lacak Pengiriman'), elevation: 0),
      body: BlocBuilder<PengantaraCheckTrackBloc, PengantaraCheckTrackState>(
        builder: (context, state) {
          if (state is PengantaraCheckTrackLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PengantaraCheckTrackLoaded) {
            if (state.dataCekEntity.isEmpty) {
              return const Center(child: Text('Data tracking tidak ditemukan'));
            }
            return _buildTrackingContent(state.dataCekEntity.first);
          } else if (state is PengantaraCheckTrackError) {
            return ErrorRetry(message: state.message, onRetry: _loadTracking);
          } else {
            return const Center(
              child: Text('Masukkan nomor resi untuk melacak pengiriman'),
            );
          }
        },
      ),
    );
  }

  Widget _buildTrackingContent(DataTrackEntity trackData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (trackData.summary != null) _buildSummaryCard(trackData.summary!),
          const SizedBox(height: 24),
          if (trackData.manifest != null && trackData.manifest!.isNotEmpty)
            _buildManifestTimeline(trackData.manifest!),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(DataTrackSummaryEntity summary) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_shipping,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        summary.courierName ?? 'Kurir',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (summary.serviceCode != null)
                        Text(
                          summary.serviceCode!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('No. Resi', summary.waybillNumber ?? '-'),
            _buildInfoRow('Status', summary.status ?? '-', isStatus: true),
            _buildInfoRow('Tanggal Kirim', summary.waybillDate ?? '-'),
            const Divider(height: 24),
            _buildInfoRow('Pengirim', summary.shipperName ?? '-'),
            _buildInfoRow('Penerima', summary.receiverName ?? '-'),
            _buildInfoRow(
              'Rute',
              '${summary.origin ?? '-'} → ${summary.destination ?? '-'}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isStatus ? FontWeight.bold : FontWeight.normal,
              color: isStatus ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManifestTimeline(List<DataTrackManifestEntity> manifests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Riwayat Pengiriman',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...List.generate(manifests.length, (index) {
          final manifest = manifests[index];
          final isLast = index == manifests.length - 1;
          return _buildTimelineItem(manifest, isLast, index == 0);
        }),
      ],
    );
  }

  Widget _buildTimelineItem(
    DataTrackManifestEntity manifest,
    bool isLast,
    bool isFirst,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFirst
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primaryContainer,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: isFirst
                    ? Icon(
                        Icons.check,
                        size: 14,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (manifest.manifestDate != null ||
                      manifest.manifestTime != null)
                    Text(
                      '${manifest.manifestDate ?? ''} ${manifest.manifestTime ?? ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    manifest.manifestDescription ?? '-',
                    style: TextStyle(
                      fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
                      fontSize: isFirst ? 16 : 14,
                    ),
                  ),
                  if (manifest.cityName != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          manifest.cityName!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
