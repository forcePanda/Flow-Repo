public inherited sharing class INClauseFilterAction {

    final static String SEPERATOR = ';';

    @InvocableMethod(label='Get Records with IN clause filter')
    public static ActionOutput[] filterRecords(ActionInput[] inputList){

        SObject[] recordList = Database.query(generateQuery(inputList));

        ActionOutput[] outputList = new ActionOutput[]{};        
        for(ActionInput input : inputList) {
            ActionOutput output = new ActionOutput();
            output.records = new SObject[]{};
            for(SObject record : recordList) {
                if(matchesFilterConditions(record, input)){
                    output.records.add(record);
                }
            }
            outputList.add(output);
        }
        return outputList;
    }

    private static Boolean matchesFilterConditions(SObject record, ActionInput input) {
        return input.filterValues.contains((String)record.get(input.filterField))
            ? String.isBlank(input.additionalFilters) || matchesAdditionalFilterConditions(record, input.additionalFilters)
            : false;
    }

    private static Boolean matchesAdditionalFilterConditions(SObject record, String additionalFilters) {

        Boolean result = true;
        for(String filterCondition : additionalFilters.split(SEPERATOR)) {
            filterCondition = filterCondition.trim();
            String field = filterCondition.split('=')[0].trim();
            String value = filterCondition.split('=')[1].trim();

            if(value != (String)record.get(field)) {
                result = false;
                break;
            }
        }
        return result;
    }

    private static String generateQuery(ActionInput[] inputList) {
        QueryParts queryPartsObj = constructQueryParts(inputList);
        String query = 'SELECT ' + 
            inputList[0].fieldsToQuery + 
            (String.isBlank(queryPartsObj.additionalFieldsToQuery) ? '' : ',' + queryPartsObj.additionalFieldsToQuery) +
            ' FROM ' +  inputList[0].objectApiName + 
            ' WHERE ' + queryPartsObj.whereClause;
        System.debug('Query: '+ query);

        return query;
    }

    private static QueryParts constructQueryParts(ActionInput[] inputList) {

        String whereClause = '';

        Map<String,Set<String>> fieldToFilterValuesMap = new Map<String,Set<String>>();
        Set<String> filterValuesSet = new Set<String>();
        for(ActionInput input : inputList) {
            
            filterValuesSet.addAll(input.filterValues);

            if(String.isNotBlank(input.additionalFilters)) {
                for(String filterCondition : input.additionalFilters.split(SEPERATOR)) {
                    filterCondition = filterCondition.trim();
                    String field = filterCondition.split('=')[0].trim();
                    String value = filterCondition.split('=')[1].trim();

                    if(fieldToFilterValuesMap.containsKey(field)) {
                        fieldToFilterValuesMap.get(field).add(value);
                    } else {
                        fieldToFilterValuesMap.put(field, new Set<String>{value});
                    }
                }
            }
        }
        whereClause += inputList[0].filterField + 
            ' IN ' + 
            convertCollectionToINClauseString(filterValuesSet) +
            constructAdditionalFiltersString(fieldToFilterValuesMap);

        Set<String> additionalFieldsToQuery = new Set<String>(fieldToFilterValuesMap.keySet());
        additionalFieldsToQuery.add(inputList[0].filterField);
        additionalFieldsToQuery.removeAll(inputList[0].fieldsToQuery.split(','));
        return new QueryParts(
            whereClause, 
            String.join(
                new List<String>(additionalFieldsToQuery), 
                ','
            )
        );
    }

    private static String constructAdditionalFiltersString(Map<String,Set<String>> fieldToFilterValuesMap) {
        String filtersString = ' AND ';
        for(String field : fieldToFilterValuesMap.keySet()) {
            String[] valuesCollection = new List<String>(fieldToFilterValuesMap.get(field));
            if(valuesCollection.size() == 1) {
                filtersString += field + ' = ' + '\'' + valuesCollection[0] + '\'';
            } else {
                filtersString += field + ' IN ' + convertCollectionToINClauseString(valuesCollection);
            }
            filtersString += ' AND ';
        }
        return filtersString.removeEnd(' AND ');
    }

    private static String convertCollectionToINClauseString(Set<String> valuesCollection) {
        return convertCollectionToINClauseString(new List<String>(valuesCollection));
    }

    private static String convertCollectionToINClauseString(String[] valuesCollection) {
        Integer valueListSize = valuesCollection.size();
        String filterValuesString = '(';
        for(Integer i = 0 ; i < valueListSize; i++) {
            
            filterValuesString += '\'' + valuesCollection[i] + '\'';
            
            if(i != (valueListSize - 1)) {
                filterValuesString += ',';
            }
        }
        filterValuesString += ')';
        return filterValuesString;
    }

    public class QueryParts {
        public String whereClause;
        public String additionalFieldsToQuery;

        public QueryParts(String whereClause, String additionalFieldsToQuery) {
            this.whereClause = whereClause;
            this.additionalFieldsToQuery = additionalFieldsToQuery;
        }
    }

    /* Input parameters for the Apex action */
    public class ActionInput{
        @InvocableVariable(label='Object API Name' required = true )
        public String objectApiName;
        
        @InvocableVariable(label='Fields to query(Comma seperated)' required = true)
        public String fieldsToQuery;
            
        @InvocableVariable(label='Filter Field(API Name)' required = true)
        public String filterField;
        
        @InvocableVariable(label='Filter Values Text collection' required = true)
        public String[] filterValues;

        @InvocableVariable(label='Additional AND Filters (; Separated)')
        public String additionalFilters;
    }

    /* Output parameters of the Apex action */
    public class ActionOutput{
        @InvocableVariable(label='Record Collection')
        public sObject[] records;
    }
}