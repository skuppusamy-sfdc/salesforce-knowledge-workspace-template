public  class TruSalesAppSettingsSaveFuture {
    @Future
    public static void permissionSetAssignmentUpsert(Set<Id> userIds)
    {
        List<PermissionSetAssignment> permissionSetAssignmentList = new List<PermissionSetAssignment>();
        List<PermissionSet> permissionSetIds = new List<PermissionSet>();
        permissionSetIds =  [SELECT Id From PermissionSet WHERE Label = 'Sales Feedback Requester'];
        Id permissionId;

        if(!permissionSetIds.isEmpty())
        {
            permissionId = permissionSetIds[0].Id;

            for(Id user: userIds)
            {
                    PermissionSetAssignment permissionSetAssignment = new PermissionSetAssignment(PermissionSetId = permissionId, AssigneeId = user);
                    permissionSetAssignmentList.add(permissionSetAssignment);
            }
        }

        if(!permissionSetAssignmentList.isEmpty())
        {
            upsert permissionSetAssignmentList;
        }
    }

}