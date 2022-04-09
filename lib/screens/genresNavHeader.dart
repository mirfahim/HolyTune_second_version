import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/my_colors.dart';
import '../providers/GenreMediaScreensModel.dart';

Column genresNavHeader() {
  return Column(
    children: <Widget>[
      Consumer<GenreMediaScreensModel>(builder: (context, catsProvider, child) {
        return Container(
          height: 55,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            //itemExtent: 100,
            itemCount: catsProvider.genresList.length,
            itemBuilder: (context, index) {
              bool selected = catsProvider.isGenreSelected(index);
              return Container(
                //width: 80,
                child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ChoiceChip(
                      label: Text(catsProvider.genresList[index].title),
                      selected: selected,
                      selectedColor: MyColors.accent,
                      onSelected: (bool selected) {
                        catsProvider.refreshPageOnGenreSelected(
                            catsProvider.genresList[index].id);
                      },
                      backgroundColor: Colors.grey[600],
                      labelStyle: TextStyle(color: Colors.white),
                    )
                    /*InkWell(
                    onTap: () {
                      catsProvider.refreshPageOnGenreSelected(
                          catsProvider.genresList[index].id);
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(catsProvider.genresList[index].title,
                                style: TextStyles.headline(context).copyWith(
                                    fontFamily: "serif",
                                    fontSize: 15,
                                    fontWeight: selected
                                        ? FontWeight.bold
                                        : FontWeight.normal)),
                            selected
                                ? Container(
                                    width: 70,
                                    height: 2,
                                    color: MyColors.primary,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),*/
                    ),
              );
            },
          ),
        );
      }),
      // Divider(),
    ],
  );
}
