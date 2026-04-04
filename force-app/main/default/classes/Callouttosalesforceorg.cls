public class Callouttosalesforceorg {
    public static void getcalloutaccounts(){
        // Prepare the 'like' parameter by adding '%' on both sides
        string likeadd = '%' + 'mani sai' + '%';
        //string varvalue = 'mani sai';
        Http httpsobj = new Http();
        Httprequest Httprequestobj = new Httprequest();
        Httprequestobj.setEndPoint('callout:SFDC_New_Named_Credential/services/apexrest/AccountListRcds?Name=' + EncodingUtil.urlEncode(likeadd, 'UTF-8'));
        // Httprequestobj.setEndPoint('callout:SFDC_New_Named_Credential/services/apexrest/AccountListRcds?Name=' +likeadd);
        Httprequestobj.setMethod('GET');
        Httpresponse response = httpsobj.send(Httprequestobj);
        system.debug('response getbody === '+response.getBody());
        system.debug('response getstatus === '+response.getStatusCode());
        if(response.getStatusCode() == 200){
            list<object>results = (list<object>)JSON.deserializeuntyped(response.getBody());
            for(object res : results){
                system.debug('res === '+res);
                map<string,object>accrcd = (map<string,object>)res;
                system.debug('get field value === '+accrcd.get('name'));
            }
        }
        
    }
}