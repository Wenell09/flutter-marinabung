import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_marinabung/bloc/detail_saving/detail_saving_bloc.dart';
import 'package:flutter_marinabung/bloc/saving/saving_bloc.dart';
import 'package:flutter_marinabung/bloc/transaction/transaction_bloc.dart';
import 'package:flutter_marinabung/helper/format_date_helper.dart';
import 'package:flutter_marinabung/helper/parse_currency_helper.dart';
import 'package:flutter_marinabung/pages/completed_page.dart';
import 'package:flutter_marinabung/pages/widgets/input_saving.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DetailPage extends StatelessWidget {
  final String userId;
  final String savingId;
  const DetailPage({
    super.key,
    required this.userId,
    required this.savingId,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController inputNominal = TextEditingController();
    TextEditingController inputNote = TextEditingController();
    return Scaffold(
      body: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionAddSuccess) {
            inputNote.clear();
            inputNominal.clear();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Berhasil menambah tabungan!")));
            context
                .read<DetailSavingBloc>()
                .add(GetDetailSaving(userId: userId, savingId: savingId));
            context.read<SavingBloc>().add(GetSaving(userId: userId));
          } else if (state is TransactionDeleteSuccess) {
            context
                .read<SavingBloc>()
                .add(DeleteSaving(userId: userId, savingId: savingId));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<DetailSavingBloc, DetailSavingState>(
          builder: (context, state) {
            if (state is DetailSavingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DetailSavingLoaded) {
              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                  physics: ClampingScrollPhysics(),
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      content: const Text(
                                        "Apakah kamu ingin hapus tabungan ini?",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text("Tidak"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context.read<TransactionBloc>().add(
                                                DeleteTransaction(
                                                    savingId: savingId,
                                                    userId: userId));
                                          },
                                          child: const Text("Ya"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                              )),
                        ),
                      ],
                      leading: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.black,
                      pinned: true,
                      centerTitle: true,
                      expandedHeight: 120,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          (state.detailSaving.isEmpty)
                              ? ""
                              : state.detailSaving[0].name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final data = state.detailSaving[index];
                            double percent =
                                (data.collected / data.target).clamp(0.0, 1.0);
                            return Column(
                              children: [
                                Card(
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade400,
                                      image: (data.photo.isEmpty)
                                          ? null
                                          : DecorationImage(
                                              image: NetworkImage(data.photo),
                                              fit: BoxFit.cover),
                                    ),
                                    child: (data.photo.isEmpty)
                                        ? Center(
                                            child: Icon(
                                              size: 100,
                                              Icons.landscape_outlined,
                                              color: Colors.black,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Card(
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Rp${NumberFormat.decimalPattern('id').format(data.target)}",
                                                    style:
                                                        TextStyle(fontSize: 25),
                                                  ),
                                                  Text(
                                                    (data.completedAt
                                                            .isNotEmpty)
                                                        ? "Selesai ${hitungDurasiHari(data.createdAt, data.completedAt)} Hari"
                                                        : "Rp${NumberFormat.decimalPattern('id').format(data.nominal)} Per ${data.estimationDay}",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            (data.completedAt.isNotEmpty)
                                                ? Container()
                                                : CircularPercentIndicator(
                                                    radius: 30,
                                                    percent: percent,
                                                    center: Text(
                                                      "${(percent * 100).toStringAsFixed(1)}%",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    progressColor: Colors.blue,
                                                    backgroundColor:
                                                        Colors.grey[300]!,
                                                    circularStrokeCap:
                                                        CircularStrokeCap.round,
                                                    animation: true,
                                                    animationDuration: 1000,
                                                  ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Tanggal dibuat",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              FormatDateHelper().formatTanggal(
                                                  data.createdAt),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              (data.completedAt.isNotEmpty)
                                                  ? "Tanggal selesai"
                                                  : "Estimasi",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              (data.completedAt.isNotEmpty)
                                                  ? FormatDateHelper()
                                                      .formatTanggal(
                                                          data.completedAt)
                                                  : "${data.estimation} ${data.estimationDay} Lagi",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 150),
                                  child: Card(
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                spacing: 5,
                                                children: [
                                                  Text(
                                                    "Terkumpul",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Rp${NumberFormat.decimalPattern('id').format(
                                                      data.collected,
                                                    )}",
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: 1,
                                                height: 45,
                                                color: Colors.grey,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                spacing: 5,
                                                children: [
                                                  Text(
                                                    "Tersisa",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Rp${NumberFormat.decimalPattern('id').format(
                                                      data.remaining,
                                                    )}",
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          BlocBuilder<TransactionBloc,
                                              TransactionState>(
                                            builder: (context, state) {
                                              if (state is TransactionLoading) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else if (state
                                                  is TransactionLoaded) {
                                                if (state
                                                    .dataTransaction.isEmpty) {
                                                  return Column(
                                                    spacing: 10,
                                                    children: [
                                                      Divider(),
                                                      Text(
                                                          "tidak ada histori transaksi"),
                                                    ],
                                                  );
                                                }
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    final data = state
                                                        .dataTransaction[index];
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Divider(),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                FormatDateHelper()
                                                                    .formatTanggalJam(
                                                                        data.createdAt),
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                              Text(
                                                                "+${data.nominal}",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          (data.note.isEmpty)
                                                              ? Container()
                                                              : Text(
                                                                  data.note,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  itemCount: state
                                                      .dataTransaction.length,
                                                );
                                              }
                                              return Column(
                                                spacing: 10,
                                                children: [
                                                  Divider(),
                                                  Text(
                                                      "tidak ada histori transaksi"),
                                                ],
                                              );
                                            },
                                          ),
                                          SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          childCount: state.detailSaving.length,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: BlocBuilder<DetailSavingBloc, DetailSavingState>(
        builder: (context, state) {
          if (state is DetailSavingLoaded) {
            if (state.detailSaving.first.completedAt.isNotEmpty) {
              return Container();
            }
            return FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Tambah tabungan"),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Jumlah nominal",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(height: 10),
                            InputSaving(
                              type: "nominal",
                              controller: inputNominal,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Catatan",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(height: 10),
                            InputSaving(
                              type: "note",
                              controller: inputNote,
                            ),
                          ],
                        ),
                      ),
                      actionsAlignment: MainAxisAlignment.spaceAround,
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Batal",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black,
                          ),
                          child: TextButton(
                            onPressed: () {
                              if (inputNominal.text.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      content: Text(
                                        "Pastikan nominal terisi!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  },
                                );
                              } else if (ParseCurrencyHelper()
                                      .parseCurrencyToInt(inputNominal.text) >=
                                  state.detailSaving[0].target) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      content: Text(
                                        "Pastikan nominal tidak melebihi target!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                context
                                    .read<TransactionBloc>()
                                    .add(AddTransaction(data: {
                                      "user_id": userId,
                                      "saving_id": savingId,
                                      "nominal": ParseCurrencyHelper()
                                          .parseCurrencyToInt(
                                              inputNominal.text),
                                      "note": inputNote.text,
                                    }));
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              "Kirim",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: Colors.black,
              child: Icon(
                size: 30,
                Icons.edit_note_outlined,
                color: Colors.white,
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

formatEstimationDayToIndex(String value) {
  switch (value) {
    case "Hari":
      return 1;
    case "Minggu":
      return 2;
    case "Bulan":
      return 3;
  }
}
