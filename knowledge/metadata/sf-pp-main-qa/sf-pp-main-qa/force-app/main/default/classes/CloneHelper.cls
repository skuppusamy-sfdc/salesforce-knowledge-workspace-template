//CloneHelper for any object
public class CloneHelper {
    public static SObject dynamicClone(SObject original, List<String> excludeFields, Map<String, Object> overrideValues) {
        SObject clone = original.getSObjectType().newSObject();
        Map<String, Schema.SObjectField> fieldMap = original.getSObjectType().getDescribe().fields.getMap();

        for (String fieldName : fieldMap.keySet()) {
            Schema.DescribeFieldResult fieldDesc = fieldMap.get(fieldName).getDescribe();
            if (fieldDesc.isCreateable() && fieldDesc.isUpdateable() && !excludeFields.contains(fieldName)) {
                clone.put(fieldName, original.get(fieldName));
            }
        }

        if (overrideValues != null) {
            for (String key : overrideValues.keySet()) {
                clone.put(key, overrideValues.get(key));
            }
        }
        system.debug('@@@clone Helper Method'+clone);
        return clone;
    }
       
}