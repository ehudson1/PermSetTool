public class ObjectsController {
    public PageReference test(){
        return null;
    }
    public List<PermissionSet> PSs
    {
        get
        {
            List<PermissionSet> PSs = new List<PermissionSet>();
            ID CurrentUserID = UserInfo.getUserId();
            List<PermissionSet> OldestPS = [SELECT Id,Name,CreatedDate FROM PermissionSet WHERE CreatedById=:CurrentUserId order by CreatedDate ASC LIMIT 1];
            DateTime BeginningDate = OldestPS[0].CreatedDate;
            PSs = [SELECT Id,Name,CreatedById,CreatedDate FROM PermissionSet WHERE CreatedDate>:BeginningDate order by CreatedDate DESC];
            return PSs;
        }
        set;
    }
    public String val{get;set;}
    public String objectName{get;set;}
    public SobjectType curobj{get; set;}
    Schema.DescribeSObjectResult objDescribe;
    public List<Sobject> selectedObj{get;set;}
    public String selectedObject{get;set;}
    public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    public List<SelectOption> listofpermsets 
    {
        get{
            List<SelectOption> listofpermsets = new List<SelectOption>();
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet order by CreatedDate ASC LIMIT 1][0].CreatedDate;
            List<PermissionSet> PS = [SELECT Id,Name,CreatedDate FROM PermissionSet WHERE CreatedDate>:BeginningDate order by CreatedDate DESC];
            listofpermsets.add(new SelectOption('---', '---'));
            for (PermissionSet s:PS){
                listofpermsets.add(new SelectOption(s.id, s.Name));
            }
            return listofpermsets;
        }
        set;
    }
    //public List<String> chosenPermSetNames {get;set;}
    public List<String> ListofObjects{
        get{
            List<String> ListofObjects = new List<String>();
            Map<String, Boolean> MapofReadPermissions = new Map<String, Boolean>();
            List<Schema.SObjectType> options=new List<Schema.SObjectType>();
            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
            {
                if(objTyp.getDescribe().isCustom()){
                    options.add(objTyp);
                }
            }
            for(Schema.SObjectType ob:options)
            {
                String nameofob = ob.getdescribe().getName();
                ListOfObjects.add(nameofob);
        }
            return ListOfObjects;
    }
        set;
    }
    
    public String chosenPermSetNames {get;set;}
    
    public Map<String, Boolean> MapofReadPermissions
    {
        get{
            System.debug('****In map of field permissions- chosen permission set is: '+chosenPermSetNames);
            Map<String, Boolean> MapofReadPermissions = new Map<String, Boolean>();
            List<Schema.SObjectType> options=new List<Schema.SObjectType>();
            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
            {
                if(objTyp.getDescribe().isCustom()){
                    options.add(objTyp);
                }
            }
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet order by CreatedDate ASC LIMIT 1][0].CreatedDate;
            //for (String pe:chosenPermSetNames){
            	//PermissionSet psets = [SELECT Id, Name FROM PermissionSet WHERE Name=:chosenPermSetNames][0];
            //}
            List<PermissionSet> psets = [SELECT Id,Name,CreatedDate FROM PermissionSet WHERE Id=:chosenPermSetNames order by CreatedDate DESC];
            System.debug('***The list of permission sets that match the selected is: '+psets);
            for(Schema.SObjectType ob:options)
            {
                String nameofob = ob.getdescribe().getName();
                Map<PermissionSet, Boolean> InMap = new Map<PermissionSet, Boolean>();
                List<ObjectPermissions> tempPSs = [SELECT Id,ParentId,PermissionsCreate,PermissionsDelete,PermissionsEdit,PermissionsModifyAllRecords,PermissionsRead,PermissionsViewAllRecords,SobjectType FROM ObjectPermissions WHERE SObjectType=:nameofob AND PermissionsRead=true];
                Set<Id> tempSet = new Set<Id>();
                boolean response = false;
                for(ObjectPermissions s: tempPSs)
                {
                     tempSet.add(s.ParentId);
                }
                System.debug('***The set of object permissions for read is: '+tempSet);
                for (PermissionSet p:psets)
                {
                    response = (tempSet.contains(p.id));
                    System.debug('***The response of this one: '+response);
                 }
                MapofReadPermissions.put(nameofob, response);
             }
            return MapofReadPermissions;
        }
        set;
    }
    public Map<String, Boolean> MapofEditPermissions
    {
        get{
            Map<String, Boolean> MapofEditPermissions = new Map<String, Boolean>();
            List<Schema.SObjectType> options=new List<Schema.SObjectType>();
            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
            {
                if(objTyp.getDescribe().isCustom()){
                    options.add(objTyp);
                }
            }
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet order by CreatedDate ASC LIMIT 1][0].CreatedDate;
            List<PermissionSet> psets = [SELECT Id,Name,CreatedDate FROM PermissionSet WHERE Id=:chosenPermSetNames order by CreatedDate DESC];
            for(Schema.SObjectType ob:options)
            {
                String nameofob = ob.getdescribe().getName();
                Map<PermissionSet, Boolean> InMap = new Map<PermissionSet, Boolean>();
                List<ObjectPermissions> tempPSs = [SELECT Id,ParentId,PermissionsCreate,PermissionsDelete,PermissionsEdit,PermissionsModifyAllRecords,PermissionsRead,PermissionsViewAllRecords,SobjectType FROM ObjectPermissions WHERE SObjectType=:nameofob AND PermissionsRead=true AND PermissionsEdit=true];
                Set<Id> tempSet = new Set<Id>();
                boolean response = false;
                for(ObjectPermissions s: tempPSs)
                {
                     tempSet.add(s.ParentId);
                }
                for (PermissionSet p:psets)
                {
                    response = (tempSet.contains(p.id));
                 }
                MapofEditPermissions.put(nameofob, response);
             }
            return MapofEditPermissions;
        }
        set;
    }
    public Map<String, Boolean> MapofCreatePermissions
    {
        get{
            Map<String, Boolean> MapofCreatePermissions = new Map<String, Boolean>();
            List<Schema.SObjectType> options=new List<Schema.SObjectType>();
            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
            {
                if(objTyp.getDescribe().isCustom()){
                    options.add(objTyp);
                }
            }
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet order by CreatedDate ASC LIMIT 1][0].CreatedDate;
            List<PermissionSet> psets = [SELECT Id,Name,CreatedDate FROM PermissionSet WHERE Id=:chosenPermSetNames order by CreatedDate DESC];
            for(Schema.SObjectType ob:options)
            {
                String nameofob = ob.getdescribe().getName();
                Map<PermissionSet, Boolean> InMap = new Map<PermissionSet, Boolean>();
                List<ObjectPermissions> tempPSs = [SELECT Id,ParentId,PermissionsCreate,PermissionsDelete,PermissionsEdit,PermissionsModifyAllRecords,PermissionsRead,PermissionsViewAllRecords,SobjectType FROM ObjectPermissions WHERE SObjectType=:nameofob AND PermissionsRead=true AND PermissionsCreate=true];
                Set<Id> tempSet = new Set<Id>();
                boolean response = false;
                for(ObjectPermissions s: tempPSs)
                {
                     tempSet.add(s.ParentId);
                }
                for (PermissionSet p:psets)
                {
                    response = (tempSet.contains(p.id));
                 }
                MapofCreatePermissions.put(nameofob, response);
             }
            return MapofCreatePermissions;
        }
        set;
    }
    public Map<String, Boolean> MapofDeletePermissions
    {
        get{
            Map<String, Boolean> MapofDeletePermissions = new Map<String, Boolean>();
            List<Schema.SObjectType> options=new List<Schema.SObjectType>();
            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
            {
                if(objTyp.getDescribe().isCustom()){
                    options.add(objTyp);
                }
            }
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet order by CreatedDate ASC LIMIT 1][0].CreatedDate;
            List<PermissionSet> psets = [SELECT Id,Name,CreatedDate FROM PermissionSet WHERE Id=:chosenPermSetNames order by CreatedDate DESC];
            for(Schema.SObjectType ob:options)
            {
                String nameofob = ob.getdescribe().getName();
                Map<PermissionSet, Boolean> InMap = new Map<PermissionSet, Boolean>();
                List<ObjectPermissions> tempPSs = [SELECT Id,ParentId,PermissionsCreate,PermissionsDelete,PermissionsEdit,PermissionsModifyAllRecords,PermissionsRead,PermissionsViewAllRecords,SobjectType FROM ObjectPermissions WHERE SObjectType=:nameofob AND PermissionsRead=true AND PermissionsDelete=true];
                Set<Id> tempSet = new Set<Id>();
                boolean response = false;
                for(ObjectPermissions s: tempPSs)
                {
                     tempSet.add(s.ParentId);
                }
                for (PermissionSet p:psets)
                {
                    response = (tempSet.contains(p.id));
                 }
                MapofDeletePermissions.put(nameofob, response);
             }
            return MapofDeletePermissions;
        }
        set;
    }
    
    
    
    
    
    
    //***READ PERMISSION***
    public Map<String, Map<PermissionSet, Boolean>> MapofObjectPermissionsRead
    {
        get
        {
            Map<String, Map<PermissionSet, Boolean>> MapofObjectPermissionsRead = new Map<String, Map<PermissionSet, Boolean>>();
            List<Schema.SObjectType> options=new List<Schema.SObjectType>();
            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
            {
                if(objTyp.getDescribe().isCustom()){
                    options.add(objTyp);
                }
            }
            ID CurrentUserID = UserInfo.getUserId();
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet WHERE CreatedById=:CurrentUserId order by CreatedDate ASC LIMIT 1][0].CreatedDate;
            List<PermissionSet> Perms = [SELECT Id,Name,CreatedById,CreatedDate FROM PermissionSet WHERE CreatedById=:CurrentUserID AND CreatedDate>:BeginningDate order by ID ASC];
            for(Schema.SObjectType ob:options)
            {
                String nameofob = ob.getdescribe().getName();
                Map<PermissionSet, Boolean> InMap = new Map<PermissionSet, Boolean>();
                List<ObjectPermissions> tempPSs = new List<ObjectPermissions>();
                tempPSs = [SELECT Id,ParentId,PermissionsCreate,PermissionsDelete,PermissionsEdit,PermissionsModifyAllRecords,PermissionsRead,PermissionsViewAllRecords,SobjectType FROM ObjectPermissions WHERE SObjectType=:nameofob AND PermissionsRead=true];
                Set<Id> tempSet = new Set<Id>();
                for(ObjectPermissions s: tempPSs)
                {
                     tempSet.add(s.ParentId);
                }
                for (PermissionSet psss:Perms)
                {
                     boolean response = (tempSet.contains(psss.Id));
                     InMap.put(psss, response);
                 }
                 MapOfObjectPermissionsRead.put(nameofob, InMap);
             }
            return MapofObjectPermissionsRead;
    	}
        set;
    }

    //***EDIT***
    public Map<String, Map<PermissionSet, Boolean>> MapofObjectPermissionsEdit
    {
        get
        {
            Map<String, Map<PermissionSet, Boolean>> MapofObjectPermissionsEdit = new Map<String, Map<PermissionSet, Boolean>>();
            List<Schema.SObjectType> options=new List<Schema.SObjectType>();
            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
            {
                if(objTyp.getDescribe().isCustom()){
                    options.add(objTyp);
                }
            }
            ID CurrentUserID = UserInfo.getUserId();
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet WHERE CreatedById=:CurrentUserId order by CreatedDate ASC LIMIT 1][0].CreatedDate;
            List<PermissionSet> Perms = [SELECT Id,Name,CreatedById,CreatedDate FROM PermissionSet WHERE CreatedById=:CurrentUserID AND CreatedDate>:BeginningDate order by ID ASC];
            for(Schema.SObjectType ob:options)
            {
                String nameofob = ob.getdescribe().getName();
                Map<PermissionSet, Boolean> InMap = new Map<PermissionSet, Boolean>();
                List<ObjectPermissions> tempPSs = new List<ObjectPermissions>();
                tempPSs = [SELECT Id,ParentId,PermissionsCreate,PermissionsDelete,PermissionsEdit,PermissionsModifyAllRecords,PermissionsRead,PermissionsViewAllRecords,SobjectType FROM ObjectPermissions WHERE SObjectType=:nameofob AND PermissionsRead=true AND PermissionsEdit = true];
                Set<Id> tempSet = new Set<Id>();
                for(ObjectPermissions s: tempPSs)
                {
                     tempSet.add(s.ParentId);
                }
                for (PermissionSet psss:Perms)
                {
                    boolean response = (tempSet.contains(psss.Id));
                 	InMap.put(psss, response);
                }
               MapOfObjectPermissionsEdit.put(nameofob, InMap);
            }
        return MapofObjectPermissionsEdit;
    	}
        set;
    }

    //***CREATE***
    public Map<String, Map<PermissionSet, Boolean>> MapofObjectPermissionsCreate
    {
        get
        {
            Map<String, Map<PermissionSet, Boolean>> MapofObjectPermissionsCreate = new Map<String, Map<PermissionSet, Boolean>>();
            List<Schema.SObjectType> options=new List<Schema.SObjectType>();
            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
            {
                if(objTyp.getDescribe().isCustom()){
                    options.add(objTyp);
                }
            }
            ID CurrentUserID = UserInfo.getUserId();
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet WHERE CreatedById=:CurrentUserId order by CreatedDate ASC LIMIT 1][0].CreatedDate;
            List<PermissionSet> Perms = [SELECT Id,Name,CreatedById,CreatedDate FROM PermissionSet WHERE CreatedById=:CurrentUserID AND CreatedDate>:BeginningDate order by ID ASC];
            for(Schema.SObjectType ob:options)
            {
                String nameofob = ob.getdescribe().getName();
                Map<PermissionSet, Boolean> InMap = new Map<PermissionSet, Boolean>();
                List<ObjectPermissions> tempPSs = new List<ObjectPermissions>();
                tempPSs = [SELECT Id,ParentId,PermissionsCreate,PermissionsDelete,PermissionsEdit,PermissionsModifyAllRecords,PermissionsRead,PermissionsViewAllRecords,SobjectType FROM ObjectPermissions WHERE SObjectType=:nameofob AND PermissionsRead=true AND PermissionsCreate = true];
                Set<Id> tempSet = new Set<Id>();
                for(ObjectPermissions s: tempPSs)
                {
                     tempSet.add(s.ParentId);
                }
                for (PermissionSet psss:Perms)
                {
                    boolean response = (tempSet.contains(psss.Id));
                 	InMap.put(psss, response);
                }
            MapOfObjectPermissionsCreate.put(nameofob, InMap);
            }
        return MapofObjectPermissionsCreate;
    	}
        set;
    }

    //***DELETE***
    public Map<String, Map<PermissionSet, Boolean>> MapofObjectPermissionsDelete
    {
        get
        {
            Map<String, Map<PermissionSet, Boolean>> MapofObjectPermissionsDelete = new Map<String, Map<PermissionSet, Boolean>>();
            List<Schema.SObjectType> options=new List<Schema.SObjectType>();
            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
            {
                if(objTyp.getDescribe().isCustom()){
                    options.add(objTyp);
                }
            }
            ID CurrentUserID = UserInfo.getUserId();
            Map<String, Schema.SObjectField> map2 = new Map<String, Schema.SObjectField>();
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet WHERE CreatedById=:CurrentUserId order by CreatedDate ASC LIMIT 1][0].CreatedDate;
            List<PermissionSet> Perms = [SELECT Id,Name,CreatedById,CreatedDate FROM PermissionSet WHERE CreatedById=:CurrentUserID AND CreatedDate>:BeginningDate order by ID ASC];
            for(Schema.SObjectType ob:options)
            {
                String nameofob = ob.getdescribe().getName();
                Map<PermissionSet, Boolean> InMap = new Map<PermissionSet, Boolean>();
                List<ObjectPermissions> tempPSs = new List<ObjectPermissions>();
                tempPSs = [SELECT Id,ParentId,PermissionsCreate,PermissionsDelete,PermissionsEdit,PermissionsModifyAllRecords,PermissionsRead,PermissionsViewAllRecords,SobjectType FROM ObjectPermissions WHERE SObjectType=:nameofob AND PermissionsRead=true AND PermissionsDelete = true];
                Set<Id> tempSet = new Set<Id>();
                for(ObjectPermissions s: tempPSs)
                {
                     tempSet.add(s.ParentId);
                }
                for (PermissionSet psss:Perms)
                {
                    boolean response = (tempSet.contains(psss.Id));
                	InMap.put(psss, response);
                }
            MapOfObjectPermissionsDelete.put(nameofob, InMap);
            }
       return MapofObjectPermissionsDelete;
                }
    	set;
    }

     @RemoteAction
    public static String ChangeReadPerm(String selectedPSetName, String selectedObjectName){
        try{
        String response1 = '';
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
            ID CurrentUserID = UserInfo.getUserId();
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet WHERE CreatedById=:CurrentUserId order by CreatedDate ASC LIMIT 1][0].CreatedDate;
            for(Schema.SObjectType ob:options)
            {
                String nameofob = ob.getdescribe().getName();
				Set<String> tempName = new Set<String>();
                tempName.add(nameofob);
                if(tempName.contains(selectedObjectName)){
                    List<ObjectPermissions> existingOP = new List<ObjectPermissions>();
                	existingOP =[SELECT Id,ParentId,PermissionsCreate,PermissionsDelete,PermissionsEdit,PermissionsModifyAllRecords,PermissionsRead,PermissionsViewAllRecords,SobjectType FROM ObjectPermissions WHERE SObjectType=:nameofob AND ParentId=:ppp.id];
                    if (existingOP.isEmpty()){
                        ObjectPermissions newOP = new ObjectPermissions();
                        newOP.ParentId = ppp.id;
                        newOP.SobjectType = nameofob;
                        newOP.PermissionsRead = true;
                        insert newOP;
                        response1 = 'Success!  The ability for the Object '+selectedObjectName+' to be read has been added to the Permission Set '+ppp.Name;
                    }
                    else{
                        System.debug('**The existing PS looks like this: '+existingOP);
                        for (ObjectPermissions opp: existingOP){
                            delete opp;
                        }
                        response1 = 'Success!  The ability for the Object '+selectedObjectName+' to be read has been removed from the Permission Set '+ppp.Name;
            		}
                }
            }
            return response1;
        }
        catch(DmlException e){
           String response2 = 'The save failed because you are trying to assign or remove a permission from a child object that requires a different permission on the parent object.  Please change the parent object permission first, then try again.';
           return response2;
        }
        catch(Exception e){
           String response3 = 'The following error occurred: '+e;
           return response3;
        }
    }          

    @RemoteAction
    public static String ChangeEditPerm(String selectedPSetName, String selectedObjectName){
    try{
        String response1 = '';
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
            ID CurrentUserID = UserInfo.getUserId();
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet WHERE CreatedById=:CurrentUserId order by CreatedDate ASC LIMIT 1][0].CreatedDate;
            for(Schema.SObjectType ob:options)
            {
                String nameofob = ob.getdescribe().getName();
				Set<String> tempName = new Set<String>();
                tempName.add(nameofob);
                if(tempName.contains(selectedObjectName)){
                    List<ObjectPermissions> existingOP = new List<ObjectPermissions>();
                	existingOP =[SELECT Id,ParentId,PermissionsCreate,PermissionsDelete,PermissionsEdit,PermissionsModifyAllRecords,PermissionsRead,PermissionsViewAllRecords,SobjectType FROM ObjectPermissions WHERE SObjectType=:nameofob AND ParentId=:ppp.id];
                    if (existingOP.isEmpty()){
                        ObjectPermissions newOP = new ObjectPermissions();
                        newOP.ParentId = ppp.id;
                        newOP.SobjectType = nameofob;
                        newOP.PermissionsRead = true;
                        newOP.PermissionsEdit = true;
                        insert newOP;
                        response1= 'The ability for the Object '+selectedObjectName+' to be edited and read has been added to the Permission Set '+ppp.Name;
                    }
                    else{
                        for (ObjectPermissions op: existingOP){
                            if(op.PermissionsEdit==false){
                              op.PermissionsEdit = true;
                              update op;
                              response1= 'The ability for the Object '+selectedObjectName+' to be edited has been added to the Permission Set '+ppp.Name;
                            }
                        	else if(op.PermissionsEdit == true){
                              op.PermissionsEdit = false;
                              update op;    
                             response1 = 'The ability for the Object '+selectedObjectName+' to be edited has been removed from the Permission Set '+ppp.Name;
                			}
                        }
            		}
                }
            }
        String s= 'Success! ';
        return s+response1;
    }
    catch(DmlException e){
    	String response2 = 'The save failed because you are trying to assign or remove a permission from a child object that requires a different permission on the parent object.  Please change the parent object permission first, then try again.';
        return response2;
    }
    catch(Exception e){
        String response3 = 'The following error occurred: '+e;
        return response3;
    }
 }

    @RemoteAction
    public static String ChangeCreatePerm(String selectedPSetName, String selectedObjectName){
    try{
        String response1 = '';
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
            ID CurrentUserID = UserInfo.getUserId();
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet WHERE CreatedById=:CurrentUserId order by CreatedDate ASC LIMIT 1][0].CreatedDate;
        	for(Schema.SObjectType ob:options)
            {
                String nameofob = ob.getdescribe().getName();
				Set<String> tempName = new Set<String>();
                tempName.add(nameofob);
                if(tempName.contains(selectedObjectName)){
                    List<ObjectPermissions> existingOP = new List<ObjectPermissions>();
                	existingOP =[SELECT Id,ParentId,PermissionsCreate,PermissionsDelete,PermissionsEdit,PermissionsModifyAllRecords,PermissionsRead,PermissionsViewAllRecords,SobjectType FROM ObjectPermissions WHERE SObjectType=:nameofob AND ParentId=:ppp.id];
                    if (existingOP.isEmpty()){
                        ObjectPermissions newOP = new ObjectPermissions();
                        newOP.ParentId = ppp.id;
                        newOP.SobjectType = nameofob;
                        newOP.PermissionsRead = true;
                        newOP.PermissionsCreate = true;
                        insert newOP;
                        response1= 'The ability for the Object '+selectedObjectName+' to be created and read has been added to the Permission Set '+ppp.Name;
                    }
                    else{
                        for (ObjectPermissions op: existingOP){
                              if(op.PermissionsCreate==false){
                              op.PermissionsCreate = true;
                              update op;
                              response1 ='The ability for the Object '+selectedObjectName+' to be created has been added to the Permission Set '+ppp.Name;
                              }
                        else if(op.PermissionsCreate == true){
                              op.PermissionsCreate = false;
                              update op;     
                             response1= 'The ability for the Object '+selectedObjectName+' to be created has been removed from the Permission Set '+ppp.Name;
                		}
                    }
            	}
            }
        }
        String s= 'Success! ';
        return s+response1;
    }
    catch(DmlException e){
        String response2 = 'The save failed because you are trying to assign or remove a permission from a child object that requires a different permission on the parent object.  Please change the parent object permission first, then try again.';
        return response2;
    }
    catch(Exception e){
        String response3 = 'The following error occurred: '+e;
        return response3;
    }
 }

    @RemoteAction
    public static String ChangeDeletePerm(String selectedPSetName, String selectedObjectName){
    try{
        String response1 = '';
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
            ID CurrentUserID = UserInfo.getUserId();
            DateTime BeginningDate = [SELECT Id,Name,CreatedDate FROM PermissionSet WHERE CreatedById=:CurrentUserId order by CreatedDate ASC LIMIT 1][0].CreatedDate;
            for(Schema.SObjectType ob:options)
            {
                String nameofob = ob.getdescribe().getName();
				Set<String> tempName = new Set<String>();
                tempName.add(nameofob);
                if(tempName.contains(selectedObjectName)){
                    List<ObjectPermissions> existingOP = new List<ObjectPermissions>();
                	existingOP =[SELECT Id,ParentId,PermissionsCreate,PermissionsDelete,PermissionsEdit,PermissionsModifyAllRecords,PermissionsRead,PermissionsViewAllRecords,SobjectType FROM ObjectPermissions WHERE SObjectType=:nameofob AND ParentId=:ppp.id];
                    if (existingOP.isEmpty()){
                        ObjectPermissions newOP = new ObjectPermissions();
                        newOP.ParentId = ppp.id;
                        newOP.SobjectType = nameofob;
                        newOP.PermissionsRead = true;
                        newOP.PermissionsEdit = true;
                        newOP.PermissionsDelete = true;
                        insert newOP;
                        response1= 'The ability for the Object '+selectedObjectName+' to be deleted, edited, and read has been added to the Permission Set '+ppp.Name;
                    }
                    else{
                        for (ObjectPermissions op: existingOP){
                              if(op.PermissionsDelete==false){
                              op.PermissionsEdit = true;
                              op.PermissionsDelete = true;
                              update op;
                              response1 ='The ability for the Object '+selectedObjectName+' to be deleted has been added to the Permission Set '+ppp.Name;
                              }
                        else if(op.PermissionsDelete == true){
                              op.PermissionsDelete = false;
                              update op;     
                             response1= 'The ability for the Object '+selectedObjectName+' to be deleted has been removed from the Permission Set '+ppp.Name;
                		}
                    }
            	}
            }
        }
        String s= 'Success! ';
        return s+response1;
    }
    catch(DmlException e){
        String response2 = 'The save failed because you are trying to assign or remove a permission from a child object that requires a different permission on the parent object.  Please change the parent object permission first, then try again.';
        return response2;
    }
    catch(Exception e){
        String response3 = 'The following error occurred: '+e;
        return response3;
    }
 }
}