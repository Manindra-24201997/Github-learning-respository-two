({
    FetchpicklistVal : function(component, event, helper) {
        
        var ClientVal = component.get("c.getClients");
        ClientVal.setCallback(this, function(ClientValRes) {
            var ClientValstate = ClientValRes.getState();
            console.log('>>>>>>>>>>> ClientVal state>>>>>>>>>>>>>>>'+ClientValstate);
            //console.log('>>>>>>>>>>>ClientVal Res>>>>>>>>>>>>>>>'+JSON.stringify(ClientValRes.getReturnValue()));
            if (ClientValstate === "SUCCESS") {
                var result=ClientValRes.getReturnValue();
                var clientMap=[];
                for(var key in result){
                    clientMap.push({key: key, value: result[key]});
                }
                component.set("v.ClientRec",clientMap);
            }
        });
        
        var VendorVal = component.get("c.getvendors");
        VendorVal.setCallback(this, function(VendorValRes) {
            var VendorValstate = VendorValRes.getState();
            console.log('>>>>>>>>>>> VendorVal state>>>>>>>>>>>>>>>'+VendorValstate);
            //console.log('>>>>>>>>>>>VendorVal Res>>>>>>>>>>>>>>>'+JSON.stringify(VendorValRes.getReturnValue()));
            if (VendorValstate === "SUCCESS") {
                component.set("v.VendorRec", VendorValRes.getReturnValue());
            }
        });
        
        var BBStatusVal = component.get("c.getBBStatus");
        BBStatusVal.setCallback(this, function(BBStatusValRes) {
            var BBStatusValstate = BBStatusValRes.getState();
            console.log('>>>>>>>>>>> BBStatusVal state>>>>>>>>>>>>>>>'+BBStatusValstate);
            //console.log('>>>>>>>>>>>BBStatusVal Res>>>>>>>>>>>>>>>'+JSON.stringify(BBStatusValRes.getReturnValue()));
            if (BBStatusValstate === "SUCCESS") {
                component.set("v.BBStatus", BBStatusValRes.getReturnValue());
            }
        });        
        
        
        var BBTypeVal = component.get("c.getBBType");
        BBTypeVal.setCallback(this, function(BBTypeValRes) {
            var BBTypeValstate = BBTypeValRes.getState();
            console.log('>>>>>>>>>>>BB Type state>>>>>>>>>>>>>>>'+BBTypeValstate);
            //console.log('>>>>>>>>>>>BB Type Res>>>>>>>>>>>>>>>'+JSON.stringify(BBTypeValRes.getReturnValue()));
            if (BBTypeValstate === "SUCCESS") {
                component.set("v.BBTypeRec", BBTypeValRes.getReturnValue());
                component.find('BBType').set('v.value',BBTypeValRes.getReturnValue()[0]);
            }
        });
        
        var IllumVal = component.get("c.getIllumination");
        IllumVal.setCallback(this, function(IllumValRes) {
            var IllumValstate = IllumValRes.getState();
            console.log('>>>>>>>>>>>IlluminationVal state>>>>>>>>>>>>>>>'+IllumValstate);
            //console.log('>>>>>>>>>>>IlluminationVal Res>>>>>>>>>>>>>>>'+JSON.stringify(BBTypeValRes.getReturnValue()));
            if (IllumValstate === "SUCCESS") {
                component.set("v.IlluminationVal", IllumValRes.getReturnValue());
            }
        });
        
        var DistVal = component.get("c.getDistrict");
        DistVal.setCallback(this, function(DistValRes) {
            var DistValstate = DistValRes.getState();
            console.log('>>>>>>>>>>>District state>>>>>>>>>>>>>>>'+DistValstate);
            //console.log('>>>>>>>>>>>District Res>>>>>>>>>>>>>>>'+JSON.stringify(DistValRes.getReturnValue()));
            if (DistValstate === "SUCCESS") {
                component.set("v.DistrictVal", DistValRes.getReturnValue());
            }
        });
        
        $A.enqueueAction(ClientVal);
        $A.enqueueAction(VendorVal);
        $A.enqueueAction(BBStatusVal);
        $A.enqueueAction(BBTypeVal);
        $A.enqueueAction(IllumVal);
        $A.enqueueAction(DistVal);
    },
    
    
    getResultsList : function(component, event, helper) {
        component.set("v.showSpinner",true);
        
        var BBname=component.find('Billboard#').get('v.value');
        console.log('BBName::::::'+BBname);
        var BBTitle=component.find('Title').get('v.value');  
        console.log('BBTitle::::::'+BBTitle);
        var BBlocation=component.find('Location').get('v.value');  
        console.log('BBlocation::::::'+BBlocation);
        var BBStatus=component.find('BillboardStatus').get('v.value');
        console.log('BBStatus::::::'+BBStatus);
        var BBIllumination=component.find('Illumination').get('v.value'); 
        console.log('BBIllumination::::::'+BBIllumination);
        var BBClientName=component.find('ClientName').get('v.value'); 
        console.log('BBClientName::::::'+BBClientName);
        var BBDistrict=component.find('District').get('v.value');  
        console.log('BBDistrict::::::'+BBDistrict);
        var BBVendorName=component.find('BBVendor').get('v.value');
        console.log('BBVendorName::::::'+BBVendorName);
        var BBtype=component.find('BBType').get('v.value');
        console.log('BBtype::::::'+BBtype);
        var BBSize=component.find('Size').get('v.value');
        console.log('BBSize::::::'+BBSize);
        var BBPMT=component.find('PMT').get('v.value');
        console.log('BBPMT::::::'+BBPMT);
        var BBLat=component.find('Latitude').get('v.value'); 
        console.log('BBLat::::::'+BBLat);
        var BBlong=component.find('Longitude').get('v.value');  
        console.log('BBlong::::::'+BBlong);
        var BBexpD1=component.find('ExpDateFrom').get('v.value');   
        console.log('BBexpD1::::::'+BBexpD1);
        var BBexpD2=component.find('ExpDateTo').get('v.value');  
        console.log('BBexpD2::::::'+BBexpD2);
        
        
        var actionSearch=component.get("c.searchbillboards");
        actionSearch.setParams({
            "strBBname": BBname,
            "strTitle": BBTitle,
            "strBBlocation": BBlocation,
            "BBStatusString": BBStatus,
            "strIllumination": BBIllumination,
            "strBBClientName": BBClientName,
            "strDistrict": BBDistrict,
            "strBBVendorName": BBVendorName,
            "strBBtype": BBtype,
            "strSize": BBSize,
            "strPMT" : BBPMT,
            "strLat" : BBLat,
            "strlong": BBlong,
            "expD1" : BBexpD1,
            "expD2" : BBexpD2
        });
        actionSearch.setCallback(this, function(Response){	
            var state = Response.getState();
            console.log('>>>>>>>>>>>State>>>>>>>>>>>>>>>>>>'+state);
            if(state=='SUCCESS'){  
                console.log('>>>>>>>>>>>Result Length>>>>>>>>>>>>'+Response.getReturnValue().length);
                console.log('>>>>>>>>>>>Result>>>>>>>>>>>>'+JSON.stringify(Response.getReturnValue()));
                component.set("v.ResultsList",Response.getReturnValue());               
                component.set("v.showSpinner",false);                
            }
            else  {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: Response.getReturnValue(),
                    duration:' 5000',
                    type: 'Error',
                });
                toastEvent.fire();
                console.log('>>>>>>>>>spinner event end>>>>>>>>');
                component.set("v.showSpinner", false); 
            }
        });
        $A.enqueueAction(actionSearch); 
    }
})