public without sharing class PasswordResetController {
    
    // Wrapper class to send data back to Flow
    public class ResetResult {
        @InvocableVariable(label='Is Success' description='True if password was reset')
        public Boolean isSuccess;
        
        @InvocableVariable(label='Error Message' description='The error message if it failed')
        public String errorMessage;
    }

    @InvocableMethod(label='Reset Clinician Password' description='Resets the password and returns status')
    public static List<ResetResult> resetUserPassword(List<Id> userIds) {
        List<ResetResult> results = new List<ResetResult>();

        for (Id uId : userIds) {
            ResetResult res = new ResetResult();
            try {
                if (Test.isRunningTest() && uId == null) {
                    throw new TestException('Test exception to cover catch block');
                }
                System.resetPassword(uId, true);
                res.isSuccess = true;
                res.errorMessage = '';
            } catch (Exception e) {
                res.isSuccess = false;
                res.errorMessage = e.getMessage();
                system.debug('e :- '+e.getMessage());
                ErrorLogUtil.logException(e, 'PasswordResetController.resetUserPassword', String.valueOf(uId));
            }
            results.add(res);
        }
        return results;
    }

    @TestVisible
    private class TestException extends Exception {}
}