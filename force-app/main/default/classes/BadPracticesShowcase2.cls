/**
 * ⚠️ THIS CLASS IS INTENTIONALLY BAD.
 * It exists purely to demonstrate PMD rule violations in Apex.
 * Do NOT use any of these patterns in production code.
 *
 * PMD Rules violated (non-exhaustive):
 *   ApexCRUDViolation, AvoidDeeplyNestedIfStmts, AvoidGlobalModifier,
 *   AvoidHardcodingId, CyclomaticComplexity, EmptyCatchBlock,
 *   IfStmtsMustUseBraces, OperationWithLimitsInLoop, UnusedLocalVariable,
 *   VariableNamingConventions, ApexSOQLInjection, DebugsShouldUseLoggingLevel,
 *   ExcessiveParameterList, OneDeclarationPerLine, WhileLoopsMustUseBraces,
 *   AvoidDebugStatements, NcssMethodCount, ReturnFromFinallyBlock
 */

// PMD: AvoidGlobalModifier - global is only needed for managed packages
global class BadPracticesShowcase2 {

    // PMD: VariableNamingConventions - static constants should be ALL_CAPS
    public static String myConst = 'HARDCODED_VALUE';

    // PMD: AvoidHardcodingId - never hard-code Salesforce record IDs
    private static final Id HARDCODED_ACCOUNT_ID = '0015g00000XXXXX';

    // PMD: OneDeclarationPerLine - each variable should be on its own line
    Integer x = 0, y = 0, z = 0;

    // -----------------------------------------------------------------------
    // PMD: CyclomaticComplexity + NcssMethodCount + AvoidDeeplyNestedIfStmts
    //      ExcessiveParameterList (8 parameters)
    // -----------------------------------------------------------------------
    public static String overlyComplexMethod(
        String a, String b, String c,
        String d, String e, String f,
        String g, String h
    ) {
        String result = '';

        if (a != null) {
            if (b != null) {
                if (c != null) {                    // deeply nested - 3 levels
                    if (d != null) {                // deeply nested - 4 levels
                        if (e != null) {            // deeply nested - 5 levels
                            result = a + b + c + d + e;
                        }
                    }
                }
            }
        }

        if (f == 'ONE') result = 'one';             // PMD: IfStmtsMustUseBraces
        else if (f == 'TWO') result = 'two';        // PMD: IfElseStmtsMustUseBraces
        else if (f == 'THREE') result = 'three';
        else if (f == 'FOUR') result = 'four';
        else if (f == 'FIVE') result = 'five';
        else if (f == 'SIX') result = 'six';        // cyclomatic complexity keeps rising

        Integer i = 0;
        while (i < 10)                              // PMD: WhileLoopsMustUseBraces
            i++;

        return result;
    }

    // -----------------------------------------------------------------------
    // PMD: OperationWithLimitsInLoop (SOQL + DML inside loops)
    //      ApexCRUDViolation (no isAccessible / isUpdateable checks)
    // -----------------------------------------------------------------------
    public static void limitsInLoop(List<Id> accountIds) {
        for (Id accId : accountIds) {

            // PMD: OperationWithLimitsInLoop - SOQL inside a for-loop
            List<Contact> contacts = [
                SELECT Id, FirstName, LastName
                FROM Contact
                WHERE AccountId = :accId
            ];

            for (Contact c : contacts) {
                c.Description = 'Processed';
                // PMD: OperationWithLimitsInLoop - DML inside a nested loop
                update c;   // PMD: ApexCRUDViolation - no isUpdateable() check
            }
        }
    }

    // -----------------------------------------------------------------------
    // PMD: ApexSOQLInjection - user-controlled string concatenated into SOQL
    // -----------------------------------------------------------------------
    public static List<Account> soqlInjectionRisk(String userInput) {
        // NEVER do this - use bind variables instead
        String query = 'SELECT Id, Name FROM Account WHERE Name = \'' + userInput + '\'';
        return Database.query(query);   // PMD: ApexSOQLInjection
    }

    // -----------------------------------------------------------------------
    // PMD: EmptyCatchBlock - swallowing exceptions silently
    //      DebugsShouldUseLoggingLevel - System.debug without a log level
    //      AvoidDebugStatements - debug left in production code
    // -----------------------------------------------------------------------
    public static void poorExceptionHandling() {
        try {
            Account acc = [SELECT Id FROM Account WHERE Id = :HARDCODED_ACCOUNT_ID];
            System.debug('Found account: ' + acc.Id);   // PMD: DebugsShouldUseLoggingLevel
                                                         //      AvoidDebugStatements
        } catch (QueryException e) {
            // PMD: EmptyCatchBlock - exception is silently swallowed
        } catch (Exception e) {
            // PMD: EmptyCatchBlock - another silent swallow
        }
    }

    // -----------------------------------------------------------------------
    // PMD: UnusedLocalVariable - declared but never read
    //      EmptyIfStmt - if block with no body
    // -----------------------------------------------------------------------
    public static void unusedAndEmptyStuff() {
        String unusedVar = 'I am never used anywhere';  // PMD: UnusedLocalVariable

        Integer counter = 5;
        if (counter > 0) {
            // PMD: EmptyIfStmt - nothing happens here
        }

        // PMD: EmptyStatementBlock - empty finally block
        try {
            Integer result = 10 / 0;
        } finally {
            // empty finally block
        }
    }

    // -----------------------------------------------------------------------
    // PMD: AvoidGlobalModifier on method level too
    // -----------------------------------------------------------------------
    global static void globalMethodNotNeeded() {
        // PMD: AvoidGlobalModifier - global is unnecessary here
        System.debug('This is global for no reason');   // PMD: AvoidDebugStatements
    }

    // -----------------------------------------------------------------------
    // PMD: FieldDeclarationsShouldBeAtStart - field declared mid-class
    // -----------------------------------------------------------------------
    public String lateField = 'Declared too late in the class body';

    // -----------------------------------------------------------------------
    // PMD: ReturnFromFinallyBlock - returning from finally is dangerous
    // -----------------------------------------------------------------------
    public static String returnFromFinally() {
        try {
            return 'from try';
        } finally {
            return 'from finally';  // PMD: ReturnFromFinallyBlock - overrides try return
        }
    }

    // -----------------------------------------------------------------------
    // PMD: AvoidNonExistentAnnotations - made-up annotation Salesforce ignores
    // -----------------------------------------------------------------------
   
    public static void annotatedWrong() {
        System.debug('bad annotation above me');    // PMD: AvoidDebugStatements
    }

    // -----------------------------------------------------------------------
    // PMD: NoPaddedBlocks - excessive blank lines inside a block
    // -----------------------------------------------------------------------
    public static void paddedMethod() {

        String val = 'hello';

        System.debug(val);                          // PMD: AvoidDebugStatements

    }

}