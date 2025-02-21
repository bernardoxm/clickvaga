import 'package:clickvagas/repository/data_color.dart';
import 'package:clickvagas/repository/data_text.dart';
import 'package:clickvagas/repository/filters_epository.dart';
import 'package:clickvagas/repository/mediaquery_epository.dart';
import 'package:flutter/material.dart';

class FindWidget extends StatefulWidget {
  final int totalSpots;
  final int spotsOccupied;
  final Function(String) onSearch;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onFilterAll;
  final VoidCallback onFilterOccupied;
  final VoidCallback onFilterAvailable;

  const FindWidget({
    Key? key,
    required this.totalSpots,
    required this.spotsOccupied,
    required this.onSearch,
    required this.onAdd,
    required this.onRemove,
    required this.onFilterAll,
    required this.onFilterOccupied,
    required this.onFilterAvailable,
  }) : super(key: key);

  @override
  State<FindWidget> createState() => _FindWidgetState();
}

class _FindWidgetState extends State<FindWidget> {
  DataColor dataColor = DataColor();
  DataText dataText = DataText();
  FiltersData filtersData = FiltersData();
  bool showButtons = false;

  @override
  Widget build(BuildContext context) {
    final mediaData = MediaqueryDataSearch(context);
    final expandedHeight = mediaData.searchexpandedHeight;
    final minHeight = mediaData.searchminHeight;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: showButtons ? expandedHeight : minHeight,
      decoration: BoxDecoration(
        color: dataColor.colorRaroBlueDark,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column( spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [ 
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${dataText.textAvaliable} ${widget.totalSpots - widget.spotsOccupied}',
                  style:  TextStyle(fontSize: 18, color: dataColor.colorWhite),
                ),
                Text(
                  '${dataText.textOccupied} ${widget.spotsOccupied}',
                  style:  TextStyle(fontSize: 18, color: dataColor.colorWhite),
                ),
              ],
            ),
            
      
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: dataColor.colorWhite,
                  hintText: dataText.textEnterPlate,
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: widget.onSearch,
              ),
            ),
       

            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      showButtons = !showButtons;
                    });
                  },
                  icon: Icon(
                    showButtons ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: dataColor.colorWhite,
                    size: 30,
                  ),
                  label:  Text(
                    'Filtros',
                    style: TextStyle(fontSize: 18, color: dataColor.colorWhite),
                  ),
                )
              ],
            ),
         
      
            if (showButtons)
              SizedBox( width: MediaQuery.of(context).size.width * 0.9,
                height: 40,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(spacing: 8,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            filtersData
                            .selectedFilter = 0;
                          });
                          widget.onFilterAll();
                        },
                        icon: Icon(Icons.car_repair,     color: filtersData.selectedFilter == 0 ? dataColor.colorRed : dataColor.colorRaroBlue,),
                        label:  Text(dataText.textShowAll),
                        style: filtersData.selectedFilter == 0
                            ? ElevatedButton.styleFrom(
                                backgroundColor: dataColor.colorWhite,
                                foregroundColor:
                                   dataColor.colorRed,
                              )
                            : ElevatedButton.styleFrom(
                                backgroundColor:
                                    dataColor.colorWhite,
                                foregroundColor:
                                   dataColor.colorRaroBlue,
                              ),
                      ),
                  
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            filtersData.selectedFilter = 1;
                          });
                          widget.onFilterOccupied();
                        },
                        icon:  Icon(Icons.directions_bus,  color: filtersData.selectedFilter == 1 ? dataColor.colorRed : dataColor.colorRaroBlue,),
                        label:  Text(dataText.textShowOccupied),
                        style: filtersData.selectedFilter == 1
                            ? ElevatedButton.styleFrom(
                                backgroundColor: dataColor.colorWhite,
                                foregroundColor:
                                    dataColor.colorRed,
                              )
                            : ElevatedButton.styleFrom(
                                backgroundColor:
                                    dataColor.colorWhite,
                                foregroundColor:
                                    dataColor.colorRaroBlue,
                              ),
                      ),
                    
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            filtersData.selectedFilter = 2;
                          });
                          widget.onFilterAvailable();
                        },
                        icon:  Icon(Icons.directions_bus_filled_outlined, color: filtersData.selectedFilter == 2 ? dataColor.colorRed : dataColor.colorRaroBlue),
                        label:  Text(dataText.textShowAvalible),
                        style: filtersData.selectedFilter == 2
                            ? ElevatedButton.styleFrom(
                                backgroundColor: dataColor.colorWhite,
                                foregroundColor:
                                    dataColor.colorRed,
                              )
                            : ElevatedButton.styleFrom(
                                backgroundColor:
                                   dataColor.colorWhite,
                                foregroundColor:
                                    dataColor.colorRaroBlue
                              ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
