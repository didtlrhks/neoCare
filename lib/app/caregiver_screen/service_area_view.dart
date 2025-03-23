import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceAreaView extends StatefulWidget {
  final List<String> selectedAreas;
  final Function(List<String>) onAreasSelected;

  const ServiceAreaView(
      {super.key, required this.selectedAreas, required this.onAreasSelected});

  @override
  State<ServiceAreaView> createState() => _ServiceAreaViewState();
}

class _ServiceAreaViewState extends State<ServiceAreaView> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _selectedAreas = [];
  final List<String> _allAreas = [
    '서울 강남구',
    '서울 강동구',
    '서울 강북구',
    '서울 강서구',
    '서울 관악구',
    '서울 광진구',
    '서울 구로구',
    '서울 금천구',
    '서울 노원구',
    '서울 도봉구',
    '서울 동대문구',
    '서울 동작구',
    '서울 마포구',
    '서울 서대문구',
    '서울 서초구',
    '서울 성동구',
    '서울 성북구',
    '서울 송파구',
    '서울 양천구',
    '서울 영등포구',
    '서울 용산구',
    '서울 은평구',
    '서울 종로구',
    '서울 중구',
    '서울 중랑구',
    '경기도 고양시',
    '경기도 과천시',
    '경기도 광명시',
    '경기도 광주시',
    '경기도 구리시',
    '경기도 군포시',
    '경기도 김포시',
    '경기도 남양주시',
    '경기도 동두천시',
    '경기도 부천시',
    '경기도 성남시',
    '경기도 수원시',
    '경기도 시흥시',
    '경기도 안산시',
    '경기도 안성시',
    '경기도 안양시',
    '경기도 양주시',
    '경기도 여주시',
    '경기도 오산시',
    '경기도 용인시',
  ];
  List<String> _filteredAreas = [];

  @override
  void initState() {
    super.initState();
    _selectedAreas.addAll(widget.selectedAreas);
    _filteredAreas = List.from(_allAreas);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterAreas(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredAreas = List.from(_allAreas);
      } else {
        _filteredAreas = _allAreas
            .where((area) => area.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleArea(String area) {
    setState(() {
      if (_selectedAreas.contains(area)) {
        _selectedAreas.remove(area);
      } else {
        if (_selectedAreas.length < 5) {
          _selectedAreas.add(area);
        } else {
          // 최대 5개까지만 선택 가능하다는 알림 표시
          Get.snackbar(
            '알림',
            '서비스 지역은 최대 5개까지 선택 가능합니다.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red[100],
            colorText: Colors.red[800],
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '서비스 가능 지역',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // 검색 필드
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterAreas,
              decoration: InputDecoration(
                hintText: '지역명을 검색하세요',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),

          // 선택된 지역 표시
          if (_selectedAreas.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.grey[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '선택한 지역 (${_selectedAreas.length}/5)',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedAreas
                        .map((area) => _buildSelectedAreaChip(area))
                        .toList(),
                  ),
                ],
              ),
            ),

          // 지역 목록
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredAreas.length,
              itemBuilder: (context, index) {
                final area = _filteredAreas[index];
                final isSelected = _selectedAreas.contains(area);

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  title: Text(
                    area,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.normal,
                      color: isSelected ? Colors.black : Colors.black87,
                    ),
                  ),
                  trailing: Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected ? Colors.orange : Colors.grey[400],
                    size: 24,
                  ),
                  onTap: () => _toggleArea(area),
                );
              },
            ),
          ),

          // 완료 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  widget.onAreasSelected(_selectedAreas);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '완료',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAreaChip(String area) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            area,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: () => _toggleArea(area),
            child: const Icon(
              Icons.close,
              size: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
