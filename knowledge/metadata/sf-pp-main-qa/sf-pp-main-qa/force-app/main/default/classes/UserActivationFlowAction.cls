public with sharing class UserActivationFlowAction {
    
    public class ActivateUserRequest {
        @InvocableVariable(label='User Record' required=true)
        public User userRecord;
    }

    @InvocableMethod(
        label='Activate User Asynchronously'
        description='Queues an asynchronous job to activate existing inactive users.'
        category='User Management'
    )
    public static void activateUsersAsync(List<ActivateUserRequest> requests) {
        Set<Id> userIds = new Set<Id>();
        for (ActivateUserRequest requestItem : requests) {
            if (requestItem?.userRecord?.Id != null) {
                userIds.add(requestItem.userRecord.Id);
            }
        }

        if (!userIds.isEmpty()) {
            // Enqueue the job
            System.enqueueJob(new ActivateUserQueueable(new List<Id>(userIds)));
        }
    }

    // Use 'without sharing' here if the Flow user might lack permissions to edit User records
    public class ActivateUserQueueable implements Queueable {
        private final List<Id> userIds;

        public ActivateUserQueueable(List<Id> userIds) {
            this.userIds = userIds;
        }

        public void execute(QueueableContext context) {
            // Only query users who are currently INACTIVE to save processing
            List<User> usersToActivate = [
                SELECT Id, IsActive 
                FROM User 
                WHERE Id IN :userIds AND IsActive = false
            ];

            if (usersToActivate.isEmpty()) return;

            for (User u : usersToActivate) {
                u.IsActive = true;
            }

            try {
                update usersToActivate;
            } catch (DmlException e) {
                System.debug('Error activating users: ' + e.getMessage());
            }
        }
    }
}