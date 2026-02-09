import 'package:a_and_w/features/pengantaran/domain/entities/data_wilayah_entity.dart';
import 'package:a_and_w/features/pengantaran/presentation/cubit/alamat_dropdown_cubit.dart';
import 'package:a_and_w/features/pengantaran/presentation/widgets/wilayah_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PickAlamatPage extends StatefulWidget {
  final Function(
    DataWilayahEntity provinsi,
    DataWilayahEntity kota,
    DataWilayahEntity distrik,
  )
  onAlamatSubmitted;
  const PickAlamatPage({super.key, required this.onAlamatSubmitted});

  @override
  State<PickAlamatPage> createState() => _PickAlamatPageState();
}

class _PickAlamatPageState extends State<PickAlamatPage> {
  final TextEditingController _alamatLengkapController =
      TextEditingController();

  DataWilayahEntity? _provinsi;
  DataWilayahEntity? _kota;
  DataWilayahEntity? _distrik;

  @override
  void dispose() {
    _alamatLengkapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AlamatDropdownCubit>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dropdown Provinsi
          WilayahDropdown(
            label: "Provinsi",
            hint: "Pilih Provinsi",
            selectedItem: _provinsi,
            enabled: true,
            showSearchBox: true,
            onLoadItems: () => cubit.getProvinsiList(),
            onChanged: (value) {
              setState(() {
                _provinsi = value;
                _kota = null;
                _distrik = null;
              });
            },
          ),
          const SizedBox(height: 16),

          // Dropdown Kota
          WilayahDropdown(
            label: "Kota/Kabupaten",
            hint: _provinsi == null ? "Pilih provinsi dulu" : "Pilih Kota",
            selectedItem: _kota,
            enabled: _provinsi != null,
            showSearchBox: true,
            onLoadItems: () async {
              if (_provinsi?.id != null) {
                return await cubit.getKotaList(_provinsi!.id.toString());
              }
              return [];
            },
            onChanged: (value) {
              setState(() {
                _kota = value;
                _distrik = null;
              });
            },
          ),
          const SizedBox(height: 16),

          // Dropdown Distrik
          WilayahDropdown(
            label: "Distrik/Kecamatan",
            hint: _kota == null ? "Pilih kota dulu" : "Pilih Distrik",
            selectedItem: _distrik,
            enabled: _kota != null,
            showSearchBox: true,
            onLoadItems: () async {
              if (_kota?.id != null) {
                return await cubit.getDistrikList(_kota!.id.toString());
              }
              return [];
            },
            onChanged: (value) {
              setState(() {
                _distrik = value;
              });
            },
          ),

          const SizedBox(height: 24),
          TextField(
            controller: _alamatLengkapController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Alamat Lengkap",
              hintText: "Masukkan alamat lengkap Anda",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Validasi semua field
              if (_provinsi == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pilih provinsi terlebih dahulu'),
                  ),
                );
                return;
              }

              if (_kota == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pilih kota/kabupaten terlebih dahulu'),
                  ),
                );
                return;
              }

              if (_distrik == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pilih distrik/kecamatan terlebih dahulu'),
                  ),
                );
                return;
              }

              if (_alamatLengkapController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Masukkan alamat lengkap Anda')),
                );
                return;
              }

              widget.onAlamatSubmitted(_provinsi!, _kota!, _distrik!);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
