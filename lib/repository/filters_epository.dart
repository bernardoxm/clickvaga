class FiltersData {
  bool isSearching = false;
  String? search = '';

  void setSearch(String value) {
    search = value;
  }

  void toggleSearch() {
    isSearching = !isSearching;
  }

  int totalSpots = 0;
  int crossAxisCount = 1;
  double childAspectRatio = 4;
  int filterStatus = 0; 
  int selectedFilter = 0; 
}
