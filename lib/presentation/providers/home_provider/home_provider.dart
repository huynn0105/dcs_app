import 'package:dcs_app/domain/models/portfolio.dart';
import 'package:flutter/material.dart';

abstract class HomeProvider with ChangeNotifier {
  List<Portfolio> get portfolios;
  List<Portfolio> get portfoliosSelected;
  bool get showChecked;
  set showChecked(bool value);
  void getPortfolios();
  void selectPortfolio(Portfolio portfolio);
  void addAccountSyncToPortfolio();
  Future<List<Portfolio>> syncAccount();
  void clearPortfoliosSelected();
  void deletePortfolio();
  void createAccount({
    required String accountName,
    String? accountNumber,
    String? username,
    String? email,
  });
}
