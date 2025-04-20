import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettlementDetailView extends StatelessWidget {
  const SettlementDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          '정산 상세 내역',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '간병 비용 정산 내역',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow('1일 간병비용', '20,000원'),
                    const SizedBox(height: 12),
                    _buildRow('전체 간병비용\n(총 1일)', '20,000원'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1, color: Colors.black12),
                    ),
                    _buildRow('- 중개수수료 (3%)', '600원'),
                    const SizedBox(height: 16),
                    _buildRow(
                      '소계\n(간병비용 - 중개 수수료)',
                      '19,400원',
                      isSubtotal: true,
                    ),
                    const SizedBox(height: 16),
                    _buildRow('- 원천징수 (3.3%)', '627원'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1, color: Colors.black12),
                    ),
                    _buildRow('정산금액', '18,773원', isTotal: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String amount,
      {bool isSubtotal = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight:
                  isTotal || isSubtotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.indigo[700] : Colors.black87,
              height: 1.5,
            ),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight:
                isTotal || isSubtotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.indigo[700] : Colors.black87,
          ),
        ),
      ],
    );
  }
}
