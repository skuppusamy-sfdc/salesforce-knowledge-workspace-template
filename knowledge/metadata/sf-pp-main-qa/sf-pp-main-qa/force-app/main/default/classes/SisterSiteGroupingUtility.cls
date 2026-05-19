public with sharing class SisterSiteGroupingUtility {

    /**
     * Groups related accounts from AccountAccountRelation into SisterSite groups.
     * @return A wrapper containing the requested maps including account names for validation.
     */
    public class GroupingResult {
        public Map<String, Set<Id>> groupToAccountIds;
        public Map<Id, String> accountIdToGroup;
        public Map<Id, String> accountIdToName; // Added for validation

        public GroupingResult() {
            this.groupToAccountIds = new Map<String, Set<Id>>();
            this.accountIdToGroup = new Map<Id, String>();
            this.accountIdToName = new Map<Id, String>();
        }
    }

    /**
     * Groups all active AccountAccountRelation entries into SisterSite groups.
     * Uses a graph-based connected components algorithm.
     */
    public static GroupingResult getSisterSiteGroups() {
        GroupingResult result = new GroupingResult();

        // 1. Build an adjacency list (Graph) of related accounts
        // We consider the relationship undirected for grouping purposes
        Map<Id, Set<Id>> adjMap = new Map<Id, Set<Id>>();
        Set<Id> allAccountIds = new Set<Id>();

        List<AccountAccountRelation> relations = [
            SELECT AccountId, Account.Name, RelatedAccountId, RelatedAccount.Name 
            FROM AccountAccountRelation 
            WHERE IsActive = true 
            AND PartyRoleRelation.Name = 'Sister-Sister-AAR' AND IsActive = true
        ];

        if (relations.isEmpty()) {
            return result;
        }

        for (AccountAccountRelation aar : relations) {
            if (aar.AccountId == null || aar.RelatedAccountId == null) continue;

            addToAdjMap(adjMap, aar.AccountId, aar.RelatedAccountId);
            addToAdjMap(adjMap, aar.RelatedAccountId, aar.AccountId);
            
            allAccountIds.add(aar.AccountId);
            allAccountIds.add(aar.RelatedAccountId);

            // Store names for validation
            result.accountIdToName.put(aar.AccountId, aar.Account.Name);
            result.accountIdToName.put(aar.RelatedAccountId, aar.RelatedAccount.Name);
        }

        // 2. Find connected components using BFS
        Set<Id> visited = new Set<Id>();
        Integer groupCounter = 1;

        for (Id accId : allAccountIds) {
            if (!visited.contains(accId)) {
                String groupName = 'SisterSite' + groupCounter;
                Set<Id> currentGroup = new Set<Id>();
                
                // Start BFS from this unvisited node
                List<Id> queue = new List<Id>{accId};
                visited.add(accId);

                while (!queue.isEmpty()) {
                    Id currentId = queue.remove(0);
                    currentGroup.add(currentId);
                    result.accountIdToGroup.put(currentId, groupName);

                    if (adjMap.containsKey(currentId)) {
                        for (Id neighbor : adjMap.get(currentId)) {
                            if (!visited.contains(neighbor)) {
                                visited.add(neighbor);
                                queue.add(neighbor);
                            }
                        }
                    }
                }

                result.groupToAccountIds.put(groupName, currentGroup);
                groupCounter++;
            }
        }

        return result;
    }

    private static void addToAdjMap(Map<Id, Set<Id>> adjMap, Id fromId, Id toId) {
        if (!adjMap.containsKey(fromId)) {
            adjMap.put(fromId, new Set<Id>());
        }
        adjMap.get(fromId).add(toId);
    }
}