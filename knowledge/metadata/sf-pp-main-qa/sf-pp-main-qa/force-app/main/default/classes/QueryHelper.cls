//Query Helper method
public class QueryHelper {
    
    public static List<SObject> fetchAllFields(SObjectType sObjectType, Set<Id> filterIds, String filterFieldName) {
        if (filterIds == null || filterIds.isEmpty()) {
            return new List<SObject>();
        }

        // Get all field names dynamically
        Map<String, Schema.SObjectField> fieldMap = sObjectType.getDescribe().fields.getMap();
        List<String> fieldNames = new List<String>();
        for (String fName : fieldMap.keySet()) {
            fieldNames.add(fName);
        }

        String query = null;
        
        if(sObjectType == Contract.SObjectType){
            query = 'SELECT ' + String.join(fieldNames, ',') +
                       ' FROM ' + sObjectType.getDescribe().getName() +
                       ' WHERE ' + filterFieldName + ' IN :filterIds and status =\'Executed\'';
            
        }else{
            // Build dynamic query
            query = 'SELECT ' + String.join(fieldNames, ',') +
                       ' FROM ' + sObjectType.getDescribe().getName() +
                       ' WHERE ' + filterFieldName + ' IN :filterIds';
        }
        

        system.debug(filterIds);
        // Execute query and return results
        return Database.query(query);
    }
    
      // New overloaded method — supports extra related fields
    public static List<SObject> fetchAllFields(SObjectType sObjectType, Set<Id> filterIds, String filterFieldName, Set<String> extraFields) {
        if (filterIds == null || filterIds.isEmpty()) {
            return new List<SObject>();
        }

        Map<String, Schema.SObjectField> fieldMap = sObjectType.getDescribe().fields.getMap();
        List<String> fieldNames = new List<String>();
        for (String fName : fieldMap.keySet()) {
            fieldNames.add(fName);
        }

        if (extraFields != null && !extraFields.isEmpty()) {
            fieldNames.addAll(extraFields);
        }

        String query = null;
        
        if(sObjectType == Contract.SObjectType){
            query = 'SELECT ' + String.join(fieldNames, ',') +
                       ' FROM ' + sObjectType.getDescribe().getName() +
                       ' WHERE ' + filterFieldName + ' IN :filterIds and status =\'Executed\''+
            		   ' ORDER BY AccountId, StartDate DESC';
        }else{
            // Build dynamic query
            query = 'SELECT ' + String.join(fieldNames, ',') +
                       ' FROM ' + sObjectType.getDescribe().getName() +
                       ' WHERE ' + filterFieldName + ' IN :filterIds';
        }
        
        return Database.query(query);
    }
}