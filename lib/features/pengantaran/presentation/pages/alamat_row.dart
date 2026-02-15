import 'package:a_and_w/core/dependency_injection.dart';
import 'package:a_and_w/core/entities/profile.dart';
import 'package:a_and_w/core/widgets/button.dart';
import 'package:a_and_w/features/pengantaran/presentation/cubit/alamat_dropdown_cubit.dart';
import 'package:a_and_w/features/pengantaran/presentation/pages/pick_alamat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlamatRow extends StatefulWidget {
  final Function(Address) onAlamatSubmitted;
  final ValueChanged<bool>? onUpdatingChanged;
  final Address? _address;
  const AlamatRow(
    this._address, {
    super.key,
    required this.onAlamatSubmitted,
    this.onUpdatingChanged,
  });

  @override
  State<AlamatRow> createState() => _AlamatRowState();
}

class _AlamatRowState extends State<AlamatRow> {
  bool isUpdating = false;
  double _turns = 0.0;

  void _rotateIcon() {
    setState(() {
      _turns += 0.5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget._address == null
            ? Column(
                children: [
                  const Text("Alamat belum ditambahkan"),
                  MyButton(
                    onPressed: () {
                      setState(() {
                        isUpdating = !isUpdating;
                        widget.onUpdatingChanged?.call(isUpdating);
                      });
                      _rotateIcon();
                    },
                   text: "Pilih Alamat",
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Alamat: "),
                  Flexible(
                    child: !isUpdating
                        ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                  "${widget._address!.district.nama}, ${widget._address!.kota.nama}, ${widget._address!.provinsi.nama}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        )
                        : Text("Pilih Alamat"),
                  ),
                  AnimatedRotation(
                    turns: _turns, 
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    curve: Curves.easeInOut, 
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isUpdating = !isUpdating;
                          widget.onUpdatingChanged?.call(isUpdating);
                        });
                        _rotateIcon();
                      },
                      icon: const Icon(Icons.arrow_drop_up_rounded),
                    ),
                  ),
                ],
              ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: isUpdating
              ? BlocProvider(
                  create: (context) => locator<AlamatDropdownCubit>(),
                  child: PickAlamatPage(
                    onAlamatSubmitted: (provinsi, kota, distrik) {
                      final dataProv = DataAddress(
                        id: provinsi.id!,
                        nama: provinsi.name!,
                      );
                      final dataKota = DataAddress(
                        id: kota.id!,
                        nama: kota.name!,
                      );
                      final dataDistrik = DataAddress(
                        id: distrik.id!,
                        nama: distrik.name!,
                      );
                      setState(() {
                        widget.onAlamatSubmitted(
                          Address(
                            provinsi: dataProv,
                            kota: dataKota,
                            district: dataDistrik,
                          ),
                        );
                        isUpdating = !isUpdating;
                        widget.onUpdatingChanged?.call(isUpdating);
                      });
                    },
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}
