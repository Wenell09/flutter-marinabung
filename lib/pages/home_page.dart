import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_marinabung/bloc/detail_saving/detail_saving_bloc.dart';
import 'package:flutter_marinabung/bloc/saving/saving_bloc.dart';
import 'package:flutter_marinabung/bloc/transaction/transaction_bloc.dart';
import 'package:flutter_marinabung/cubit/clear_search_cubit.dart';
import 'package:flutter_marinabung/pages/detail_page.dart';
import 'package:flutter_marinabung/pages/widgets/bottom_bar_widget.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    TextEditingController inputSearch = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mari Nabung",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(20),
            children: [
              BlocBuilder<ClearSearchCubit, bool>(
                builder: (context, state) {
                  return Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(bottom: 10),
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: inputSearch,
                      onChanged: (value) {
                        context
                            .read<SavingBloc>()
                            .add(SearchSaving(value: value));
                        context.read<ClearSearchCubit>().switchBool(value);
                      },
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: (state)
                            ? IconButton(
                                onPressed: () {
                                  inputSearch.clear();
                                  FocusScope.of(context).unfocus();
                                  context
                                      .read<SavingBloc>()
                                      .add(SearchSaving(value: ""));
                                  context
                                      .read<ClearSearchCubit>()
                                      .switchBool("");
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ))
                            : null,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        hintText: "Cari nama tabungan disini!",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<SavingBloc, SavingState>(
                builder: (context, state) {
                  if (state is SavingLoading) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Center(child: CircularProgressIndicator()));
                  } else if (state is SavingLoaded) {
                    final filteredData = state.filteredDataSaving
                        .where((element) => element.completedAt == "")
                        .toList();
                    if (state.filteredDataSaving.isEmpty ||
                        filteredData.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Center(
                          child: Text(
                            "Data tabungan kosong, yuk tambah!",
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
                        double percent =
                            (data.collected / data.target).clamp(0.0, 1.0);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                            onTap: () {
                              context.read<DetailSavingBloc>().add(
                                  GetDetailSaving(
                                      userId: user!.id,
                                      savingId: data.savingId));
                              context.read<TransactionBloc>().add(
                                  GetTransaction(
                                      savingId: data.savingId,
                                      userId: user.id));
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
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Rp${NumberFormat.decimalPattern('id').format(data.target)}",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              Text(
                                                "Rp${NumberFormat.decimalPattern('id').format(data.nominal)} Per ${data.estimationDay}",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        CircularPercentIndicator(
                                          radius: 30,
                                          percent: percent,
                                          center: Text(
                                            "${(percent * 100).toStringAsFixed(1)}%",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          progressColor: Colors.blue,
                                          backgroundColor: Colors.grey[300]!,
                                          circularStrokeCap:
                                              CircularStrokeCap.round,
                                          animation: true,
                                          animationDuration: 1000,
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Center(
                                      child: Text(
                                        "${data.estimation} ${data.estimationDay} Lagi",
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
          BottomBarWidget(),
        ],
      ),
    );
  }
}
