({
    fecthTableData : function(component, event, helper) {
        var action=component.get("c.getClientList");
        action.setCallback(this, function(Response){
            if(Response.getState()=='SUCCESS'){              
                component.set("v.CWrap",Response.getReturnValue());
            }          
        });
        $A.enqueueAction(action);
    },
    
    fetchMaterialItemOptions : function(component, event, helper) {
        var matarialItems=component.get("c.getMaterialType");
        matarialItems.setCallback(this, function(Response){
            if(Response.getState()=='SUCCESS'){              
                component.set("v.MaterialType",Response.getReturnValue());
                // alert(Response.getReturnValue());
            }
        });
        var getLables=component.get("c.getStockLabels");
        getLables.setCallback(this, function(Response){
            console.log('----response---'+JSON.stringify(Response.getReturnValue()));
            if(Response.getState()=='SUCCESS'){              
                component.set("v.stockLables",Response.getReturnValue());
            }
            
        });
        $A.enqueueAction(matarialItems);
        $A.enqueueAction(getLables);
        
    },
    
    updateallcartitems : function(component,event,helper,clientStoreSelectList){
        var updateallcartitemsstore=component.get("c.updateallcartitemsstoremthd");
        updateallcartitemsstore.setParams({"clientStoreSelectList":clientStoreSelectList});
        updateallcartitemsstore.setCallback(this, function(Response){
            
        });
        $A.enqueueAction(updateallcartitemsstore);
    },
    
    addItemToCartfinal : function(component, event, helper){
        var selectedToCart=component.get("v.MaterialItems");
        var alreadyInCart=component.get("v.MaterialItemsInCart");  
        var AddToCartItems=[];
        var MaterialItemsArray=[];
        var keyIds=[];
        var checkedCount=0;  
        var materialItemList=[];
        var val = '';
        
        for(var i=0;i<selectedToCart.length;i++){          
            var record={};
            record[selectedToCart[i].key]=selectedToCart[i].value;
            MaterialItemsArray.push(record);
        }      
        
        if(alreadyInCart){
            for(var i=0;i< alreadyInCart.length;i++){
                keyIds.push(alreadyInCart[i].key);
            }
        }
        console.log('keyIds === '+keyIds.length);
        
        for(var i=0;i< selectedToCart.length;i++){
            var keyId=selectedToCart[i].key;
            if(selectedToCart[i].value.checked==true){  
                if(!keyIds.includes(keyId)){
                    checkedCount=checkedCount+1;
                    AddToCartItems.push({
                        key:selectedToCart[i].key,
                        value:selectedToCart[i].value
                    });  
                }
                else{
                    val =  selectedToCart[i].value.MI.Name + ',';
                }
                //delete MaterialItemsArray[i][keyId];    // commented on 29 - 08 -2022
                MaterialItemsArray.push( MaterialItemsArray[i][keyId].greycolor= 'green');          
            }  
        }
        val = val.substring(0, val.length - 1);
        
        if(alreadyInCart==null || alreadyInCart=='undefined'){          
            alreadyInCart=AddToCartItems;
        }
        else{        
            alreadyInCart=alreadyInCart.concat(AddToCartItems);
        }          
        
        for(var i=0;i<MaterialItemsArray.length;i++){
            for(var key in MaterialItemsArray[i]){
                materialItemList.push({
                    key:key,
                    value: MaterialItemsArray[i][key]
                });
            }
        }
        selectedToCart=materialItemList;      
        console.log('---checkedCount---'+checkedCount);
        if(checkedCount>0){        
            //component.find("enter-search").set("v.value", '');
            // component.find("enter-search-carthold").set("v.value", '');
            component.set("v.ShowStoreSupplies",false);
            component.set("v.ShowStoreList",false);
            component.set("v.ShowCombineList",false);
            component.set("v.boolval",false);             //added by manindra on 19 - 12 - 2022 but before it was commented
            component.set("v.carthold",false); 
            component.set("v.homepagesearchvaluefrom",''); //setting value after execution
            component.set("v.showhomepagesearchvalueitems",false);  //added by manindra on 19 - 12 - 2022
            component.set("v.showhomepagesearchvalueitemscarthold",false);//added by manindra on 19 - 12 - 2022
            component.set("v.showhomepagesearchvalueitemscartholdgrid",false);//added by manindra on 19 - 12 - 2022
            component.set("v.ShowAddCartSection",true);            
            component.set("v.MaterialItemsInCart",alreadyInCart);
            component.set("v.MaterialItems",selectedToCart);            
        }        
        else
        {
            // unsaved.setUnsavedChanges(false);
            console.log('list empty');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Please select atleast one Material Item which are not in cart."
            });
            toastEvent.fire();
        }
        console.log('---adcart---');
    },
    
    getShowItems : function(component,event,helper,mTypeSelected,mTypeInput) {
        console.log('item category === '+mTypeSelected+' and search name is === '+mTypeInput);
        var getShowItems=component.get("c.ShowItems");
        getShowItems.setParams({                                       //This commented newly
            "MaterialItemNameString" : mTypeInput,
            "MaterialTypeString" : mTypeSelected
        });
        getShowItems.setCallback(this, function(Response){
            var materialItemList=[];
            var materialItemListagain=[];
            if(Response.getState()=='SUCCESS'){
                var materialItemMap=Response.getReturnValue(); 
                console.log('---continue-hlpr--'+JSON.stringify(materialItemMap));
                for(var key in materialItemMap){
                    materialItemListagain.push({
                        key : key,
                        value: materialItemMap[key]
                    });
                }
                if(mTypeSelected && materialItemListagain.length <= 0 ){
                    console.log('materialItemListagain --- '+materialItemListagain.length);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "duration":'3000',
                        "message": "There are no search results in this category."
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
                }
                var selectedToCart=component.get("v.MaterialItemsInCart");
                console.log('---MaterialItemsInCart---' + JSON.stringify(component.get("v.MaterialItemsInCart")));
                var alreadyInCart=[];
                var keyIds=[];
                if(selectedToCart!=null && selectedToCart!='undefined'){
                    //alert(123);
                    for(var i=0;i<selectedToCart.length;i++){          
                        var record={};
                        record[selectedToCart[i].key]=selectedToCart[i].value;
                        alreadyInCart.push(record);
                        keyIds.push(selectedToCart[i].key);
                    }                  
                    for(var key in materialItemMap){                      
                        if(!keyIds.includes(key)){
                            materialItemList.push({
                                key: key,
                                value: materialItemMap[key]
                            });                            
                        }
                        else{
                            materialItemMap[key].greycolor = 'green';
                            materialItemList.push({
                                key: key,
                                value: materialItemMap[key]
                            });
                        }
                    }
                }
                else{
                    //alert(456);
                    for(var key in materialItemMap){
                        materialItemList.push({
                            key: key,
                            value: materialItemMap[key]
                        });
                    }
                }
                // below logic if, else if, else added for serach functionality by manindra on 21 - 12 -2022
                var serachedfrom = component.get("v.homepagesearchvaluefrom");
                console.log('materialItemList show items === '+materialItemList+'\n');
                console.log('serachedfrom show items === '+serachedfrom+'\n');
                //  if(materialItemList && materialItemList.length > 0){
                if(materialItemList){
                    if(serachedfrom == 'MaterialItemSearch'){
                        console.log('if serachedfrom === '+serachedfrom+'\n');
                        console.log('if materialItemList === '+materialItemList+'\n');
                        console.log('MaterialItems === '+component.get("v.MaterialItems")+'\n');
                        component.set('v.boolval',true);
                        component.set('v.showhomepagesearchvalueitems',true); 
                    }
                    
                    else if(serachedfrom == 'MaterialItemSearchCarthold'){
                        console.log('else if serachedfrom === '+serachedfrom+'\n');
                        console.log('else if cart hold serachedfrom === '+serachedfrom+'\n');
                        console.log('else if cart hold  materialItemList === '+materialItemList+'\n');    
                        component.set('v.boolval',false);
                        component.set('v.showhomepagesearchvalueitems',false); 
                        component.set('v.carthold',true);
                        component.set('v.showhomepagesearchvalueitemscarthold',true);
                        component.set("v.showhomepagesearchvalueitemscartholdgrid",false);//added by manindra on 19 - 12 - 2022
                    }
                        else{
                            console.log('only else serachedfrom === '+serachedfrom+'\n');
                            console.log('only else  materialItemList === '+materialItemList+'\n');
                            console.log('only else  serachedfrom === '+component.get("v.MaterialItems")+'\n');
                            component.set('v.boolval',false); // here we need to check for that error
                            component.set('v.showhomepagesearchvalueitems',false); 
                            component.set('v.carthold',false);
                            component.set('v.showhomepagesearchvalueitemscarthold',false); 
                            component.set('v.ShowStoreSupplies',true); //Newly commented for new ui
                        }
                }
                else{
                    console.log('else === no records ');
                    component.set('v.boolval',true);
                    component.set('v.showhomepagesearchvalueitems',false); // added for serach functionality by manindra
                    component.set('v.ShowStoreSupplies',false); //Newly commented for new ui
                }
                console.log('materialItemList'+materialItemList.length);
                component.set("v.MaterialItems",materialItemList);
            }
        });
        $A.enqueueAction(getShowItems);
    },
    
    CreateJobswithchild : function(component, event, helper,combineStoreWrapper){
        console.log('---helpercalled---');
        component.set("v.isSpinner", true);
        var rcds = combineStoreWrapper;
        var createJobs=component.get("c.CreateJobswithchild");
        createJobs.setParams({
            CombineWrap : rcds
        });
        createJobs.setCallback(this, function(response) {
            if(response.getState()==='SUCCESS'){
                // alert('client contatcs size === '+response.getReturnValue());
                console.log('The response when place order === '+response.getReturnValue());  
                // alert('The response when place order === '+response.getReturnValue());                
                
                if(response.getReturnValue()=='success'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success",
                        "duration":'2000',
                        "message": "Order is submitted succesfully."
                    });
                    toastEvent.fire();
                    window.setTimeout(
                        $A.getCallback(function() {
                            var navigateEvent = $A.get("e.force:navigateToComponent");
                            navigateEvent.setParams({
                                componentDef: "c:JobsForClientContactLtCmp"
                            });
                            navigateEvent.fire();
                        }), 4000
                    );
                }
                
                else  if(response.getReturnValue()=='QuantityError'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": 'The Quantity must be less than Max Quantity of related Material Item.'
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
                }
                
                    else  if(response.getReturnValue()=='allitemsoutofstock'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type":"error",
                            "message": 'Order is not submitted succesfully.'
                        });
                        toastEvent.fire();
                        component.set("v.isSpinner", false);  
                    }
                
                /*   else  if(response.getReturnValue()=='You already placed an order for this item this week'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type":"error",
                            "message": 'District/Division Merch Manager/Division Director already placed this item within the last 5 business days.'
                        });
                        toastEvent.fire();
                        component.set("v.isSpinner", false);
                    }
                        else  if(response.getReturnValue()=='GM'){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "type":"error",
                                "message": 'General/Restaurant/Tire Shop Manager already placed an order less than 5 business days.'
                            });
                            toastEvent.fire();
                            component.set("v.isSpinner", false);
                        }*/
                        else{
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "type":"error",
                                "message":  'The following item has been ordered within the last 5 days - '+Response.getReturnValue()
                            });
                            toastEvent.fire();
                            component.set("v.isSpinner", false);
                        }
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": ''+Response.getReturnValue()
                });
                toastEvent.fire();
                component.set("v.isSpinner", false);
            }
        });
        $A.enqueueAction(createJobs);
    },
    
    // below new line added on 15 - 12 - 2022
    getclientrecordfromcartitemsrecord : function(component, event, helper){
        var cartrecords=component.get("c.getclientrecordfromcartitemsrecordmthd");
        cartrecords.setCallback(this, function(Response){
            var responseval  = Response.getReturnValue();
            console.log('getclientrecordfromcartitemsrecord responseval==='+Response.getReturnValue()+'\n');
            var clientrcd = responseval.clientrcd;
            console.log('clientrcd responseval==='+clientrcd+'\n');
            var miids = responseval.materialitemidswrap;
            console.log('miids responseval==='+miids+'\n');
            if(Response.getState()=='SUCCESS'){
                component.set("v.clientStoreList",clientrcd); //Here we are adding client to list
                this.getCombineList(component, event, helper,clientrcd,miids); 
            }
        });
        $A.enqueueAction(cartrecords);
    },
    
    getCombineList : function(component, event, helper,clientStoreSelectList,cartItemIds) {
        console.log('-clientStoreSelectList---'+JSON.stringify(clientStoreSelectList));
        console.log('-clientStoreSelectList without json---'+clientStoreSelectList);
        console.log('---cartItemIds---'+JSON.stringify(cartItemIds));
        console.log('---cartItemIds without json---'+cartItemIds);
        var combinedDataList=component.get("c.combinedDataList");
        combinedDataList.setParams({
            "clientStoreSelectList":clientStoreSelectList,
            "cartItemIds":cartItemIds
        });
        combinedDataList.setCallback(this, function(Response){
            if(Response.getState()=='SUCCESS'){
                component.set("v.combineStoreWrapper",Response.getReturnValue());
            }
        });
        $A.enqueueAction(combinedDataList);
    },
    
    getCombineListcheck : function(component, event, helper,clientStoreSelectList,cartItemIds) {
        console.log('-clientStoreSelectList---'+JSON.stringify(clientStoreSelectList));
        console.log('---cartItemIds---'+JSON.stringify(cartItemIds));
        var combinedDataList=component.get("c.combinedDataList");
        combinedDataList.setParams({
            clientStoreSelectList:clientStoreSelectList,
            cartItemIds:cartItemIds
        });
        combinedDataList.setCallback(this, function(Response){
            if(Response.getState()=='SUCCESS'){
                var cartrcds = Response.getReturnValue();
                console.log('cartrcds === '+JSON.stringify(cartrcds));
                this.submittocheckitems(component,event,helper,cartrcds);
            }
        });
        $A.enqueueAction(combinedDataList);
    },
    
    submittocheckitems : function(component,event,helper,cartItems){
        console.log('cart items submit to check === '+JSON.stringify(cartItems));
        component.set("v.isSpinner", false);
        var placeOrder=component.get("c.submitTocheck");
        placeOrder.setParams({
            CombineWrap:cartItems
        });
        placeOrder.setCallback(this, function(Response){
            console.log('----response---'+Response.getState());
            var toastEvent = $A.get("e.force:showToast");
            if(Response.getState()=='SUCCESS'){
                //  alert('----return value ---- '+Response.getReturnValue());
                /*   if(Response.getReturnValue()=='You already placed an order for this item this week'){
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": 'District/Division Merch Manager/Division Director already placed this item within the last 5 business days.'
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
                }
                else  if(Response.getReturnValue()=='GM'){
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": 'General/Restaurant/Tire Shop Manager already placed an order less than 5 business days.'
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
                   
                }*/
                if(Response.getReturnValue() == 'No records'){
                    this.addItemToCartfinal(component, event, helper);
                }
                else if(Response.getReturnValue() == 'QuantityError'){
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": 'The Quantity must be less than Max Quantity of related Material Item.'
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);  
                }
                    else{
                        toastEvent.setParams({
                            "title": "Error!",
                            "type":"error",
                            "duration":'1000',
                            "message":  'The following item has been ordered within the last 5 days - '+Response.getReturnValue()
                        });
                        toastEvent.fire();
                        component.set("v.isSpinner", false);
                    }
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": ''+Response.getReturnValue()
                });
                toastEvent.fire();
                component.set("v.isSpinner", false);
            }
        });
        $A.enqueueAction(placeOrder);
    },
    
    //below is to get cart items out of stock
    getoutofstock: function(component, event, helper){
        var action=component.get("c.getoutofstock");
        action.setCallback(this, function(Response){
            if(Response.getState()=='SUCCESS'){
                console.log('----response---'+Response.getReturnValue());
                var returnval = Response.getReturnValue();
                if(returnval == 'No cart item records'){
                    
                }
                else if(returnval != '' && returnval != null && returnval != 'undefined' && returnval != 'No cart item records'){
                    console.log('out of stock  === '+returnval);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "duration":'3000',
                        "message": returnval+" is out of stock"
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);   
                }
            }
        });  
        $A.enqueueAction(action);
    },
    
    //below is to chcking whether logged in user has cart items records or not
    checkcartitemrcds : function(component, event, helper){
        var action=component.get("c.checkcartitemrcds");
        action.setCallback(this, function(Response){
            if(Response.getState()=='SUCCESS'){
                console.log('----response---'+Response.getReturnValue());
                var returnval = Response.getReturnValue();
                if(returnval == true){
                    console.log('records are there');
                    this.getusercartitems(component,event,helper);
                }
                else{
                    console.log('No records');
                }
            }
        });  
        $A.enqueueAction(action);
    },
    
    //below is to getting logged in user cart items records adds to attribute.
    getusercartitems : function(component,event,helper){
        var materialItemList = [];
        var AddToCartItems=[];
        var keyids = [];
        var checkedCount=0;
        var alreadyInCart=component.get("v.MaterialItemsInCart");
        var selectedToCart=component.get("v.StoredMaterialItems");
        var cartids=component.get("v.cartitemids");
        console.log('cart ids === '+cartids);
        var action=component.get("c.getcartitemrcds");
        action.setCallback(this, function(Response){
            if(Response.getState()=='SUCCESS'){
                console.log('----response---'+JSON.stringify(Response.getReturnValue()));
                var materialItemMap=Response.getReturnValue();  
                for(var key in materialItemMap){
                    keyids.push(key);
                    if(!cartids.includes(key)){
                        materialItemList.push({
                            key : key,
                            value: materialItemMap[key]
                        });
                    }
                }
                //console.log('materialItemList length === '+materialItemList.length);            
                for(var i=0;i<materialItemList.length;i++){
                    var keyId=materialItemList[i].key;
                    //console.log('materialItemList  === '+JSON.stringify(materialItemList));            
                    if(materialItemList[i].value.checked==true){
                        if(!cartids.includes(keyId)){
                            // console.log('materialItemList  inside cart if === '+JSON.stringify(materialItemList)+'\n');            
                            AddToCartItems.push({
                                key:materialItemList[i].key,
                                value:materialItemList[i].value
                            });
                        }
                    }
                }
                console.log('AddToCartItems length === '+AddToCartItems.length);            
                
                if(alreadyInCart==null || alreadyInCart=='undefined'){          
                    alreadyInCart=AddToCartItems;
                }
                else{        
                    alreadyInCart=alreadyInCart.concat(AddToCartItems);
                }  
                
                console.log('AddToCartItems length after if === '+alreadyInCart.length);
                component.set("v.cartitemids",keyids);
                component.set("v.StoredMaterialItems",materialItemList);
                component.set("v.MaterialItemsInCart",alreadyInCart);
                //component.set("v.isStoreSupplies",false);      
                //component.set("v.ShowCartSection",true);
            }
            else{
                console.log('----response Error---'+Response.getState());
                //component.set("v.isStoreSupplies",false);      
                //component.set("v.ShowCartSection",true);
            }
        });
        $A.enqueueAction(action);
    },
    
    //below is to cart items records after added to cart capturing changes i.e., quantity and updating cart item records.
    updatecartitems : function(component, event, helper,miname,qty){
        console.log('material items === '+miname+' and qty given === '+qty);
        var matarialItemsQty=component.get("c.updatecartitemrcd");
        matarialItemsQty.setParams({
            "miname":miname,quantity:qty
        });
        matarialItemsQty.setCallback(this, function(Response){
            
            if(Response.getState()=='SUCCESS'){  
                //console.log('Cart items records updated === '+Response.getReturnValue());
            }
            else{
                //console.log('----response---'+Response.getReturnValue());
            }
        });
        $A.enqueueAction(matarialItemsQty);
    },
    
    //delete a cart items records when left from cart or clicking cancel button
    deletecartitemsrcds : function(component,event,helper){
        var action=component.get("c.deletecartitemrcdsforcancelbutton");
        
        action.setCallback(this, function(Response){
            if(Response.getState()=='SUCCESS'){ 
                console.log('----response---'+Response.getReturnValue());
                var returnval = Response.getReturnValue();
                if(returnval == 'deleted'){
                    console.log('records are deleted');
                }
                else{
                    console.log('records are not deleted');
                }
            }
        });  
        $A.enqueueAction(action);  
    },
    
    //delete a item when removes from cart
    deletecartitems :  function(component, event, helper,miname){
        var action=component.get("c.deletecartitemrcds");
        action.setParams({                                                  
            "minamedelval":miname
        });
        action.setCallback(this, function(Response){
            if(Response.getState()=='SUCCESS'){
                console.log('----response---'+Response.getReturnValue());
                var returnval = Response.getReturnValue();
                if(returnval == 'deleted'){
                    console.log('records are deleted');
                }
                else{
                    console.log('records are not deleted');
                }
            }
        });  
        $A.enqueueAction(action);  
    },
    
})