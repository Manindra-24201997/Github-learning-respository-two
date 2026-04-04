<aura:application extends="force:slds" controller = "ConnectionProcessingClass" access="GLOBAL">
    <!--<aura:dependency resource="connectionProcessing"/>-->
    <!-- <c:connectionProcessing></c:connectionProcessing>-->
    <aura:handler name="init" value="{!this}" action="{!c.myAction}"/>
    {!v.body}
    
    
</aura:application>