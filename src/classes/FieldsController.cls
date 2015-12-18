public class FieldsController{
    /*public string selectedUser {get; set;}
    public PageReference test(){
        return null;
    }
    public List<SelectOption> UserList {
        get{
            List<SelectOption> UserList = new List<SelectOption>();
            UserList.add(new SelectOption('', '---Select a user---'));
            List<User> users = [SELECT Name FROM User];
            for (User u:users){
                UserList.add(new SelectOption(u.Name, u.Name));
            }
            UserList.add(new SelectOption('All Users', 'All Users'));
            return UserList;
        }
        set;
    }*/
    public List<PermissionSet> PSs 
    {
        get
        {
            List<PermissionSet> PSs = new List<PermissionSet>();
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet order by CreatedDate ASC LIMIT 1][0].CreatedDate;
            PSs = [SELECT Id,Name,CreatedById,CreatedDate FROM PermissionSet WHERE CreatedDate>:BeginningDate order by Id Asc];
            return PSs;
        }
        set;
    }
    

    //public List<FieldDefinition> flds {get;set;}
    public Map<String, Map<PermissionSet, Boolean>> MapofFieldPermissionsRead
    {
        get
        {
            Map<String, Map<PermissionSet, Boolean>> MapofFieldPermissionsRead = new Map<String, Map<PermissionSet, Boolean>>();
            List<Schema.SObjectType> options=new List<Schema.SObjectType>();
            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
            {
                if(objTyp.getDescribe().isCustom()){
                    options.add(objTyp);
                }
            }             
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet order by CreatedDate ASC LIMIT 1][0].CreatedDate;
            List<PermissionSet> Perms = [SELECT Id,Name,CreatedById,CreatedDate FROM PermissionSet WHERE CreatedDate>:BeginningDate order by ID ASC];                   
            for(Schema.SObjectType ob:options)
            {
                String nameofob = ob.getdescribe().getName();
                Map<String,Schema.SObjectField> mfields = ob.getDescribe().fields.getMap();
                List<Schema.SObjectField> objectFields = mfields.values();
                for(Schema.SObjectField o:objectFields)
                {
                    String fieldString = String.valueOf(o);
                    if(mfields.get(fieldString).getDescribe().iscustom()) {
                        if(mfields.get(fieldString).getDescribe().isUpdateable()) {  
                            /*List<User> chosenusers = [SELECT Id FROM User WHERE Name=:currentUser];
                            List<String> fieldNamesbyUser = new List<String>();
                            if(chosenusers.isEmpty()){
                                List<FieldDefinition> flds = [SELECT Id,Label,LastModifiedById,QualifiedApiName FROM FieldDefinition WHERE EntityDefinition.QualifiedApiName ='ZZZ__c'];
                                System.debug('*******The field definition list is: '+flds);
                                for (FieldDefinition f:flds){
                                    fieldNamesbyUser.add(f.Label);
                                }
                            }
                            else{
                                User u = chosenusers[0];
                                List<FieldDefinition> flds = [SELECT Id,Label,LastModifiedById,QualifiedApiName FROM FieldDefinition WHERE EntityDefinition.QualifiedApiName =:nameofob AND LastModifiedById =:u.Id AND Label =:fieldString];
                                for (FieldDefinition f:flds){
                                    fieldNamesbyUser.add(f.Label);
                                }
                            }*/
                    		Map<PermissionSet, Boolean> InMap = new Map<PermissionSet, Boolean>();
                    		List<FieldPermissions> tempPSs = new List<FieldPermissions>();
                   			String actualName = nameofob+'.'+fieldString;
                    		tempPSs = [SELECT ParentId FROM FieldPermissions WHERE Field=:actualname AND PermissionsRead=true];
                            Set<Id> tempSet = new Set<Id>();
                    		for(FieldPermissions s: tempPSs)
                    		{	
                        		tempSet.add(s.ParentId);
                    		}
                    		for (PermissionSet psss:Perms)
                    		{
                        		boolean response = (tempSet.contains(psss.Id));
                        		InMap.put(psss, response);
                    		}
                    		MapOfFieldPermissionsRead.put(actualName, InMap);
                		}
           			}
                }
            }
    	return MapofFieldPermissionsRead;
    }
         set;
    }
    public Map<String, Map<PermissionSet, Boolean>> MapofFieldPermissionsEdit
    {
        get
        {
            //ID CurrentUserID = UserInfo.getUserId();
            Map<String, Map<PermissionSet, Boolean>> MapofFieldPermissionsEdit = new Map<String, Map<PermissionSet, Boolean>>();
            List<Schema.SObjectType> options=new List<Schema.SObjectType>();
            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
            {
                if(objTyp.getDescribe().isCustom()){
                    options.add(objTyp);
                }
            }             
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet order by CreatedDate ASC LIMIT 1][0].CreatedDate;
            List<PermissionSet> Perms = [SELECT Id,Name,CreatedById,CreatedDate FROM PermissionSet WHERE CreatedDate>:BeginningDate order by ID ASC];                   
            for(Schema.SObjectType ob:options)
            {
                String nameofob = ob.getdescribe().getName();
                Map<String,Schema.SObjectField> mfields = ob.getDescribe().fields.getMap();
                List<Schema.SObjectField> objectFields = mfields.values();
                for(Schema.SObjectField o:objectFields)
                {
                    String fieldString = String.valueOf(o);
                    if(mfields.get(fieldString).getDescribe().iscustom()) {
                        if(mfields.get(fieldString).getDescribe().isUpdateable()) {
                    		Map<PermissionSet, Boolean> InMap = new Map<PermissionSet, Boolean>();
                    		List<FieldPermissions> tempPSs = new List<FieldPermissions>();
                   			String actualName = nameofob+'.'+fieldString;
                    		tempPSs = [SELECT ParentId FROM FieldPermissions WHERE Field=:actualname AND PermissionsRead=true AND PermissionsEdit=true];
                            Set<Id> tempSet = new Set<Id>();
                    		for(FieldPermissions s: tempPSs)
                    		{	
                        		tempSet.add(s.ParentId);
                    		}
                    		for (PermissionSet psss:Perms)
                    		{
                        		boolean response = (tempSet.contains(psss.Id));
                        		InMap.put(psss, response);
                    		}
                    		MapOfFieldPermissionsEdit.put(actualName, InMap);
                		}
           			}
                }
            }
    	return MapofFieldPermissionsEdit;
    }
         set;
    }
    
     @RemoteAction
    public static void dostuffRead(String selectedPSetName, String selectedFieldName){
        List<PermissionSet> currentPermSet = new List<PermissionSet>();
        currentPermSet = [SELECT Id, Name FROM PermissionSet WHERE Name =: selectedPSetName LIMIT 1];
        PermissionSet ppp = new PermissionSet();
        ppp= currentPermSet[0];

		List<Schema.SObjectType> options=new List<Schema.SObjectType>();
            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
            {
                if(objTyp.getDescribe().isCustom()){
                    options.add(objTyp);
                }
            }               
            //ID CurrentUserID = UserInfo.getUserId();
            List<FieldPermissions> FPerms = new List<FieldPermissions>();
            FPerms = [SELECT Field,Id,ParentId,PermissionsEdit,PermissionsRead,SobjectType FROM FieldPermissions order by Field Desc];
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet order by CreatedDate ASC LIMIT 1][0].CreatedDate;
            List<PermissionSet> Perms = [SELECT Id,Name,CreatedById,CreatedDate FROM PermissionSet WHERE CreatedDate>:BeginningDate order by ID ASC];                   
            for(Schema.SObjectType ob:options)
            {
                String nameofob = ob.getdescribe().getName();
                Map<String,Schema.SObjectField> mfields = ob.getDescribe().fields.getMap();
                List<Schema.SObjectField> objectFields = new List<Schema.SObjectField>();
                objectFields = mfields.values();
                for(Schema.SObjectField o:objectFields)
                		{
                            String returnValue = String.valueOf(o);
                    		String actualName = nameofob+'.'+returnvalue;
                            if(mfields.get(returnValue).getDescribe().iscustom()) {
                                if(mfields.get(returnValue).getDescribe().isUpdateable()) {
                    			Set<String> tempName = new Set<String>();
                    			tempName.add(actualName);
                    			if(tempName.contains(selectedFieldName)){
                        			List<FieldPermissions> existingFP = [SELECT Id,ParentId FROM FieldPermissions WHERE ParentId=:ppp.id AND Field=:selectedFieldName];
        							if (existingFP.isEmpty()){
                    					FieldPermissions newFP = new FieldPermissions();					
										newFP.ParentId = ppp.id;
                    					newFP.Field = selectedFieldName;
                        				newFP.SObjectType = nameofob;
                        				newFP.PermissionsRead = true;
                        				insert newFP;}
                        			else{
                        				for(FieldPermissions f1:existingFP){
                            				delete f1;
                            		}}
                    }
                    else{
                        System.debug('*the actual name does not equal the selected field name');
                    }}}
                        }}
    }
                                       
    
    @RemoteAction
    public static void dostuffEdit(String selectedPSetName, String selectedFieldName){
        List<PermissionSet> currentPermSet = new List<PermissionSet>();
        currentPermSet = [SELECT Id, Name FROM PermissionSet WHERE Name =: selectedPSetName LIMIT 1];
        PermissionSet ppp = new PermissionSet();
        ppp= currentPermSet[0];

		List<Schema.SObjectType> options=new List<Schema.SObjectType>();
            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
            {
                if(objTyp.getDescribe().isCustom()){
                    options.add(objTyp);
                    }
                
            }               
            //ID CurrentUserID = UserInfo.getUserId();
            List<FieldPermissions> FPerms = new List<FieldPermissions>();
            FPerms = [SELECT Field,Id,ParentId,PermissionsEdit,PermissionsRead,SobjectType FROM FieldPermissions order by Field Desc];
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet order by CreatedDate ASC LIMIT 1][0].CreatedDate;
            List<PermissionSet> Perms = [SELECT Id,Name,CreatedById,CreatedDate FROM PermissionSet WHERE CreatedDate>:BeginningDate order by ID ASC];                   
            for(Schema.SObjectType ob:options)
            {
                String nameofob = ob.getdescribe().getName();
                Map<String,Schema.SObjectField> mfields = ob.getDescribe().fields.getMap();
                List<Schema.SObjectField> objectFields = new List<Schema.SObjectField>();
                objectFields = mfields.values();
                for(Schema.SObjectField o:objectFields)
                		{
                            String returnValue = String.valueOf(o);
                    		String actualName = nameofob+'.'+returnvalue;
                            if(mfields.get(returnValue).getDescribe().iscustom()){
                                if(mfields.get(returnValue).getDescribe().isUpdateable()) {
                    			Set<String> tempName = new Set<String>();
                    			tempName.add(actualName);
                    			if(tempName.contains(selectedFieldName)){
                        			System.debug('*****This is the field we want to change: '+selectedFieldName);
                                    List<FieldPermissions> existingFP = [SELECT Id,ParentId,PermissionsEdit,PermissionsRead FROM FieldPermissions WHERE ParentId=:ppp.id AND Field=:selectedFieldName];
                                    System.debug('***The existing fieldspmermissions is: '+existingFP);
                                    if(existingFP.isEmpty()){
                                        FieldPermissions newfp = new FieldPermissions();
                                            newfp.ParentId = ppp.id;
                                            newfp.SobjectType = nameofob;
                                            newfp.Field = selectedFieldName;
                                            newfp.PermissionsRead = true;
                                            newfp.PermissionsEdit=true;
                                        	System.debug('****There was nothing there so I am inserting: '+newfp);
                                        	insert newfp;
                                    }
                                    else{
                                        for (FieldPermissions fp: existingFP){
                                            if(fp.PermissionsEdit==false){
                                            	fp.PermissionsEdit = true;
                                            	System.debug('***There used to be read only, adding edit: '+fp);
                                            	update fp;
                                        	}
                                        	else if(fp.PermissionsEdit == true){
                                            	fp.PermissionsEdit = false;
                                            	System.debug('***This exists and I dont want it anymore: '+fp);
                                            	update fp;
                                        	}
                                    	}
                                	}
                                }
                      			}
                            }
                        }
           		}
    }
}