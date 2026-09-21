import 'package:flutter_test/flutter_test.dart';
import 'package:salary_calculator/models/salary.dart';
import 'package:salary_calculator/models/tax_calculator.dart';

void main() {
  test('gross salary adds the basic salary and all allowances', () {
    const Salary salary = Salary(
      basicSalary: 120000,
      houseRentAllowance: 30000,
      medicalAllowance: 10000,
      travelAllowance: 5000,
    );

    expect(salary.grossSalary, 165000);
  });

  test('no tax is charged below the first slab', () {
    const Salary salary = Salary(
      basicSalary: 40000,
      houseRentAllowance: 5000,
      medicalAllowance: 3000,
      travelAllowance: 2000,
    );

    expect(TaxCalculator.calculate(salary).taxDeduction, 0);
  });

  test('tax for a 165,000 monthly gross uses the 11% slab', () {
    const Salary salary = Salary(
      basicSalary: 120000,
      houseRentAllowance: 30000,
      medicalAllowance: 10000,
      travelAllowance: 5000,
    );

    final SalaryBreakdown breakdown = TaxCalculator.calculate(salary);

    // Annual gross 1,980,000 -> 6,000 + 11% of 780,000 = 91,800 per year.
    expect(breakdown.taxDeduction, closeTo(91800 / 12, 0.01));
    expect(breakdown.netMonthlyIncome, closeTo(165000 - 91800 / 12, 0.01));
  });
}
