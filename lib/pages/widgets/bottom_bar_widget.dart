import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_marinabung/cubit/index_bottom_cubit.dart';
import 'package:flutter_marinabung/pages/add_page.dart';
import 'package:flutter_marinabung/pages/home_page.dart';
import 'package:flutter_marinabung/pages/profile_page.dart';

class BottomBarWidget extends StatelessWidget {
  const BottomBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Container(
          width: 260,
          height: 65,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: BlocBuilder<IndexBottomCubit, int>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        context.read<IndexBottomCubit>().changeIndex(index);
                        navigationCase(index, context);
                      },
                      child: CircleAvatar(
                        backgroundColor:
                            (state == index) ? Colors.white : Colors.white70,
                        radius: 25,
                        child: Center(child: iconCase(index)),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void navigationCase(int index, BuildContext context) {
  switch (index) {
    case 0:
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => HomePage(),
        transitionDuration: Duration(seconds: 0),
      ));
      break;
    case 1:
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => AddPage(),
        transitionDuration: Duration(seconds: 0),
      ));
      break;
    case 2:
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => ProfilePage(),
        transitionDuration: Duration(seconds: 0),
      ));
      break;
  }
}

iconCase(int index) {
  switch (index) {
    case 0:
      return Icon(
        Icons.home,
        color: Colors.black,
        size: 35,
      );
    case 1:
      return Icon(
        Icons.add,
        color: Colors.black,
        size: 35,
      );
    case 2:
      return Icon(
        Icons.person,
        color: Colors.black,
        size: 35,
      );
  }
}
