import 'package:dcs_app/domain/models/portfolio.dart';
import 'package:dcs_app/presentation/providers/home_provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeProviderImpl with ChangeNotifier implements HomeProvider {
  final List<Portfolio> _portfolios = [];
  final List<Portfolio> _portfoliosSelected = [];
  bool _showChecked = false;

  @override
  bool get showChecked => _showChecked;

  @override
  set showChecked(bool value) {
    _showChecked = value;
    notifyListeners();
  }

  @override
  List<Portfolio> get portfolios => _portfolios;

  @override
  List<Portfolio> get portfoliosSelected => _portfoliosSelected;

  @override
  void getPortfolios() {
    _portfoliosSelected.clear();
    _portfolios.clear();
    _portfolios.addAll(portfolioMockdata);
    notifyListeners();
  }

  @override
  void selectPortfolio(Portfolio portfolio) {
    if (_portfoliosSelected.contains(portfolio)) {
      _portfoliosSelected.remove(portfolio);
    } else {
      _portfoliosSelected.add(portfolio);
    }
    notifyListeners();
  }

  @override
  Future<List<Portfolio>> syncAccount() async {
    const channel = MethodChannel('com.example.dcs_app');
    List<Portfolio> accounts = [];
    if (await Permission.contacts.request().isGranted) {
      final result = await channel.invokeMethod('getAllAccounts');
      for (var item in result) {
        final account = Portfolio(
          username: item['account_name'],
          email: item['account_name'],
          id: item['account_name'],
          accountType: item['account_type'],
        );
        if (!_isAccountExistent(account)) {
          accounts.add(account);
        }
      }
    }
    if (accounts.isEmpty) return [];

    return accounts;
  }

  bool _isAccountExistent(Portfolio account) {
    for (var portfolio in _portfolios) {
      if (portfolio.accountType == account.accountType &&
          portfolio.email == account.email) {
        return true;
      }
    }
    return false;
  }

  @override
  void clearPortfoliosSelected() {
    _portfoliosSelected.clear();
  }

  @override
  void addAccountSyncToPortfolio() {
    _portfolios.addAll(_portfoliosSelected);
    _portfoliosSelected.clear();
    notifyListeners();
  }

  @override
  void deletePortfolio() {
    for (var portfolioToDelete in _portfoliosSelected) {
      _portfolios.remove(portfolioToDelete);
    }
    _portfoliosSelected.clear();
    _showChecked = false;
    notifyListeners();
  }

  @override
  void createAccount({
    required String accountName,
    String? accountNumber,
    String? username,
    String? email,
  }) {
    final Portfolio portfolio = Portfolio(
      id: accountName,
      username: accountName,
      email: email ?? '',
      accountType: accountName,
    );
    _portfolios.add(portfolio);
    notifyListeners();
  }
}

const portfolioMockdata = [
  Portfolio(
    id: '1',
    username: 'nguyenvana1',
    accountType: 'Google.com',
    email: 'nguyenvana1@gmail.com',
  ),
  Portfolio(
    id: '1',
    username: 'nguyenvana2',
    accountType: 'Google.com',
    email: 'nguyenvana2@gmail.com',
  ),
  Portfolio(
    id: '1',
    username: 'nguyenvana3',
    accountType: 'Google.com',
    email: 'nguyenvana3@gmail.com',
  ),
  Portfolio(
    id: '1',
    username: 'nguyenvana4',
    accountType: 'Google.com',
    email: 'nguyenvana4@gmail.com',
  ),
  Portfolio(
    id: '1',
    username: 'nguyenvana5',
    accountType: 'Google.com',
    email: 'nguyenvana5@gmail.com',
  ),
  Portfolio(
    id: '1',
    username: 'nguyenvana6',
    accountType: 'Google.com',
    email: 'nguyenvana6@gmail.com',
  ),
  Portfolio(
    id: '1',
    username: 'nguyenvana7',
    accountType: 'Google.com',
    email: 'nguyenvana7@gmail.com',
  ),
  Portfolio(
    id: '1',
    username: 'nguyenvan8a',
    accountType: 'Google.com',
    email: 'nguyenvana8@gmail.com',
  ),
];
