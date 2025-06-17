import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_marinabung/bloc/detail_saving/detail_saving_bloc.dart';
import 'package:flutter_marinabung/bloc/saving/saving_bloc.dart';
import 'package:flutter_marinabung/bloc/transaction/transaction_bloc.dart';
import 'package:flutter_marinabung/pages/detail_page.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CompletedPage extends StatelessWidget {
  const CompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          "Tabungan Selesaiku",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          BlocBuilder<SavingBloc, SavingState>(
            builder: (context, state) {
              if (state is SavingLoading) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(child: CircularProgressIndicator()));
              } else if (state is SavingLoaded) {
                final filteredData = state.filteredDataSaving
                    .where((element) => element.completedAt != "")
                    .toList();
                if (state.filteredDataSaving.isEmpty || filteredData.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: Text(
                        "Data tabungan selesai kosong!",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final data = filteredData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          context.read<DetailSavingBloc>().add(GetDetailSaving(
                              userId: user!.id, savingId: data.savingId));
                          context.read<TransactionBloc>().add(GetTransaction(
                              savingId: data.savingId, userId: user.id));
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailPage(
                              userId: user.id,
                              savingId: data.savingId,
                            ),
                          ));
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  height: 180,
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
                                SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    "Rp${NumberFormat.decimalPattern('id').format(data.target)}",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Divider(),
                                Center(
                                  child: Text(
                                    "Selesai ${hitungDurasiHari(data.createdAt, data.completedAt)} Hari",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: filteredData.length,
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}

int hitungDurasiHari(String createdAtStr, String completedAtStr) {
  DateTime createdAt = DateTime.parse(createdAtStr);
  DateTime completedAt = DateTime.parse(completedAtStr);
  Duration duration = completedAt.difference(createdAt);
  int days = duration.inDays;
  if (days < 1) {
    return 1;
  }
  return days;
}
