({
    fetchMaterialItemOptions : function(component, event, helper) {
        var matarialItems=component.get("c.getMaterialType");
        matarialItems.setParams({                                                   //This newly added
            materialitemcategory : null
        });
        matarialItems.setCallback(this, function(Response){
            console.log('----response---'+JSON.stringify(Response.getReturnValue()));
            if(Response.getState()=='SUCCESS'){              
                component.set("v.MaterialType",Response.getReturnValue());
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
    
    getShowItems : function(component, event, helper,mTypeSelected,mTypeInput) {
        //alert(mTypeSelected );
        component.set("v.showbackbtn",false);// This line added on 18 - 08 - 2022 for back functionality and cart holding 
        var getShowItems=component.get("c.ShowItems");
        getShowItems.setParams({                                       //This commented newly
            "MaterialItemNameString" : mTypeInput,
            "MaterialTypeString" : mTypeSelected
        });
        /*getShowItems.setParams({                                                   //This newly added
            MaterialTypeString : mTypeSelected
        });*/
        getShowItems.setCallback(this, function(Response){
            var materialItemList=[];
            var materialItemListagain=[];
            if(Response.getState()=='SUCCESS'){
                var materialItemMap=Response.getReturnValue();   
                //alert('materialItemMap === '+materialItemMap);
                for(var key in materialItemMap){ 
                    materialItemListagain.push({
                        key : key,
                        value: materialItemMap[key] 
                    });
                }
                if(materialItemListagain.length <= 0 ){
                    console.log('materialItemListagain --- '+materialItemListagain.length);
                    var toastEvent = $A.get("e.force:showToast"); 
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "duration":'3000',
                        "message": "There are No Storefront Items in this category"
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
                }
                var selectedToCart=component.get("v.MaterialItemsInCart");
                //console.log('---MaterialItemsInCart---' + JSON.stringify(selectedToCart));
                var alreadyInCart=[];
                var keyIds=[];
                if(selectedToCart!=null && selectedToCart!='undefined'){
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
                    for(var key in materialItemMap){
                        materialItemList.push({
                            key: key,
                            value: materialItemMap[key]
                        });
                    }
                }
                if(materialItemList && materialItemList.length > 0){
                    component.set('v.showmicategory',false);
                    component.set('v.showmaterialitems',true); //Newly commented for new ui
                    
                }
                else{
                    component.set('v.showmaterialitems',false); //Newly commented for new ui
                    component.set('v.showmicategory',false);
                    component.set('v.carthold',true);
                }
                component.set("v.MaterialItems",materialItemList);
            }
        });
        $A.enqueueAction(getShowItems);
    },
    
    getSearchItems : function(component, event, helper,mTypeSelected,mTypeInput) {
        //alert(mTypeSelected );
        component.set("v.showbackbtn",false);// This line added on 18 - 08 - 2022 for back functionality and cart holding 
        var SearchItems=component.get("c.ShowItems");
        SearchItems.setParams({                                       //This commented newly
            "MaterialItemNameString" : mTypeInput,
            "MaterialTypeString" : mTypeSelected
        });
        
        SearchItems.setCallback(this, function(Response){
            var materialItemList=[];
            var materialItemListagain=[];
            if(Response.getState()=='SUCCESS'){
                var materialItemMap=Response.getReturnValue();   
                //alert('materialItemMap === '+materialItemMap);
                for(var key in materialItemMap){ 
                    materialItemListagain.push({
                        key : key,
                        value: materialItemMap[key] 
                    });
                }
                
                var selectedToCart=component.get("v.MaterialItemsInCart");
                //console.log('---MaterialItemsInCart---' + JSON.stringify(selectedToCart));
                var alreadyInCart=[];
                var keyIds=[];
                if(selectedToCart!=null && selectedToCart!='undefined'){
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
                    for(var key in materialItemMap){
                        materialItemList.push({
                            key: key,
                            value: materialItemMap[key]
                        });
                    }
                }
                
                if(materialItemList && materialItemList.length > 0){
                    component.set('v.showmicategory',false);
                    component.set('v.showmaterialitems',true); //Newly commented for new ui
                    
                }
                else{
                    var toastEvent = $A.get("e.force:showToast"); 
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "duration":'3000',
                        "message": "No records found."
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
                    component.set('v.showmicategory',false);
                    component.set('v.carthold',false);
                    component.set('v.showmaterialitems',true); //Newly commented for new ui
                }
                component.set("v.MaterialItems",materialItemList);
            }
        });
        $A.enqueueAction(SearchItems);
    },
    
    //below to set user cart items records to materialitemasincart attribute when this component opens
    
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
                // component.set("v.isStoreSupplies",false);      
                //component.set("v.ShowCartSection",true);
            }
            else{
                console.log('----response Error---'+Response.getState());
                //component.set("v.isStoreSupplies",false);      
                // component.set("v.ShowCartSection",true);
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
                console.log('Cart items records updated === '+Response.getReturnValue());
            }
            else{
                console.log('----response---'+Response.getReturnValue());
            }
        });
        $A.enqueueAction(matarialItemsQty); 
    },
    
    //below to checking selected items are ordered or not
    addItemToCartchecking : function(component,event,helper){
        var AddToCartItems=[];
        var selectedToCart=component.get("v.MaterialItems");
        for(var i=0;i< selectedToCart.length;i++){
            var keyId=selectedToCart[i].key;
            if(selectedToCart[i].value.checked==true){
                AddToCartItems.push(selectedToCart[i].value);
            }
        }
        if(AddToCartItems || AddToCartItems.length > 0 ){
            this.submittocheckitems(component,event,helper,AddToCartItems);
        }
    },
    
    //below to checking selected items are ordered.If records existes displaying error message or adding to cart.
    submittocheckitems : function(component,event,helper,cartItems){
        component.set("v.isSpinner", false);
        var placeOrder=component.get("c.submitTocheck");
        placeOrder.setParams({
            "cartItems":cartItems
        });
        placeOrder.setCallback(this, function(Response){
            console.log('----response---'+Response.getState());
            var toastEvent = $A.get("e.force:showToast");
            if(Response.getState()=='SUCCESS'){
                // alert('----return value ---- '+Response.getReturnValue());
                //New logic added on 12 - 04 - 2022 for Same material item selecting with in a week.
                /*  if(Response.getReturnValue() == 'You already placed an order for this item this week'){
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "duration":'1000',
                        "message": 'General/Restaurant/Tire Shop Manager already ordered this item within the last 5 business days'
                    });
                    toastEvent.fire();
                   
                    component.set("v.isSpinner", false);
                    
                }
                else if(Response.getReturnValue() == 'DM'){
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "duration":'1000',
                        "message": 'District/Division Merch Manager/Division Director already placed an order less than 5 business days'
                    });
                    toastEvent.fire();
                   
                    component.set("v.isSpinner", false);
                }*/
                if(Response.getReturnValue() == 'No records'){
                    this.addItemToCart(component, event, helper); 
                }
                else if(Response.getReturnValue() == 'QuantityError'){
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "duration":'3000',
                        "message": "The Quantity must be less than Max Quantity of Material Item."
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
        });
        $A.enqueueAction(placeOrder);
    },
    
    //below is adding to cart
    addItemToCart : function(component, event, helper){
        var selectedToCart=component.get("v.MaterialItems");
        var alreadyInCart=component.get("v.MaterialItemsInCart");  
        var MaterialItemsArray=[];
        var keyIds=[];
        var AddToCartItems=[];
        var checkedCount=0;  
        var materialItemList=[];
        var val = '';
        
        for(var i=0;i<selectedToCart.length;i++){          
            var record={};
            record[selectedToCart[i].key]=selectedToCart[i].value;
            MaterialItemsArray.push(record);
        }
        
        if(alreadyInCart){
            for(var i=0;i<alreadyInCart.length;i++){          
                keyIds.push(alreadyInCart[i].key);
            } 
        }
        console.log('keyIds === '+keyIds.length);
        
        for(var i=0;i<selectedToCart.length;i++){
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
                
                //console.log('greycolor === '+MaterialItemsArray[i][keyId].greycolor);
                //delete MaterialItemsArray[i][keyId]; // commented on 26 - 08 -2022
                MaterialItemsArray.push(MaterialItemsArray[i][keyId].greycolor= 'green');
            }
        }  
        val = val.substring(0, val.length - 1);
        // console.log('MaterialItemsArray === '+JSON.stringify(MaterialItemsArray)+'\n');
        //console.log('MaterialItemsArray again=== '+MaterialItemsArray.length);
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
        //var unsaved = component.find("unsaved");
        if(checkedCount>0){   
            // unsaved.setUnsavedChanges(true, { label: 'cart' });
            component.set("v.MaterialItemsInCart",alreadyInCart);
            component.set("v.MaterialItems",selectedToCart);
            console.log('-- checkedCount'+checkedCount);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "type":"success",
                "message": checkedCount+" Items were added to the Cart."
            });
            toastEvent.fire();
            component.set("v.isStoreSupplies",false);      
            component.set("v.ShowCartSection",true);
            var isiPad = /iPad|iPod|Android/i.test(navigator.userAgent);
            console.log('--isiPad'+isiPad);
            if(isiPad){
                component.set("v.isIpad",true);
            }
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
    
    //submits order
    submitToPlaceOrder : function(component, event, helper,cartItems){
        //alert('working === '+JSON.stringify(cartItems));
        component.set("v.isSpinner", true);
        var placeOrder=component.get("c.submitToPlaceOrder");
        placeOrder.setParams({
            "cartItems":cartItems
        });
        placeOrder.setCallback(this, function(Response){
            console.log('----response---'+Response.getState());
            var toastEvent = $A.get("e.force:showToast");
            if(Response.getState()=='SUCCESS'){
                //alert('----return value ---- '+Response.getReturnValue());
                console.log('The response when place order === '+Response.getReturnValue());                
                if(Response.getReturnValue()=='QuantityError'){
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "duration":'3000',
                        "message": "The Quantity must be less than Max Quantity of Material Item."
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
                }
                //New logic added on 12 - 04 - 2022 for Same material item selecting with in a week.
                /*if(Response.getReturnValue() == 'You already placed an order for this item this week'){
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "duration":'3000',
                        "message": 'General/Restaurant/Tire Shop Manager already ordered this item within the last 5 business days.'
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
                }
                if(Response.getReturnValue() == 'DM'){
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "duration":'3000',
                        "message": 'District/Division Merch Manager/Division Director already placed an order less than 5 business days.'
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
                }*/
                else if(Response.getReturnValue()=='success'){
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success",
                        "message": "Your order has been placed succesfully."
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
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Something went wrong!. Please contact system admin"
                });
                toastEvent.fire();
                component.set("v.isSpinner", false);
            }
        });
        $A.enqueueAction(placeOrder);
    },
    
})