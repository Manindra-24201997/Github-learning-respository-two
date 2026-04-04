global class UPS_Shiment_Call {
    @future(callout=true)
    global static void futureMethodSample() {
        UPS_ShipmentFetch_And_Update_Status ups=new UPS_ShipmentFetch_And_Update_Status(); 
    }
}