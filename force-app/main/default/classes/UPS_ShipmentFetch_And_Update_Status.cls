public class UPS_ShipmentFetch_And_Update_Status { 
    
    //Constructor to make first call out for shipments from schedule class
    public  UPS_ShipmentFetch_And_Update_Status(){
        list<shipment__c> FinalshipmentsToInsert=new list<Shipment__c>();//List used for insert shipments after fetch all data from repsonse
        list<shipment__c> FinalshipmentsToUpdate=new list<Shipment__c>();//List used for update shipments after fetch all data from repsonse
        list<shipment__c> FinalshipmentsToUpdateIntranisitGeneric=new list<Shipment__c>();
        list<shipment__c> FinalshipmentsToUpdateIntranisitOrigin=new list<Shipment__c>();
        list<shipment__c> FinalshipmentsToUpdateDelivery=new list<Shipment__c>();
        list<shipment__c> FinalshipmentsToUpdateException=new list<Shipment__c>();
        wrapperForBookmarkRetrun wp=new wrapperForBookmarkRetrun();
        wp=UpsFetch_and_shipment_creation(null);//First Call Out with out bookmark..returns with shipemts data where repsonse without having the bookamrk 
        if(wp!=null){
            map<string,list<object>> shipmentsMapBeforeBookmark=wp.ShipmetsMaptoReturnToConstrutor;            
            FinalshipmentsToInsert.addAll(getShipmetsFromMap(shipmentsMapBeforeBookmark,'Manifest'));//Adding shipments to list to insert by cheking the shipment type before bookmark
            FinalshipmentsToUpdateIntranisitGeneric.addAll(getShipmetsFromMap(shipmentsMapBeforeBookmark,'InTransitGeneric'));//Adding shipments to list to update by cheking the shipment type before bookmark
            FinalshipmentsToUpdateIntranisitOrigin.addAll(getShipmetsFromMap(shipmentsMapBeforeBookmark,'InTransitOrigin'));
            FinalshipmentsToUpdateDelivery.addAll(getShipmetsFromMap(shipmentsMapBeforeBookmark,'Delivery'));
            FinalshipmentsToUpdateException.addAll(getShipmetsFromMap(shipmentsMapBeforeBookmark,'Exception'));
            FinalshipmentsToUpdate.addAll(getShipmetsFromMap(shipmentsMapBeforeBookmark,'ManifestTrillumAndFleet'));
            while(wp.bookmark!=null){//While for check until bookmark not present in the response
                wp=UpsFetch_and_shipment_creation(wp.bookmark);//Same Call Out with bookmark...returns with shipemts data where repsonse having the bookamrk 
                map<string,list<object>> shipmentsMapAfterBookmark=wp.ShipmetsMaptoReturnToConstrutor;
                FinalshipmentsToInsert.addAll(getShipmetsFromMap(shipmentsMapAfterBookmark,'Manifest'));//Adding shipments to list to insert by cheking the shipment type after bookmark
                FinalshipmentsToUpdateIntranisitGeneric.addAll(getShipmetsFromMap(shipmentsMapAfterBookmark,'InTransitGeneric'));//Adding shipments to list to update by cheking the shipment type after bookmark
                FinalshipmentsToUpdateIntranisitOrigin.addAll(getShipmetsFromMap(shipmentsMapAfterBookmark,'InTransitOrigin'));
                FinalshipmentsToUpdateDelivery.addAll(getShipmetsFromMap(shipmentsMapAfterBookmark,'Delivery'));
                FinalshipmentsToUpdateException.addAll(getShipmetsFromMap(shipmentsMapAfterBookmark,'Exception'));
                FinalshipmentsToUpdate.addAll(getShipmetsFromMap(shipmentsMapAfterBookmark,'ManifestTrillumAndFleet'));
            } 
            system.debug('---FinalshipmentsToInsert-size--'+FinalshipmentsToInsert.size());
            system.debug('---FinalshipmentsToInsert---'+FinalshipmentsToInsert);
            if(FinalshipmentsToInsert.size()>0){               
                insert FinalshipmentsToInsert;
            }
            system.debug('---FinalshipmentsToUpdate--size-'+FinalshipmentsToUpdate.size()); 
            system.debug('---FinalshipmentsToUpdate---'+FinalshipmentsToUpdate);
            if(FinalshipmentsToUpdate.size()>0){              
                update FinalshipmentsToUpdate;
            }
            system.debug('---FinalshipmentsToUpdateIntranisitOrigin--size-'+FinalshipmentsToUpdateIntranisitOrigin.size()); 
            system.debug('---FinalshipmentsToUpdateIntranisitOrigin---'+FinalshipmentsToUpdateIntranisitOrigin); 
            if(FinalshipmentsToUpdateIntranisitOrigin.size()>0){              
                update FinalshipmentsToUpdateIntranisitOrigin;
            }
            
            system.debug('---FinalshipmentsToUpdateIntranisitGeneric--size-'+FinalshipmentsToUpdateIntranisitGeneric.size()); 
            system.debug('---FinalshipmentsToUpdateIntranisitGeneric---'+FinalshipmentsToUpdateIntranisitGeneric); 
            if(FinalshipmentsToUpdateIntranisitGeneric.size()>0){              
                update FinalshipmentsToUpdateIntranisitGeneric;
            }           
            system.debug('---FinalshipmentsToUpdateException--size-'+FinalshipmentsToUpdateException.size());
            system.debug('---FinalshipmentsToUpdateException---'+FinalshipmentsToUpdateException);
            if(FinalshipmentsToUpdateException.size()>0){              
                update FinalshipmentsToUpdateException;
            }
            
            system.debug('---FinalshipmentsToUpdateDelivery--size-'+FinalshipmentsToUpdateDelivery.size());
            system.debug('---FinalshipmentsToUpdateDelivery---'+FinalshipmentsToUpdateDelivery);
            if(FinalshipmentsToUpdateDelivery.size()>0){              
                update FinalshipmentsToUpdateDelivery;
            }
        }
    }
    
    //Method to return shipments by checking the shipment type category
    public list<shipment__c> getShipmetsFromMap(map<string,list<object>> shipmetsData,string typeOfShipmets){
        list<shipment__c> shipsToRetrun=new list<shipment__c>();
        if(shipmetsData.keySet().contains(typeOfShipmets)){
            shipsToRetrun.addAll((list<shipment__c>)shipmetsData.get(typeOfShipmets));   
        }      
        return shipsToRetrun;
    }
    
    //Method to use callout and return wrapper class type with shipments data
    public wrapperForBookmarkRetrun UpsFetch_and_shipment_creation(string bookmark){
        //Frame the json reuest format using maps
        Map<String, Object> jsonRequestmap = new Map<String, Object>();//map used to framing json requset :just adds the "{" "}" in json fomrat
        Map<String, Object> accessRequestMap = new Map<String, Object>();
        Map<String, Object> QuantumViewRequestMap=new Map<String, Object>();
        Map<String, Object> RequestMap=new  Map<String, Object>();
        //map<string,Object>  TimeRangeMap=new map<string,Object>(); 
        Map<String, Object> SubscriptionRequestMap=new  Map<String, Object>();
        map<string, list<object>> MaptoReturnToConstrutor=new map<string ,list<object>>();
        //TimeRangeMap.put('BeginDateTime','20200630173000');
        //TimeRangeMap.put('EndDateTime','20200630175000');
        SubscriptionRequestMap.put('Name','OutboundEchoMedia');
        if(bookmark!=null){
            QuantumViewRequestMap.put('Bookmark',bookmark);       
        }
        // SubscriptionRequestMap.put('DateTimeRange',TimeRangeMap);
        RequestMap.put('RequestAction','QVEvents');
        QuantumViewRequestMap.put('SubscriptionRequest',SubscriptionRequestMap);
        QuantumViewRequestMap.put('Request',RequestMap);
        accessRequestMap.put('Password','$Sooners1');
        accessRequestMap.put('UserId','Loves.shipping');
        accessRequestMap.put('AccessLicenseNumber','4D7FA2CF6E308435');
        jsonRequestmap.put('QuantumViewRequest',QuantumViewRequestMap);
        jsonRequestmap.put('AccessRequest',accessRequestMap);
        System.debug('---jsonRequestmap'+JSON.Serialize(jsonRequestmap));
        
        
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setTimeout(120000);
        httpRequest.setEndpoint('https://onlinetools.ups.com/rest/QVEvents');//Quantum view production url        
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setBody(JSON.Serialize(jsonRequestmap));       
        httpRequest.setMethod('POST');
        
        Http http = new Http();
        HttpResponse response = http.send(httpRequest);
        System.debug('Response Status :'+response.getStatusCode());       
        wrapperForBookmarkRetrun wprReturn=new wrapperForBookmarkRetrun();
        
        if(response.getStatusCode()==200){          
            Map <String, Object> root = (Map <String, Object>) JSON.deserializeUntyped(response.getBody());//total response convert to string->object type
            Map <String, Object> QuantumViewResponse= (Map <String, Object>) root.get('QuantumViewResponse');
           system.debug('QuantumViewResponse--'+QuantumViewResponse);
            Map <String, Object> ResponseMap= (Map <String, Object>) QuantumViewResponse.get('Response');
            if(ResponseMap.get('ResponseStatusCode').toString()=='1' && ResponseMap.get('ResponseStatusDescription').toString()=='Success'){
                Map <String, Object> QuantumViewEvents=(Map <String, Object>) QuantumViewResponse.get('QuantumViewEvents');
                system.debug('QuantumViewEvents--'+QuantumViewEvents);
                object SubscriptionEvents=(object) QuantumViewEvents.get('SubscriptionEvents');
                system.debug('SubscriptionEvents--'+SubscriptionEvents);
                Map <String, Object> SubscriptionEventsMap= (Map <String, Object>)SubscriptionEvents;
                system.debug('SubscriptionEventsMap--'+SubscriptionEventsMap);                
                //Check subscription files is list of object type or object type
                list<object> SubscriptionFile=new list<object>();             
                if(SubscriptionEventsMap.get('SubscriptionFile') instanceof list<object>){
                    SubscriptionFile=(list<object>)SubscriptionEventsMap.get('SubscriptionFile');
                }else{
                    SubscriptionFile.add(SubscriptionEventsMap.get('SubscriptionFile'));
                }                       
                if( QuantumViewResponse.get('Bookmark')!=null){
                    wprReturn.bookmark=QuantumViewResponse.get('Bookmark').toString();//If bookmark present, added this to wrapper for next Call Out
                }
                map<string,list<string>> RefrenceToTrackNumMap=new  map<string,list<string>>();//Map used to manipulate shipments for Intransit Status
                map<string,list<string>> RefrenceToTrackNumMapForDelivery=new  map<string,list<string>>();//Map used to manipulate shipments for Delivery Status
                map<string,list<string>> RefrenceToTrackNumMapForException=new  map<string,list<string>>();//Map used to manipulate shipments for Exception Status
                list<string> ReferenceNumberForJobList=new list<string>();//List used to store ref numbers(Job #) from response            
                set<string> FinalTrackNumbersToUpdateGeneric=new set<string>();//set used to store final tracking numbers to update In Transit Status
                set<string> FinalTrackNumbersToUpdateOrigin=new set<string>();
                set<string> FinalTrackNumbersToUpdateDelivery=new set<string>();//set used to store final tracking numbers to update Delivery Status
                set<string> FinalTrackNumbersToUpdateException=new set<string>();//set used to store final tracking numbers to update Exception Status
                ShipInfo_RefToTrackWithAdress_Wrapper wpclass=new ShipInfo_RefToTrackWithAdress_Wrapper();
                //Loop through subcription files for shipments data
                for(object SubFile:SubscriptionFile){
                    Map <String, Object> SubscriptionFileMap=(Map <String, Object>)SubFile;
                    system.debug('SubscriptionFileMap-FileName-'+SubscriptionFileMap.get('FileName').toString());
                    
                    //Check each shipment type category is list of object or object
                    list<object>Manifest=new list<object>();               
                    if(SubscriptionFileMap.get('Manifest')!=null){                   
                        if(SubscriptionFileMap.get('Manifest') instanceof list<object>){
                            Manifest=(list<object>)SubscriptionFileMap.get('Manifest');
                        }else{
                            Manifest.add(SubscriptionFileMap.get('Manifest'));
                        }   
                    }
                    system.debug('--manifest ---size-'+Manifest.size());
                    
                    list<object>Generic=new list<object>();               
                    if(SubscriptionFileMap.get('Generic')!=null){                    
                        if(SubscriptionFileMap.get('Generic') instanceof list<object>){
                            Generic=(list<object>)SubscriptionFileMap.get('Generic');
                        }else{
                            Generic.add(SubscriptionFileMap.get('Generic'));
                        }   
                    }
                    system.debug('--Generic ---size-'+Generic.size());
                    
                    list<object>Origin=new list<object>();                    
                    if(SubscriptionFileMap.get('Origin')!=null){            
                        if(SubscriptionFileMap.get('Origin') instanceof list<object>){
                            Origin=(list<object>)SubscriptionFileMap.get('Origin');
                        }else{
                            Origin.add(SubscriptionFileMap.get('Origin'));
                        } 
                    }
                    system.debug('--Origin ---size-'+Origin.size());
                    
                    list<object>Delivery=new list<object>();
                    if(SubscriptionFileMap.get('Delivery')!=null){             
                        if(SubscriptionFileMap.get('Delivery') instanceof list<object>){
                            Delivery=(list<object>)SubscriptionFileMap.get('Delivery');
                        }else{
                            Delivery.add(SubscriptionFileMap.get('Delivery'));
                        } 
                    }
                    system.debug('--Delivery ---size-'+Delivery.size());
                    
                    list<object>ExceptionList=new list<object>();
                    if(SubscriptionFileMap.get('Exception')!=null){             
                        if(SubscriptionFileMap.get('Exception') instanceof list<object>){
                            ExceptionList=(list<object>)SubscriptionFileMap.get('Exception');
                        }else{
                            ExceptionList.add(SubscriptionFileMap.get('Exception'));
                        } 
                    }
                    system.debug('--ExceptionList ---size-'+ExceptionList.size());
                    
                    if(Manifest!=null){
                        //Loop through Manifest(Has the new shiments info) for shipments data                    
                        for(object manifestItem:Manifest){
                            Map <String, Object> ManifestMap=(Map <String, Object>)manifestItem; 
                            system.debug('ManifestMap--'+ManifestMap);
                            Map <String, Object> ShipTo=(Map <String, Object>)ManifestMap.get('ShipTo');//Map used to store Ship To Adress
                            Map <String, Object> ShipToAddress=(Map <String, Object>)ShipTo.get('Address');
                            Map <String, Object> ReferenceNumberMap =new  Map <String, Object>();
                            if(ManifestMap.get('ReferenceNumber')!=null){
                                //Check if refrence number(job #) is list of object or object in response
                                list<object> ShipemtRefrenceList=new List<object>();
                                if(ManifestMap.get('ReferenceNumber') instanceof list<object>){
                                    ShipemtRefrenceList=(list<object>)ManifestMap.get('ReferenceNumber');
                                    ReferenceNumberMap=(map<string,object>)ShipemtRefrenceList[0];//Take only 0 index bcz only Refrence Field 1
                                }else{
                                    ShipemtRefrenceList.add(ManifestMap.get('ReferenceNumber'));
                                    ReferenceNumberMap=(map<string,object>)ShipemtRefrenceList[0];//Take only 0 index bcz only Refrence Field 1
                                }                           
                                system.debug('---ReferenceNumberMap----'+ReferenceNumberMap);
                                //Check Shipment Reference Number is separated by ','. if so split and add to list                     
                                string ShipMentRefNumber=ReferenceNumberMap.get('Value').toString();                            
                                list<string> ShipRefNums=ShipMentRefNumber.deleteWhitespace().split(',') ;                           
                                system.debug('---ShipRefNums----'+ShipRefNums);                             
                                Map <String, Object> PackageDetailsMap=(Map <String, Object>)ManifestMap.get('Package'); //Map used to store package data inside shipment (Only pacakge will have the Tracking Number)                                                        
                                String PacakgeTrackingNumber=PackageDetailsMap.get('TrackingNumber').toString();
                                String AddressLine=ShipToAddress.get('AddressLine1').toString();
                                String CityName=ShipToAddress.get('City').toString(); 
                                string stateCode=ShipToAddress.get('StateProvinceCode').toString();
                                String PostalZip=ShipToAddress.get('PostalCode').toString(); 
                                string pickDate=ManifestMap.get('PickupDate').toString();
                                string AttentionName;
                                if(ShipTo.get('AttentionName')!=null){
                                    AttentionName=ShipTo.get('AttentionName').toString();
                                }
                                system.debug('AttentionName---'+AttentionName);
                                if(ShipRefNums.size()>0){
                                    //Loop through Shipment Refrence Numbers and assign same Tracking Number to Refrence Numbers
                                    for(string RefNum:ShipRefNums){
                                        if(wpclass.RefrenceWithtracklist.containsKey(RefNum)){
                                            wpclass.RefrenceWithtracklist.get(RefNum).add(PacakgeTrackingNumber);
                                        }
                                        else{
                                            list<string> trackNumberList=new list<string>();
                                            trackNumberList.add(PacakgeTrackingNumber);
                                            wpclass.RefrenceWithtracklist.put(RefNum, trackNumberList);
                                            wpclass.adressMap.put(RefNum,AddressLine);                                       
                                            wpclass.cityMap.put(RefNum,CityName);
                                            wpclass.StateCodeMap.put(RefNum,stateCode);
                                            wpclass.PostalZipMap.put(RefNum,PostalZip);
                                            wpclass.PickUpDate.put(RefNum,pickDate);
                                            wpclass.AttentionNameMap.put(RefNum,AttentionName);
                                        }
                                        ReferenceNumberForJobList.add(RefNum);
                                    }                               
                                    system.debug('--wpclass.RefrenceWithtracklist-manifest-'+wpclass.RefrenceWithtracklist);
                                }                           
                            }                            
                        }
                    }                
                    
                    if(Generic!=null){  
                        //Loop through Generic Type Category for In Transit Status Shipmets Data
                        for(object GenericItem:Generic){
                            map<string,object> GenericMap=(map<string,object>)GenericItem;
                            system.debug('--GenericMap---'+GenericMap);
                            string TrackingNumber=GenericMap.get('TrackingNumber').toString();
                            FinalTrackNumbersToUpdateGeneric.add(TrackingNumber);
                            if(GenericMap.get('ShipmentReferenceNumber')!=null){
                                //Check if ShipmentReferenceNumber number(job #) is list of object or object in response
                                map<string,object> ShipmentReferenceNumberMap =new map<string,object>(); 
                                list<object> ShipemtRefrenceList=new List<object>();                                              
                                if(GenericMap.get('ShipmentReferenceNumber') instanceof list<object>){
                                    ShipemtRefrenceList=(list<object>)GenericMap.get('ShipmentReferenceNumber');
                                    ShipmentReferenceNumberMap=(map<string,object>)ShipemtRefrenceList[0];
                                }else{
                                    ShipemtRefrenceList.add(GenericMap.get('ShipmentReferenceNumber'));
                                    ShipmentReferenceNumberMap=(map<string,object>)ShipemtRefrenceList[0];
                                }                          
                                //Check Shipment Reference Number is separated by ','. if so split and add to list 
                                string ShipMentRefNumber=ShipmentReferenceNumberMap.get('Value').toString();
                                system.debug('---ShipMentRefNumber----'+ShipMentRefNumber);
                                list<string> ShipRefNums=ShipMentRefNumber.split(',') ;                           
                                system.debug('---ShipRefNums----'+ShipRefNums); 
                                //system.debug('--jobRefrenceNumber---'+jobRefrenceNumber);
                                if(ShipRefNums.size()>0){
                                    for(string RefNum:ShipRefNums){
                                        if(RefrenceToTrackNumMap.containsKey(RefNum)){
                                            RefrenceToTrackNumMap.get(RefNum).add(TrackingNumber);
                                        }else{
                                            list<String> TrackNumberList=new List<String>();
                                            TrackNumberList.add(TrackingNumber);
                                            RefrenceToTrackNumMap.put(RefNum,TrackNumberList);
                                        }
                                    }
                                }
                            }                     
                        }
                        system.debug('--RefrenceToTrackNumMap-generic-'+RefrenceToTrackNumMap);
                    }
                    if(Origin!=null){
                        //Loop through Origin Type Category for In Transit Status Shipmets Data 
                        for(object OriginItem:Origin){
                            map<string,object> OriginMap=(map<string,object>)OriginItem;
                            system.debug('--OriginMap---'+OriginMap);
                            string TrackingNumber=OriginMap.get('TrackingNumber').toString();
                            FinalTrackNumbersToUpdateOrigin.add(TrackingNumber);
                            if(OriginMap.get('ShipmentReferenceNumber')!=null){
                                //Check if ShipmentReferenceNumber number(job #) is list of object or object in response
                                map<string,object> ShipmentReferenceNumberMap =new map<string,object>(); 
                                list<object> ShipemtRefrenceList=new List<object>();
                                system.debug(OriginMap.get('ShipmentReferenceNumber') instanceof list<object>);                    
                                if(OriginMap.get('ShipmentReferenceNumber') instanceof list<object>){
                                    ShipemtRefrenceList=(list<object>)OriginMap.get('ShipmentReferenceNumber');
                                    ShipmentReferenceNumberMap=(map<string,object>)ShipemtRefrenceList[0];
                                }else{
                                    ShipemtRefrenceList.add(OriginMap.get('ShipmentReferenceNumber'));
                                    ShipmentReferenceNumberMap=(map<string,object>)ShipemtRefrenceList[0];
                                }                                
                                //Check Shipment Reference Number is separated by ','. if so split and add to list 
                                string ShipMentRefNumber=ShipmentReferenceNumberMap.get('Value').toString();
                                system.debug('---ShipMentRefNumber----'+ShipMentRefNumber);
                                list<string> ShipRefNums=ShipMentRefNumber.split(',') ;                           
                                system.debug('---ShipRefNums----'+ShipRefNums);                            
                                if(ShipRefNums.size()>0){
                                    for(string RefNum:ShipRefNums){
                                        if(RefrenceToTrackNumMap.containsKey(RefNum)){
                                            RefrenceToTrackNumMap.get(RefNum).add(TrackingNumber);
                                        }else{
                                            list<String> TrackNumberList=new List<String>();
                                            TrackNumberList.add(TrackingNumber);
                                            RefrenceToTrackNumMap.put(RefNum,TrackNumberList);
                                        }
                                    }
                                }
                            }                        
                        }
                        system.debug('--RefrenceToTrackNumMap-origin-'+RefrenceToTrackNumMap);    
                    }
                    if(Delivery!=null){
                        //Loop through Delivery Type Category for Delivered Status Shipmets Data 
                        for(object DeliveryItem:Delivery){
                            map<string,object> DeliveryMap=(map<string,object>)DeliveryItem;
                            system.debug('--DeliveryMap---'+DeliveryMap);
                            string TrackingNumber=DeliveryMap.get('TrackingNumber').toString();
                            FinalTrackNumbersToUpdateDelivery.add(TrackingNumber);
                            if(DeliveryMap.get('ShipmentReferenceNumber')!=null){
                                //Check if ShipmentReferenceNumber number(job #) is list of object or object in response
                                map<string,object> ShipmentReferenceNumberMap =new map<string,object>(); 
                                list<object> ShipemtRefrenceList=new List<object>();                                                 
                                if(DeliveryMap.get('ShipmentReferenceNumber') instanceof list<object>){
                                    ShipemtRefrenceList=(list<object>)DeliveryMap.get('ShipmentReferenceNumber');
                                    ShipmentReferenceNumberMap=(map<string,object>)ShipemtRefrenceList[0];
                                }else{
                                    ShipemtRefrenceList.add(DeliveryMap.get('ShipmentReferenceNumber'));
                                    ShipmentReferenceNumberMap=(map<string,object>)ShipemtRefrenceList[0];
                                }                                                       
                                //Check Shipment Reference Number is separated by ','. if so split and add to list 
                                string ShipMentRefNumber=ShipmentReferenceNumberMap.get('Value').toString();
                                system.debug('---ShipMentRefNumber----'+ShipMentRefNumber);
                                list<string> ShipRefNums=ShipMentRefNumber.split(',') ;                           
                                system.debug('---ShipRefNums----'+ShipRefNums);
                                if(ShipRefNums.size()>0){
                                    for(string RefNum:ShipRefNums){
                                        if(RefrenceToTrackNumMapForDelivery.containsKey(RefNum)){
                                            RefrenceToTrackNumMapForDelivery.get(RefNum).add(TrackingNumber);
                                        }else{
                                            list<String> TrackNumberList=new List<String>();
                                            TrackNumberList.add(TrackingNumber);
                                            RefrenceToTrackNumMapForDelivery.put(RefNum,TrackNumberList);
                                        } 
                                    }
                                }
                            }                        
                        }
                        system.debug('--RefrenceToTrackNumMapForDelivery--'+RefrenceToTrackNumMapForDelivery);    
                    }
                    if(ExceptionList!=null){
                        //Loop through Delivery Type Category for Delivered Status Shipmets Data 
                        for(object ExceptionItem:ExceptionList){
                            map<string,object> ExceptionMap=(map<string,object>)ExceptionItem;
                            system.debug('--ExceptionMap---'+ExceptionMap);
                            string TrackingNumber=ExceptionMap.get('TrackingNumber').toString();
                            FinalTrackNumbersToUpdateException.add(TrackingNumber);
                            if(ExceptionMap.get('ShipmentReferenceNumber')!=null){
                                //Check if ShipmentReferenceNumber number(job #) is list of object or object in response
                                map<string,object> ShipmentReferenceNumberMap =new map<string,object>(); 
                                list<object> ShipemtRefrenceList=new List<object>();                                                  
                                if(ExceptionMap.get('ShipmentReferenceNumber') instanceof list<object>){
                                    ShipemtRefrenceList=(list<object>)ExceptionMap.get('ShipmentReferenceNumber');
                                    ShipmentReferenceNumberMap=(map<string,object>)ShipemtRefrenceList[0];
                                }else{
                                    ShipemtRefrenceList.add(ExceptionMap.get('ShipmentReferenceNumber'));
                                    ShipmentReferenceNumberMap=(map<string,object>)ShipemtRefrenceList[0];
                                }                                
                                //Check Shipment Reference Number is separated by ','. if so split and add to list 
                                string ShipMentRefNumber=ShipmentReferenceNumberMap.get('Value').toString();
                                system.debug('---ShipMentRefNumber----'+ShipMentRefNumber);
                                list<string> ShipRefNums=ShipMentRefNumber.split(',') ;                           
                                system.debug('---ShipRefNums----'+ShipRefNums);                            
                                if(ShipRefNums.size()>0){
                                    for(string RefNum:ShipRefNums){
                                        if(RefrenceToTrackNumMapForException.containsKey(RefNum)){
                                            RefrenceToTrackNumMapForException.get(RefNum).add(TrackingNumber);
                                        }else{
                                            list<String> TrackNumberList=new List<String>();
                                            TrackNumberList.add(TrackingNumber);
                                            RefrenceToTrackNumMapForException.put(RefNum,TrackNumberList);
                                        } 
                                    }
                                }
                            }                        
                        }
                        system.debug('--RefrenceToTrackNumMapForException--'+RefrenceToTrackNumMapForException);    
                    }
                }               
                
                if(!ReferenceNumberForJobList.isEmpty()){//
                    map<string,string> jobNumberWithShipment=new map<string,string>();
                    map<string,string> jobNumberWithShipmentEmail=new map<string,string>();
                    map<string,list<shipment__c>> jobIdWithShipmets=new map<string,list<shipment__c>>();
                    list<shipment__c> shipmentsToCreateIntial=new list<shipment__c>();//list to store new shipments for jobs which are not having single shipment records before
                    list<shipment__c> shipmentsToCreateAfterCheck=new list<shipment__c>();//List to store new shipments for jobs which are may have shipments record before
                    list<shipment__c> shipmentsToUpdateTrillumAndFleet;
                    list<shipment__c> shipmentsToUpdateTrillumAndFleetFinal=new  list<shipment__c>();
                    //Query all the jobs with matching Refrence numbers stored from responses
                    list<job__c> joblist=[select id,name,Job_Auto_Number__c,js_client_contact__r.Email__c,(select id,job__c,job__r.name,job__r.job_Auto_number__c,Tracking_Number__c,Shipment_Email__c from shipments__r)
                                                    from job__c where  Job_Auto_Number__c like:ReferenceNumberForJobList];
                    
                    system.debug('--joblist---'+joblist);
                    //Loop through Jobs -> shipments to ensure shipment record insert as new               
                    for(job__c job:joblist){   
                        shipmentsToUpdateTrillumAndFleet=new list<shipment__c>();                       
                        if(job.shipments__r.size()>0){
                            list<string> Existtracknumbers=new list<string>();
                            //Loop for adding existing jobs shipments tracking numbers to list
                            for(shipment__c ship:job.shipments__r){
                                Existtracknumbers.add(ship.Tracking_Number__c);
                                //Get shipment id and email from default created shipment for Trillium and Fleet sales orders
                                if(ship.Job__r.name.contains('Trillium')||ship.Job__r.name.contains('Fleet Sales')){
                                    if(ship.Tracking_Number__c==null){
                                        jobNumberWithShipment.put(job.Job_Auto_Number__c,ship.id);
                                    }
                                    jobNumberWithShipmentEmail.put(job.Job_Auto_Number__c,ship.Shipment_Email__c);
                                }                               
                            }     
                            //Loop for create shipments by checking the response Tracking numbers not match with exisitng job shipments records
                            for(string trackNumber:wpclass.RefrenceWithtracklist.get(job.Job_Auto_Number__c)){
                                if(Existtracknumbers.contains(trackNumber)){
                                    //
                                }else{
                                    
                                    shipment__c shipment=new shipment__c();
                                    if(jobNumberWithShipment.containsKey(job.Job_Auto_Number__c) && shipmentsToUpdateTrillumAndFleet.size()==0){
                                        shipment.id= jobNumberWithShipment.get(job.Job_Auto_Number__c);
                                        string Sentdate=wpclass.PickUpDate.get(job.Job_Auto_Number__c);
                                        shipment.Tracking_Number__c=trackNumber; 
                                        shipment.Shipment_Status__c='Ready to Ship';
                                        shipment.Shipping_Method__c='UPS';
                                        shipment.Shipment_Date__c=date.valueOf(Sentdate.left(4)+'-'+Sentdate.mid(4,2)+'-'+Sentdate.right(2));
                                        shipmentsToUpdateTrillumAndFleet.add(shipment);
                                        shipmentsToUpdateTrillumAndFleetFinal.add(shipment);
                                        system.debug('----jobame-trillium-'+job.Job_Auto_Number__c+'--track--'+trackNumber); 
                                    }                                   
                                    else{
                                        shipment.Shipment_Name__c='Shipment-'+job.Job_Auto_Number__c;
                                        if(wpclass.AttentionNameMap.get(job.Job_Auto_Number__c)!=null){
                                            shipment.TO_ATTN__c=wpclass.AttentionNameMap.get(job.Job_Auto_Number__c);
                                        }
                                        shipment.Job__c=job.id;
                                        shipment.Tracking_Number__c=trackNumber;                               
                                        shipment.Shipment_Status__c='Ready to Ship';                                      
                                        shipment.Shipping_Method__c='UPS';
                                        if(job.name.contains('Trillium')||job.name.contains('Fleet Sales')){
                                            shipment.Shipment_Email__c=jobNumberWithShipmentEmail.get(job.Job_Auto_Number__c);
                                        }else{
                                            shipment.Shipment_Email__c=job.js_client_contact__r.Email__c;
                                        }
                                        string Sentdate=wpclass.PickUpDate.get(job.Job_Auto_Number__c);
                                        shipment.Shipment_Date__c=date.valueOf(Sentdate.left(4)+'-'+Sentdate.mid(4,2)+'-'+Sentdate.right(2));
                                        shipment.Shipment_State__c = wpclass.StateCodeMap.get(job.Job_Auto_Number__c);
                                        shipment.Shipment_Zip_code__c=wpclass.PostalZipMap.get(job.Job_Auto_Number__c);                               
                                        shipment.Shipment_Street_Address__c=wpclass.adressMap.get(job.Job_Auto_Number__c);
                                        shipment.Shipment_City__c=wpclass.cityMap.get(job.Job_Auto_Number__c);
                                        shipmentsToCreateAfterCheck.add(shipment);
                                        system.debug('----jobame--'+job.Job_Auto_Number__c+'--track--'+trackNumber);
                                    } 
                                }
                            }
                        }
                        else{                           
                            for(string s:wpclass.RefrenceWithtracklist.get(job.Job_Auto_Number__c)){
                                shipment__c shipment=new shipment__c();
                                shipment.Shipment_Name__c='Shipment-'+job.Job_Auto_Number__c;
                                shipment.Job__c=job.id;
                                if(wpclass.AttentionNameMap.get(job.Job_Auto_Number__c)!=null){
                                    shipment.TO_ATTN__c=wpclass.AttentionNameMap.get(job.Job_Auto_Number__c);
                                }
                                shipment.Tracking_Number__c=s;                               
                                shipment.Shipment_Status__c='Ready to Ship';                                   
                                shipment.Shipment_Email__c=job.js_client_contact__r.Email__c;
                                shipment.Shipping_Method__c='UPS';
                                string Sentdate=wpclass.PickUpDate.get(job.Job_Auto_Number__c);
                                shipment.Shipment_Date__c=date.valueOf(Sentdate.left(4)+'-'+Sentdate.mid(4,2)+'-'+Sentdate.right(2));
                                shipment.Shipment_State__c = wpclass.StateCodeMap.get(job.Job_Auto_Number__c);
                                shipment.Shipment_Zip_code__c=wpclass.PostalZipMap.get(job.Job_Auto_Number__c);                               
                                shipment.Shipment_Street_Address__c=wpclass.adressMap.get(job.Job_Auto_Number__c);
                                shipment.Shipment_City__c=wpclass.cityMap.get(job.Job_Auto_Number__c);
                                shipmentsToCreateIntial.add(shipment);
                                system.debug('----jobame--'+job.Job_Auto_Number__c+'--track---'+s);
                            }                           
                        }
                    }                    
                    list<shipment__c> FinalInsertShipments=new list<shipment__c>();
                    FinalInsertShipments.addAll(shipmentsToCreateAfterCheck);
                    FinalInsertShipments.addAll(shipmentsToCreateIntial);   
                    system.debug('FinalInsertShipments---'+FinalInsertShipments); 
                    wprReturn.ShipmetsMaptoReturnToConstrutor.put('ManifestTrillumAndFleet',shipmentsToUpdateTrillumAndFleetFinal); 
                    wprReturn.ShipmetsMaptoReturnToConstrutor.put('Manifest',FinalInsertShipments);                
                }                
                
                if(!FinalTrackNumbersToUpdateGeneric.isEmpty()){
                    //QUERY only shipments with matching with Tracking numbers gathered from Gneric and Origin type shipments response
                    list<shipment__c> shipmentslist=[select id,name,Shipment_Status__c,job__c,job__r.name,job__r.job_Auto_number__c, Tracking_Number__c 
                                                               from shipment__c where Tracking_Number__c in:FinalTrackNumbersToUpdateGeneric];
                    for(shipment__c ship:shipmentslist){
                        system.debug(ship.Tracking_Number__c);
                        ship.Shipment_Status__c='In Transit';
                    } 
                    if(shipmentslist.size()>0){
                        wprReturn.ShipmetsMaptoReturnToConstrutor.put('InTransitGeneric',shipmentslist);                    
                    }
                }
                
                if(!FinalTrackNumbersToUpdateOrigin.isEmpty()){
                    //QUERY only shipments with matching with Tracking numbers gathered from Gneric and Origin type shipments response
                    list<shipment__c> shipmentslist=[select id,name,Shipment_Status__c,job__c,job__r.name,job__r.job_Auto_number__c, Tracking_Number__c 
                                                               from shipment__c where Tracking_Number__c in:FinalTrackNumbersToUpdateOrigin];
                    for(shipment__c ship:shipmentslist){
                        system.debug(ship.Tracking_Number__c);
                        ship.Shipment_Status__c='In Transit';
                    } 
                    if(shipmentslist.size()>0){
                        wprReturn.ShipmetsMaptoReturnToConstrutor.put('InTransitOrigin',shipmentslist);                    
                    }
                } 
                
                if(!FinalTrackNumbersToUpdateDelivery.isEmpty()){
                    //QUERY only shipments with matching with Tracking numbers gathered from Delivery type shipments response
                    list<shipment__c> shipmentslistDeliveryUpdate=[select id,name,Shipment_Status__c,job__c,job__r.name,job__r.job_Auto_number__c, Tracking_Number__c 
                                                                             from shipment__c where Tracking_Number__c in:FinalTrackNumbersToUpdateDelivery];
                    for(shipment__c ship:shipmentslistDeliveryUpdate){
                        system.debug(ship.Tracking_Number__c);
                        ship.Shipment_Status__c='Delivered';
                    } 
                    if(shipmentslistDeliveryUpdate.size()>0){
                        wprReturn.ShipmetsMaptoReturnToConstrutor.put('Delivery',shipmentslistDeliveryUpdate);                  
                    }
                }                
                
                if(!FinalTrackNumbersToUpdateException.isEmpty()){
                    //QUERY only shipments with matching with Tracking numbers gathered from Exception type shipments response
                    list<shipment__c> shipmentslistExceptionUpdate=[select id,name,Shipment_Status__c,job__c,job__r.name,job__r.job_Auto_number__c, Tracking_Number__c 
                                                                              from shipment__c where Tracking_Number__c in:FinalTrackNumbersToUpdateException];
                    for(shipment__c ship:shipmentslistExceptionUpdate){
                        system.debug(ship.Tracking_Number__c);
                        ship.Shipment_Status__c='Exception';
                    } 
                    if(shipmentslistExceptionUpdate.size()>0){
                        wprReturn.ShipmetsMaptoReturnToConstrutor.put('Exception',shipmentslistExceptionUpdate);                    
                    }
                }
            }
        }
        return wprReturn;
    }
    
    
    public class wrapperForBookmarkRetrun{
        public map<string,list<object>> ShipmetsMaptoReturnToConstrutor;
        public string bookmark;
        public  wrapperForBookmarkRetrun(){
            ShipmetsMaptoReturnToConstrutor=new map<string,list<object>>();
        }
    }
    
    public class ShipInfo_RefToTrackWithAdress_Wrapper{
        public map<string,list<string>> RefrenceWithtracklist;
        public map<string,string> adressMap;
        public map<string,string> cityMap;
        public  map<string,string> StateCodeMap;
        public  map<string,string> PostalZipMap;
        public  map<string,string> PickUpDate;
        public  map<string,string> AttentionNameMap; 
        public ShipInfo_RefToTrackWithAdress_Wrapper(){
            RefrenceWithtracklist=new  map<string,list<string>>();
            adressMap=new map<string,string>();
            cityMap=new map<string,string>();
            StateCodeMap=new map<string,string>();
            PostalZipMap=new map<string,string>();     
            PickUpDate=new map<string,string>(); 
            AttentionNameMap=new map<string,string>(); 
        }
    }
    
}