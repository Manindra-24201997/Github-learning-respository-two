({
    doInit : function(component, event, helper) {      
        
        helper.fetchMaterialItemOptions(component, event, helper);
        helper.checkcartitemrcds(component, event, helper);
        //helper.getShowItems(component, event, helper,'','');
        /*  var mTypeSelected=component.find('MaterialTypeString').get('v.value');          
        var mTypeInput=component.find('MaterialItemNameString').get('v.value');          
        if(mTypeSelected==null || mTypeSelected=='undefined'){
            component.set("v.slectedPickListValue",'');          
            component.set("v.enteredInputSearch",'');
        }else{
            component.set("v.slectedPickListValue",mTypeSelected);          
            component.set("v.enteredInputSearch",mTypeInput);
        } */
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        console.log('--isMobile'+isMobile);
        if(isMobile){
            component.set("v.isMobile",true);
        }
    },
    
    showSpinner: function(component, event, helper) {
        component.set("v.Loading", true);
    },
    
    hideSpinner : function(component,event,helper){
        component.set("v.Loading", false);
    },
    
    handleDiscard : function(component,event,helper){
        // alert('handleDiscard');
    },
    
    backToStoreFront :function(component, event, helper) { 
        var mc =   component.get("v.MaterialItemsInCart");
        if(mc){
            component.set("v.isStoreSupplies",false);
            component.set("v.cancelitems",true); 
        }
        else{
            var navigateEvent = $A.get("e.force:navigateToComponent");
            navigateEvent.setParams({
                componentDef: "c:StoreFrontNewView"
            });
            navigateEvent.fire();   
        }
    },
    
    backTohomepage :function(component, event, helper) { 
        component.set("v.cancelitems",false);
        component.set("v.cancelplaceditems",false);
        
        helper.deletecartitemsrcds(component,event,helper);
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "type":"error",
            "message": "Your order was cancelled."
        });
        toastEvent.fire();
        
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:StoreFrontNewView"
        });
        navigateEvent.fire();
    },
    
    backToexistedpage :function(component, event, helper) { 
        component.set("v.cancelitems",false);
        component.set("v.isStoreSupplies",true);
    },
    
    cancelorder : function(component, event, helper) {
        var mc =   component.get("v.MaterialItemsInCart");
        if(mc){
            component.set("v.ShowCartSection",false);
            component.set("v.cancelplaceditems",true); 
        }
        else{
            var navigateEvent = $A.get("e.force:navigateToComponent");
            navigateEvent.setParams({
                componentDef: "c:StoreFrontNewView"
            });
            navigateEvent.fire();   
        }
    },
    
    continuebackToStoreFrontforplaceorder : function(component, event, helper) { 
        component.set("v.cancelitems",false);
        component.set("v.ShowCartSection",false);
        component.set("v.cancelplaceditems",false);
        helper.deletecartitemsrcds(component,event,helper);
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "type":"error",
            "message": "Your order was cancelled."
        });
        toastEvent.fire();
        
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:StoreFrontNewView"
        });
        navigateEvent.fire();
    },
    
    backToexistedcartpage :function(component, event, helper) { 
        
        component.set("v.cancelitems",false);
        component.set("v.cancelplaceditems",false);
        component.set("v.isStoreSupplies",false);
        component.set("v.ShowCartSection",true);
    },
    
    onMiSelect : function(component, event, helper) {
        // var mTypeSelected=component.find('MaterialTypeString').get('v.value');//This commented newly
        component.set("v.showmaterialitems",true);// This line added on 18 - 08 - 2022 for back functionality and cart holding
        var mTypeSelected=event.target.id;
        /*var mitemcategorychanged=component.find('MaterialItemCategory').get('v.value');
        console.log('item category === '+mTypeSelected+'material item drop down === '+mitemcategorychanged);
        if(mitemcategorychanged){
            component.set("v.slectedPickListValue",mitemcategorychanged);
            helper.getShowItems(component, event, helper,mitemcategorychanged,'');   
        }
        else{
            component.set("v.slectedPickListValue",mTypeSelected);
            helper.getShowItems(component, event, helper,mTypeSelected,'');  
        }*/
        component.set("v.slectedPickListValue",mTypeSelected);
        helper.getShowItems(component, event, helper,mTypeSelected,'');  
    },
    
    onMiSelectCarthold :function(component, event, helper) {
        component.set("v.showmaterialitems",true);// This line added on 18 - 08 - 2022 for back functionality and cart holding
        // var mTypeSelected=component.find('MaterialTypeString').get('v.value');//This commented newly
        var mTypeSelected=event.target.id;
        component.set("v.slectedPickListValue",mTypeSelected);
        /*var mitemcategorychanged=component.find('MaterialItemCategorycarthold').get('v.value');
                console.log('item category === '+mTypeSelected+'material item drop down by cart hold === '+mitemcategorychanged);
         if(mitemcategorychanged){
            component.set("v.slectedPickListValue",mitemcategorychanged);
            helper.getShowItems(component, event, helper,mitemcategorychanged,'');   
        }
        else{
            component.set("v.slectedPickListValue",mTypeSelected);
            helper.getShowItems(component, event, helper,mTypeSelected,'');  
        }*/
        /*var mTypeInput=component.find('MaterialItemNameString').get('v.value'); //This commented newly
        if(mTypeInput!=null && mTypeInput !='undefined'){
            component.set("v.enteredInputSearch",mTypeInput);
        }*/
        console.log('item category === '+mTypeSelected);
        component.set("v.carthold",false);// This line added on 18 - 08 - 2022 for back functionality and cart holding
        component.set('v.showbackbtn',false);// This line added on 18 - 08 - 2022 for back functionality and cart holding 
        helper.getShowItems(component, event, helper,mTypeSelected,'');  
        
    },
    
    onMisearchname : function(component, event, helper) {
        var mTypeSelected = component.get("v.slectedPickListValue");
        var mTypeInput = component.find('MaterialItemNameString').get('v.value');
        console.log('item category === '+mTypeSelected+' and search name is === '+mTypeInput);
        if(mTypeInput!=null && mTypeInput !='undefined'){
            component.set("v.enteredInputSearch",mTypeInput);
        }
        helper.getSearchItems(component, event, helper,mTypeSelected,mTypeInput);  
    },
    
    // The below function added on 18 - 08 - 2022 for back functionality and cart holding
    DisplayItemCategory : function(component, event, helper) {
        //alert('DisplayItemCategory');
        //component.set("v.slectedPickListValue",'');
        component.set("v.showmaterialitems",false);
        component.set("v.carthold",true);
        component.set('v.showbackbtn',true); 
    },
    
    onCheck : function(component, event, helper){
        var AddToCartItems=[];
        var selectedToCart=component.get("v.MaterialItems");
        for(var i=0;i< selectedToCart.length;i++){
            var keyId=selectedToCart[i].key;
            if(selectedToCart[i].value.checked==true){
                //alert(selectedToCart[i].value.MI.Name);
                /* AddToCartItems.push({
                    key:selectedToCart[i].key,
                    value:selectedToCart[i].value
                }); */
                AddToCartItems.push(selectedToCart[i].value);
            }
        }
        //helper.submittocheckitems(component, event, helper,AddToCartItems);
    },
    
    addItemToCart : function(component, event, helper){
        helper.addItemToCartchecking(component, event, helper);  
    },
    
    
    goToCart : function(component, event, helper){
        // helper.checkcartitemrcds(component, event, helper);
        var alreadyInCart=component.get("v.MaterialItemsInCart");
        if(alreadyInCart){
            component.set("v.isStoreSupplies",false);      
            component.set("v.ShowCartSection",true);
        }
        else{
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "No items in cart."
            });
            toastEvent.fire();   
        }
    },
    
    continueShopping : function(component, event, helper){        
        
        var oldSelectedValue=component.get("v.slectedPickListValue");
        // var oldEnteredInput=component.get("v.enteredInputSearch"); // Newly commented
        component.set("v.ShowCartSection",false);
        //helper.getShowItems(component, event, helper,oldSelectedValue,oldEnteredInput); //Newly commented
        
        component.set("v.showmaterialitems",false);// This line added on 25 - 08 - 2022
        component.set("v.MaterialItems",null);// This line added on 25 - 08 - 2022
        component.set("v.showmicategory",false);// This line added on 06 - 10 - 2022
        component.set("v.isStoreSupplies",true);  // This line changed on 06 - 10 - 2022
        component.set("v.carthold",true);// This line added on 06 - 10 - 2022
        component.set('v.showbackbtn',true);// This line added on 25 - 08 - 2022
        //helper.getShowItems(component, event, helper,oldSelectedValue);
        
        //component.find("MaterialTypeString").set("v.value",oldSelectedValue); //Newly commented
        // component.find("MaterialItemNameString").set("v.value",oldEnteredInput);Newly commented
    },
    
    RemoveFromCartSection : function(component, event, helper){
        var ctarget = event.currentTarget;
        console.log('--ctarget-'+ctarget);
        var mob=component.get("v.isMobile");
        var index;
        console.log('--name----'+mob);
        if(mob==true){
            console.log('--ctarget.name----'+event.getSource().get("v.name"));
            index=event.getSource().get("v.name");
        }
        else{
            index = ctarget.dataset.value;
            
        }
        console.log('--index-'+index);
        var itemsToRemove=component.get("v.MaterialItemsInCart"); 
        var getminame = itemsToRemove[index].value.MI.Name;
        itemsToRemove.splice(index, 1);
        component.set("v.MaterialItemsInCart",itemsToRemove);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The item has been removed successfully."
        });
        toastEvent.fire();
        if(getminame){
            helper.deletecartitems(component,event,helper,getminame);
        }
    },
    
    checkQuantity : function(component, event, helper){
        var inputvalue=event.getSource().get("v.value");
        console.log('--inputvalue---'+inputvalue);
        var defineval = 1;
        var maxQtyId=event.getSource().get("v.labelClass");          
        var maxQtyValue=document.getElementById(maxQtyId+'maxQty').innerText;
        console.log('--maxQtyValue---'+maxQtyValue);
        var materialitemsincart = component.get("v.MaterialItemsInCart");
        var materialitemsrcdincart = materialitemsincart[maxQtyId].value.MI.Name;
        console.log('materialitemsrcdincart ==== '+materialitemsrcdincart);
        if(inputvalue=='' || inputvalue=='0' ||  inputvalue=='00'){          
            event.getSource().set('v.value',1);
            $A.util.removeClass(document.getElementById(maxQtyId+'qty'),'addRed');
            document.getElementById(maxQtyId+'erMsg').setAttribute('style','display:none');
            helper.updatecartitems(component,event,helper,materialitemsrcdincart,defineval);
        }
        else if(Number(inputvalue)>Number(maxQtyValue)){
            $A.util.addClass(document.getElementById(maxQtyId+'qty'), 'addRed');
            document.getElementById(maxQtyId+'erMsg').setAttribute('style','display:;color:red;white-space:pre-wrap;');
        }    
            else{          
                $A.util.removeClass(document.getElementById(maxQtyId+'qty'),'addRed');
                document.getElementById(maxQtyId+'erMsg').setAttribute('style','display:none');
                helper.updatecartitems(component,event,helper,materialitemsrcdincart,inputvalue);
            }
        
    },
    
    placeOrder : function(component, event, helper){
        var cartItems=component.get("v.MaterialItemsInCart");
        var materialItems=[];
        for(var i=0;i<cartItems.length;i++){
            materialItems.push(cartItems[i].value);
        }
        console.log('---cartItesm---'+JSON.stringify(materialItems));        
        helper.submitToPlaceOrder(component, event, helper,materialItems);
    },
    
    req : function(component,event,helper){
        // alert( event.target.id);
    }
    
})