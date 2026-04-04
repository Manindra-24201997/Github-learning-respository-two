import { LightningElement, wire, track } from 'lwc';
import getrcds from '@salesforce/apex/lwc_class.getrecords';
import { refreshApex } from '@salesforce/apex';

export default class Lwc_wire_refreshapex extends LightningElement {
opportunities;
wiredOpportunitiesResult;
searchtext;

handlesearch(event){
this.searchtext = event.target.value;  
}

 @wire(getrcds,{Searchname:'$searchtext'}) wiredOpportunities(result) {
this.wiredOpportunitiesResult = result;
if (result.data) {
this.opportunities = result.data;
} else if (result.error) {
console.error('Error fetching opportunities:', result.error);
}
}

refreshbutton() {
refreshApex(this.wiredOpportunitiesResult)
.then(() => {
console.log('Data refreshed successfully');
})
.catch(error => {
console.error('Error refreshing data:', error);
});
}
}