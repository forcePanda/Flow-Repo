public class FlowINClauseActionClass {
    
    @InvocableMethod(label='Get records with IN clause filter')
    public static FlowOutputParameters[] filterRecords(FlowInputParameters[] inputList){
        
        String[] combinedFilterValuesCollection = new String[]{};

        for( FlowINClauseActionClass.FlowInputParameters input : inputList ){
            for(String s : input.filteringValuesCollection){
                if( !combinedFilterValuesCollection.contains(s) ){
                    combinedFilterValuesCollection.add(s);
                }
            }
        }

        /*Convert the filter value string list to a string of comma separated values*/
        
        string filterValuesList='(';
        for(integer i=0 ; i < combinedFilterValuesCollection.size();i++){
            string filterValue = combinedFilterValuesCollection[i];
            filterValuesList += '\''+filterValue+'\'';
            if(i != combinedFilterValuesCollection.size()-1)
                filterValuesList += ',';
        }
        filterValuesList += ')';

        string query = 'Select '+ inputList[0].fieldsToQuery + ' FROM ' +  inputList[0].objectApiName + ' WHERE '+inputList[0].filterField +' IN ' + filterValuesList;
        //System.debug('Query: '+ query);
        FlowINClauseActionClass.FlowOutputParameters[] outputList = new FlowINClauseActionClass.FlowOutputParameters[]{};

        try{
            SObject [] recordList = database.query(query);
            
            for(FlowInputParameters input : inputList){
                FlowINClauseActionClass.FlowOutputParameters output = new FlowINClauseActionClass.FlowOutputParameters();
                SObject[] filteredRecords = new SObject[]{};
                for(SObject s : recordList){
                    if(input.filteringValuesCollection.contains( (String)s.get(inputList[0].filterField) )){
                        filteredRecords.add(s);
                    }
                }
                output.records = filteredRecords;
                outputList.add( output );
            }
            return outputList;
        }catch(Exception e){
            //system.debug(e.getMessage());
            throw e;
        }

    }


    
    /* Input parameters for the Apex action */
    public class FlowInputParameters{
        @InvocableVariable(label='Api name of the Object' required = true )
        public string objectApiName;
        
        @InvocableVariable(label='Fields to query(Comma seperated)' required = true)
        public string fieldsToQuery;
            
        @InvocableVariable(label='Field Api name for IN Clause filter' required = true)
        public string filterField;
        
        @InvocableVariable(label='Text type collection of filter values' required = true)
        public string[] filteringValuesCollection;
        
    }
    
    /* Output parameters of the Apex action */
    public class FlowOutputParameters{
        
        @InvocableVariable(label='Record Collection')
        public sObject[] records;
    }

}