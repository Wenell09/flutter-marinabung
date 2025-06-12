import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_marinabung/bloc/photo/photo_bloc.dart';
import 'package:flutter_marinabung/bloc/saving/saving_bloc.dart';
import 'package:flutter_marinabung/cubit/select_estimation_cubit.dart';
import 'package:flutter_marinabung/helper/parse_currency_helper.dart';
import 'package:flutter_marinabung/helper/validaton_saving_check.dart';
import 'package:flutter_marinabung/pages/widgets/bottom_bar_widget.dart';
import 'package:flutter_marinabung/pages/widgets/input_saving.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    TextEditingController inputName = TextEditingController();
    TextEditingController inputTarget = TextEditingController();
    TextEditingController inputNominal = TextEditingController();
    final parse = ParseCurrencyHelper();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Buat tabungan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: BlocListener<SavingBloc, SavingState>(
                listener: (context, state) {
                  if (state is SavingLoading) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: EdgeInsets.all(20),
                          content: SizedBox(
                            height: 80,
                            width: 80,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is SavingLoaded) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    inputName.clear();
                    inputNominal.clear();
                    inputTarget.clear();
                    context.read<SelectEstimationCubit>().resetIndex();
                    context.read<PhotoBloc>().add(ResetPhoto());
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          content: Text(
                            "Berhasil menambah daftar tabungan",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    );
                  }
                },
                child: BlocBuilder<SelectEstimationCubit, int>(
                  builder: (context, selectState) {
                    return BlocBuilder<PhotoBloc, PhotoState>(
                      builder: (context, photoState) {
                        return GestureDetector(
                          onTap: () => ValidatonSavingCheck().inputSaving({
                            "user_id": user!.id,
                            "name": inputName.text,
                            "target": (inputTarget.text.isEmpty)
                                ? ""
                                : parse.parseCurrencyToInt(inputTarget.text),
                            "nominal": (inputNominal.text.isEmpty)
                                ? ""
                                : parse.parseCurrencyToInt(inputNominal.text),
                            "remaining": (inputTarget.text.isEmpty)
                                ? ""
                                : parse.parseCurrencyToInt(inputTarget.text),
                            "created_at": DateTime.now(),
                            "file_path": photoState.photoUrl["file_path"] ?? "",
                            "file": photoState.photoUrl["file"] ?? "",
                            "estimation_day": formatEstimation(selectState)
                          }, context),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Text(
                                "Tambah",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )),
        ],
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(20),
            children: [
              BlocBuilder<PhotoBloc, PhotoState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () => context
                        .read<PhotoBloc>()
                        .add(UploadPhoto(userId: user!.id)),
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                          image: (state.photoUrl.isEmpty)
                              ? null
                              : DecorationImage(
                                  image: FileImage(state.photoUrl["file"]),
                                  fit: BoxFit.cover,
                                )),
                      child: (state.photoUrl.isEmpty)
                          ? Center(
                              child: Icon(
                                Icons.add_photo_alternate,
                                size: 70,
                              ),
                            )
                          : null,
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                "Nama tabungan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              SizedBox(height: 10),
              InputSaving(
                type: "nama",
                controller: inputName,
              ),
              SizedBox(height: 10),
              Text(
                "Target tabungan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              SizedBox(height: 10),
              InputSaving(
                type: "target",
                controller: inputTarget,
              ),
              SizedBox(height: 10),
              Text(
                "Nominal yang ditabung",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              SizedBox(height: 10),
              InputSaving(
                type: "nominal",
                controller: inputNominal,
              ),
              SizedBox(height: 10),
              Text(
                "Jangka waktu",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: List.generate(
                    3,
                    (index) => BlocBuilder<SelectEstimationCubit, int>(
                      builder: (context, state) {
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => context
                                .read<SelectEstimationCubit>()
                                .changeIndex(index + 1),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ((index + 1) == state)
                                      ? Colors.white
                                      : Colors.black,
                                  border: ((index + 1) == state)
                                      ? Border.all(
                                          color: Colors.black,
                                          width: 3,
                                        )
                                      : null),
                              child: Center(
                                child: Text(
                                  estimationDay((index + 1)),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ((index + 1) == state)
                                          ? Colors.black
                                          : Colors.white),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
          BottomBarWidget(),
        ],
      ),
    );
  }
}

estimationDay(int index) {
  switch (index) {
    case 1:
      return "Harian";
    case 2:
      return "Mingguan";
    case 3:
      return "Bulanan";
  }
}

formatEstimation(int index) {
  switch (index) {
    case 1:
      return "Hari";
    case 2:
      return "Minggu";
    case 3:
      return "Bulan";
    default:
      return "";
  }
}
