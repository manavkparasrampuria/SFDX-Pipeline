// PMD Violations:
//   1. AvoidGlobalModifier  (Priority 3) - Unnecessary global keyword
//   2. NcssMethodCount      (Priority 3) - Method too long/complex
//   3. EmptyCatchBlock      (Priority 3) - Swallowed exception
//   4. ApexOpenRedirect     (Priority 3) - Unvalidated redirect URL
global class VishnuOpportunityService { // VIOLATION: AvoidGlobalModifier

    // PMD Violation: NcssMethodCount (Priority 3) - overly complex method
    public static void processOpportunities(List<Opportunity> opps) {
        List<Opportunity> toUpdate = new List<Opportunity>();
        List<Task> tasksToInsert = new List<Task>();

        for (Opportunity opp : opps) {
            if (opp.StageName == 'Prospecting') {
                opp.Description = 'Stage: Prospecting';
                toUpdate.add(opp);
                tasksToInsert.add(new Task(WhatId = opp.Id, Subject = 'Follow Up', Status = 'Open'));
            } else if (opp.StageName == 'Proposal/Price Quote') {
                opp.Description = 'Stage: Proposal';
                toUpdate.add(opp);
            } else if (opp.StageName == 'Negotiation/Review') {
                opp.Description = 'Stage: Negotiation';
                toUpdate.add(opp);
            } else if (opp.StageName == 'Closed Won') {
                opp.Description = 'Stage: Won';
                toUpdate.add(opp);
                tasksToInsert.add(new Task(WhatId = opp.Id, Subject = 'Send Contract', Status = 'Open'));
            } else if (opp.StageName == 'Closed Lost') {
                opp.Description = 'Stage: Lost';
                toUpdate.add(opp);
            }
        }

        // PMD Violation: EmptyCatchBlock (Priority 3)
        try {
            update toUpdate;
            insert tasksToInsert;
        } catch (DmlException e) {
            // VIOLATION: Exception is silently swallowed - log or rethrow it
        }
    }

    // PMD Violation: ApexOpenRedirect (Priority 3)
    public PageReference redirectToPage(String url) {
        PageReference ref = new PageReference(url); // VIOLATION: unvalidated external URL
        ref.setRedirect(true);
        return ref;
    }
}