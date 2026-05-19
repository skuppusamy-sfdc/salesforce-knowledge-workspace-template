public class UpdatePreviousHPFBatchInvoke {
	@InvocableMethod(label='Run processHPFupdatesBactchClassBatch  Job' description='Invokes runprocessHPFupdatesBactchClassBatch from Flow')
    public static void runprocessHPFupdatesBactchClassBatch() {
        Database.executeBatch(new processHPFupdatesBactchClass(), 200);
    }
}