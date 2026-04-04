({
    doInit : function(component, event, helper) {        
        
        helper.fecthTableData(component, event, helper);
        helper.fetchMaterialItemOptions(component, event, helper);
        helper.checkcartitemrcds(component, event, helper);
        //  helper.getShowItems(component, event, helper,'',''); // Here commented for new ui.
        console.log('---doInit---');
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
    
    backToStoreFront :function(component, event, helper) {  
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:StoreFrontNewView"
        });
        navigateEvent.fire();
    },
    
    
    backToStores :function(component, event, helper) {  
        //The below added commented on 19 - 08 - 2022 for cart hold functionality
        // alert('back button on item category');
        component.set("v.MaterialItems",null);
        component.set("v.boolval",false);
        //component.set("v.ShowCombineList",false);
        component.set("v.carthold",false);
        component.set("v.ShowStoreSupplies",false);
        component.set("v.ShowStoreList",true);
    },
    
    backToformpage :function(component, event, helper) {  
        //The below added commented on 29 - 08 - 2022 for cart hold functionality
        var mc =  component.get("v.MaterialItemsInCart");
        if(mc){
            component.set("v.ShowCombineList",false);
            component.set("v.cancelitems",true);
        }
        
    },
    
    backTohomepage :function(component, event, helper) {  
        helper.deletecartitemsrcds(component,event,helper);
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "type":"error",
            "message": "Your cart items not placed."
        });
        toastEvent.fire();
        
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:StoreFrontNewView"
        });
        navigateEvent.fire();
    },
    
    backToexistedpage : function(component, event, helper) {  
        component.set("v.ShowCombineList",true);
        component.set("v.cancelitems",false);
    },
    
    // logic added here on 28 - 03 - 2022
    onCheck : function(component, event, helper) {
        // alert('onCheck');
        var  selectedRowsToNext=component.get("v.CWrap");
        var selectStore=0;
        for(var i=0;i<selectedRowsToNext.length;i++){
            if(selectedRowsToNext[i].varCSelect==true){
                selectStore=selectStore+1;
            }
        }
        if(selectStore>1){ // logic added here on 28 - 03 - 2022
            console.log('selected store greater than two');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Only 1 store can be selected per order."
            });
            toastEvent.fire();
        }
    },
    
    ShowStoreSuppliesLayout : function(component, event, helper) {        
        //console.log('--selectedRowsToNext--'+JSON.stringify(selectedRowsToNext));
        var  selectedRowsToNext=component.get("v.CWrap");
        var selectStore=0;
        var clientStoreSelectList=[];
        for(var i=0;i<selectedRowsToNext.length;i++){
            if(selectedRowsToNext[i].varCSelect==true){
                selectStore=selectStore+1;
                clientStoreSelectList.push(selectedRowsToNext[i].varClient);
            }
        }
        if(selectStore>0 && selectStore < 2){  // logic added here on 28 - 03 - 2022 before it is selectStore>0 only.
            component.set('v.ShowStoreList',false);
            component.set("v.ShowStoreSupplies",false);
            component.set("v.carthold",false);
            component.set('v.boolval',true);
            component.set('v.clientStoreList',clientStoreSelectList);
            //   component.set('v.ShowStoreSupplies',true); /Newly commented for new ui
            /*console.log('---clients---'+JSON.stringify(component.get('v.clientStoreList')));
             console.log('input search--'+component.get("v.enteredInputSearch"));
            console.log('select search--'+component.get("v.slectedPickListValue"));*/
            
            /* The below logic was newly commented*/
            
            /*  var mInputString=component.get("v.enteredInputSearch");
            var selectInput=component.get("v.slectedPickListValue");
            if(mInputString==null || mInputString=='undefined'){
                component.find('MaterialNameID').set('v.value','')
            }
            else{
                component.find('MaterialNameID').set('v.value',mInputString);
            }
            if(selectInput==null || selectInput=='undefined'){
                component.find('MaterialTypeID').set('v.value','')
            }
            else{
                component.find('MaterialTypeID').set('v.value',selectInput);
            }*/
            
            /* var mTypeSelected=component.find('MaterialTypeID').get('v.value');          
            var mTypeInput=component.find('MaterialNameID').get('v.value');          
            if(mTypeSelected==null || mTypeSelected=='undefined'){
                component.set("v.slectedPickListValue",'');          
                component.set("v.enteredInputSearch",'');
            }else{
                component.set("v.slectedPickListValue",mTypeSelected);          
                component.set("v.enteredInputSearch",mTypeInput);
            }    */      
            
        }
        else if(selectStore>1){ // logic added here on 28 - 03 - 2022
            console.log('selected store greater than two');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Only 1 store can be selected per order."
            });
            toastEvent.fire();
        }
            else{
                console.log('list empty');
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Please select atleast one store."
                });
                toastEvent.fire();
            }
        console.log('----show-material-');
    },
    
    backLayout : function(component, event, helper) {   
        //alert('backLayout');
        var alreadyInCart=component.get("v.MaterialItemsInCart");
        // alert('backLayout'+alreadyInCart);
        if(alreadyInCart==null || alreadyInCart=='undefined' || !alreadyInCart){
            //component.set("v.showstorebackbutton",true);
            component.set('v.ShowStoreSupplies',false);  // changeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
            component.set("v.carthold",true);
        }
        else{
            component.set('v.carthold',true);  // Here we added  on 03 - 10 - 2022 
            component.set('v.ShowStoreSupplies',false);
            component.set("v.ShowAddCartSection",false);
            component.set('v.ShowStoreList',false);       // Here we changed to false  on 03 - 10 - 2022 
            component.set("v.showstorebackbutton",false);
        }
    },
    
    //The below function added on 19 - 08 - 2022 for cart hold functionality
    backLayoutitemcategory : function(component, event, helper) { 
        // alert('backLayoutitemcategory');
        var alreadyInCart=component.get("v.MaterialItemsInCart");
        // alert('backLayoutitemcategory'+alreadyInCart);
        component.set("v.ShowStoreSupplies",false);
        component.set("v.ShowAddCartSection",false);
        component.set('v.ShowStoreList',false);
        component.set("v.carthold",true);
    },
    
    onMiSelect :function(component, event, helper) {
        // var mTypeSelected=component.find('MaterialTypeID').get('v.value');//This commented newly
        var mTypeSelected=event.target.id;
        component.set("v.slectedPickListValue",mTypeSelected);
        helper.getShowItems(component, event, helper,mTypeSelected,'');
        /*var mitemcategorychanged=component.find('MaterialItemCategory').get('v.value');
        console.log('item category === '+mTypeSelected+'material item drop down === '+mitemcategorychanged);
        if(mitemcategorychanged){
            component.set("v.slectedPickListValue",mitemcategorychanged);
            helper.getShowItems(component, event, helper,mitemcategorychanged,'');   
        }
        else{
            component.set("v.slectedPickListValue",mTypeSelected);
            helper.getShowItems(component, event, helper,mTypeSelected,'');  
        } */
        /*  if(mTypeInput!=null && mTypeInput !='undefined'){ //This commented newly
            component.set("v.enteredInputSearch",mTypeInput);
        }*/
    },
    
    //The below function added on 19 - 08 - 2022 for cart hold functionality
    onMiSelectCarthold :function(component, event, helper) {
        component.set("v.carthold",false);
        // var mTypeSelected=component.find('MaterialTypeID').get('v.value');//This commented newly
        // var mTypeInput=component.find('MaterialNameID').get('v.value');  //This commented newly
        var mTypeSelected=event.target.id;
        component.set("v.slectedPickListValue",mTypeSelected);
        helper.getShowItems(component, event, helper,mTypeSelected,'');  
        /*var mitemcategorychanged=component.find('MaterialItemCategorycarthold').get('v.value');
        console.log('onMiSelectCarthold item category === '+mTypeSelected+'material item drop down === '+mitemcategorychanged);
        if(mitemcategorychanged){
            component.set("v.slectedPickListValue",mitemcategorychanged);
            helper.getShowItems(component, event, helper,mitemcategorychanged,'');   
        }
        else{
            component.set("v.slectedPickListValue",mTypeSelected);
            helper.getShowItems(component, event, helper,mTypeSelected,'');  
        } */
        /*  if(mTypeInput!=null && mTypeInput !='undefined'){ //This commented newly
            component.set("v.enteredInputSearch",mTypeInput);
        }*/
        
    },
    
    onMisearchname : function(component, event, helper) {
        var mTypeSelected = component.get("v.slectedPickListValue");
        var mTypeInput = component.find('MaterialItemNameString').get('v.value');
        console.log('onMisearchname item category === '+mTypeSelected+'onMisearchname and search name is === '+mTypeInput);
        if(mTypeInput!=null && mTypeInput !='undefined'){
            component.set("v.enteredInputSearch",mTypeInput);
        }
        helper.getShowItems(component,event,helper,mTypeSelected,mTypeInput);  
    },
    
    goToCart : function(component, event, helper){
        var alreadyInCart=component.get("v.MaterialItemsInCart");
        
        if(alreadyInCart){
            component.set("v.ShowStoreSupplies",false);
            component.set("v.ShowStoreList",false);
            component.set("v.ShowCombineList",false);
            component.set("v.carthold",false);
            component.set("v.boolval",false); // 29 - 08 - 2022
            component.set("v.ShowAddCartSection",true);
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
    
    RemoveFromCartSection : function(component, event, helper){
        var ctarget = event.currentTarget;
        console.log('--ctarget-'+ctarget);
        var index = ctarget.dataset.value;
        console.log('--index-'+index);
        var itemsToRemove=component.get("v.MaterialItemsInCart");  
        var getminame = itemsToRemove[index].value.MI.Name;
        itemsToRemove.splice(index, 1);
        component.set("v.MaterialItemsInCart",itemsToRemove);
        if(getminame){
            helper.deletecartitems(component,event,helper,getminame);
        }
    },
    
    continueShopping : function(component, event, helper){        
        
        var oldSelectedValue=component.get("v.slectedPickListValue");        
        //  var oldEnteredInput=component.get("v.enteredInputSearch"); // Newly commented
        
        /*   if(oldSelectedValue==null || oldSelectedValue=='undefined'){ // Newly commented
            oldSelectedValue='';
        }
         if(oldEnteredInput==null || oldEnteredInput=='undefined'){
            oldEnteredInput='';
        }*/
        component.set("v.ShowAddCartSection",false);
        
        component.set("v.ShowStoreSupplies",false);// This line added on 19 - 08 - 2022 for back functionality and cart holding
        component.set("v.showstorebackbutton",false);// This line added on 19 - 08 - 2022 for back functionality and cart holding
        component.set("v.carthold",true);// This line added on 19 - 08 - 2022 for back functionality and cart holding
        /*  component.find("MaterialTypeID").set("v.value",oldSelectedValue);
        component.find("MaterialNameID").set("v.value",oldEnteredInput);   */ // Newly commented
        console.log('---continue- ctrl--');
        // helper.getShowItems(component, event, helper,oldSelectedValue);// Newly commented on 29 - 08 - 2022
    },
    
    goToCombineLayout : function(component, event, helper){
        // alert('Next');
        let cartLength=component.get("v.MaterialItemsInCart");
        let cartItemsIds=[];
        for(var i=0;i<cartLength.length;i++){          
            cartItemsIds.push(cartLength[i].key);
        }        
        if(cartLength.length>0){
            component.set("v.ShowAddCartSection",false);
            component.set("v.ShowCombineList",true);
            let clientStoreSelectList= component.get('v.clientStoreList');  
            helper.getCombineList(component, event, helper,clientStoreSelectList,cartItemsIds);
        }
        else{
            console.log('list empty');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Cart is empty Please add items to cart."
            });
            toastEvent.fire();
        }    
        
    },
    
    backToCart: function(component, event, helper){
        component.set("v.ShowAddCartSection",true);
        component.set("v.ShowCombineList",false);
    },
    
    checkQuantity : function(component, event, helper){
        var inputvalue=event.getSource().get("v.value");
        console.log('--inputvalue---'+inputvalue);
        var divQtyid=event.getSource().get("v.name");          
        var divDataValue=document.getElementById(divQtyid).getAttribute("data-value");  
        console.log('--divDataValue---'+divDataValue);
        var divDataRec=document.getElementById(divQtyid).getAttribute("data-record");
        console.log('--divDataRec---'+divDataRec);
        var mxQtyId=divDataRec+'maxQty'+divDataValue;
        var mxQtyValue=document.getElementById(mxQtyId).innerText;
        var erMsgId=divDataRec+'erMsg'+divDataValue;
        var emptyMsgId=divDataRec+'emptyMsg'+divDataValue;
        console.log('-before ---if-----mxQtyValue---'+mxQtyValue+'---inputvalue--'+inputvalue);
        console.log('divQtyid === '+divQtyid);
        var materialitemsincart = component.get("v.MaterialItemsInCart");
        console.log('materialitemsrcdincart ==== '+JSON.stringify(materialitemsincart[divDataValue].value.MI.Name));
        var materialitemsrcdincart = materialitemsincart[divDataValue].value.MI.Name;
        if(inputvalue=='' || inputvalue=='0'){          
            event.getSource().set('v.value',1);
            $A.util.removeClass(document.getElementById(divQtyid),'addRed');
            document.getElementById(erMsgId).setAttribute('style','display:none');
            helper.updatecartitems(component,event,helper,materialitemsrcdincart,defineval);
            
        }
        else if(Number(inputvalue)>Number(mxQtyValue)){
            console.log('-if-----mxQtyValue---'+mxQtyValue+'---inputvalue--'+inputvalue);
            $A.util.addClass(document.getElementById(divQtyid), 'addRed');
            document.getElementById(erMsgId).setAttribute('style','display:;color:red;white-space:pre-wrap;');
        }  
            else{      
                console.log('-else-----mxQtyValue---'+mxQtyValue+'---inputvalue--'+inputvalue);
                $A.util.removeClass(document.getElementById(divQtyid),'addRed');
                document.getElementById(erMsgId).setAttribute('style','display:none');
                helper.updatecartitems(component,event,helper,materialitemsrcdincart,inputvalue);
                
            }
        
    },
    
    submitOrder : function(component, event, helper){
        var  combineStoreWrapper=component.get("v.combineStoreWrapper");
        console.log('--combineStoreWrapper---'+JSON.stringify(combineStoreWrapper));
        helper.CreateJobswithchild(component, event, helper,combineStoreWrapper);
    },
    
    onCheckitem : function(component, event, helper){
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
    
    /*addItemToCart : function(component, event, helper){
         var selectedToCart=component.get("v.MaterialItems");
        var alreadyInCart=component.get("v.MaterialItemsInCart");  
        var AddToCartItems=[];
        var MaterialItemsArray=[];
        var checkedCount=0;  
        var materialItemList=[];      
        for(var i=0;i<selectedToCart.length;i++){          
            var record={};
            record[selectedToCart[i].key]=selectedToCart[i].value;
            MaterialItemsArray.push(record);
        }      
        for(var i=0;i< selectedToCart.length;i++){
            var keyId=selectedToCart[i].key;
            if(selectedToCart[i].value.checked==true){              
                checkedCount=checkedCount+1;
                AddToCartItems.push({
                    key:selectedToCart[i].key,
                    value:selectedToCart[i].value
                });                
                //delete MaterialItemsArray[i][keyId];    // commented on 29 - 08 -2022
                MaterialItemsArray.push( MaterialItemsArray[i][keyId].greycolor= 'green');          
            }
        }
       
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
            component.set("v.ShowStoreSupplies",false);
            component.set("v.ShowStoreList",false);
            component.set("v.ShowCombineList",false);
            component.set("v.ShowAddCartSection",true);            
            component.set("v.MaterialItemsInCart",alreadyInCart);
            component.set("v.MaterialItems",selectedToCart);            
        }        
        else{
            console.log('list empty');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Please select atleast one Material Item."
            });
            toastEvent.fire();
        }
        console.log('---adcart---');
    }*/
    
    addItemToCart : function(component, event, helper){
        var selectedToCart=component.get("v.MaterialItems");
        var alreadyInCart=component.get("v.MaterialItemsInCart");  
        var AddToCartItems=[];
        let cartItemsIds=[];
        for(var i=0;i< selectedToCart.length;i++){
            var keyId=selectedToCart[i].key;
            if(selectedToCart[i].value.checked==true){
                AddToCartItems.push({
                    key:selectedToCart[i].key,
                    value:selectedToCart[i].value
                });    
                cartItemsIds.push(selectedToCart[i].key);
            }
        }
        //delete MaterialItemsArray[i][keyId];    // commented on 29 - 08 -2022
        if(AddToCartItems.length>0){
            let clientStoreSelectList= component.get('v.clientStoreList');  
            helper.getCombineListcheck(component, event, helper,clientStoreSelectList,cartItemsIds);
        }
        else{
            console.log('list empty');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Cart is empty Please add items to cart."
            });
            toastEvent.fire();
        }                    
        
    }
    
})