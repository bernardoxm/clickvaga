import 'package:clickvagas/repository/data_color.dart';
import 'package:clickvagas/repository/data_text.dart';
import 'package:clickvagas/repository/filters_epository.dart';
import 'package:clickvagas/repository/mediaquery_epository.dart';
import 'package:flutter/material.dart';

class HistFilterWidget extends StatefulWidget {
  final Function() onFilterAll;
  final Function() onFilterActive;
  final Function() onFilterFinished;
  final Function() onFilterByDate;

  const HistFilterWidget({
    Key? key,
    required this.onFilterAll,
    required this.onFilterActive,
    required this.onFilterFinished,
    required this.onFilterByDate,
  }) : super(key: key);

  @override
  State<HistFilterWidget> createState() => _HistFilterWidgetState();
}

class _HistFilterWidgetState extends State<HistFilterWidget> {
  DataColor dataColor = DataColor();
  DataText dataText = DataText();
  FiltersData filtersData = FiltersData();
  bool showFilters = false;

  @override
  Widget build(BuildContext context) {
     final mediaData = MediaqueryDataHist(context);

    final expandedHeight = mediaData.histsearchexpandedHeight;
    final minHeight = mediaData.histsearchminHeight;



    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: MediaQuery.of(context).size.width * 1,
      height: showFilters ? expandedHeight : minHeight,
      decoration: BoxDecoration(
        color: dataColor.colorRaroBlueDark,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                showFilters = !showFilters;
              });
            },
           
            label: Text(
              dataText.textFilters,
              style: TextStyle(fontSize: 18, color: dataColor.colorWhite),
              
            ),
             icon: Icon(
              showFilters ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: dataColor.colorWhite,
              size: 30,
            ),
          ),
          if (showFilters)
            SizedBox(
              width: MediaQuery.of(context).size.width * 1.1,
              height: 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _filterButton(dataText.textShowAll, Icons.list, 0,
                        widget.onFilterAll),
                    _filterButton(dataText.textShowOccupied,
                        Icons.directions_bus, 1, widget.onFilterActive),
                    _filterButton(
                        dataText.textShowAvailables,
                        Icons.directions_bus_filled_outlined,
                        2,
                        widget.onFilterFinished),
                    _filterButton(dataText.textFilterByDate, Icons.date_range,
                        3, widget.onFilterByDate),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _filterButton(
      String label, IconData icon, int filterType, Function() onPressed) {
    bool isSelected = filtersData.selectedFilter == filterType;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            filtersData.selectedFilter = filterType;
          });
          onPressed();
        },
        icon: Icon(icon,
            color: isSelected ? dataColor.colorRed : dataColor.colorRaroBlue),
        label: Text(label),
        style: isSelected
            ? ElevatedButton.styleFrom(
                backgroundColor: dataColor.colorWhite,
                foregroundColor: dataColor.colorRed,
              )
            : ElevatedButton.styleFrom(
                backgroundColor: dataColor.colorWhite,
                foregroundColor: dataColor.colorRaroBlue,
              ),
      ),
    );
  }
}
