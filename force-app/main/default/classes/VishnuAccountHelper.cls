// PMD Violations:
//   1. ApexSOQLInjection         (Priority 1) - Dynamic SOQL without binding
//   2. AvoidDmlStatementsInLoops (Priority 1) - DML inside for loop
//   3. ApexCRUDViolation         (Priority 3) - No FLS/CRUD check before DML
public class VishnuAccountHelper {

    // PMD Violation 1: ApexSOQLInjection (Priority 1)
    // Dynamic SOQL string built with user input - injection risk
    public static List<Account> searchAccounts(String searchTerm) {
        String query = 'SELECT Id, Name FROM Account WHERE Name LIKE \'%' + searchTerm + '%\'';
        return Database.query(query); // VIOLATION: Use bind variable (:searchTerm) instead
    }

    // PMD Violation 2: AvoidDmlStatementsInLoops (Priority 1)
    // PMD Violation 3: ApexCRUDViolation (Priority 3) - no CRUD check
    public static void updateAccounts(List<Account> accounts) {
        for (Account acc : accounts) {
            acc.Description = 'Updated by Vishnu Helper';
            update acc; // VIOLATION: DML inside loop + no CRUD check
        }
    }
}