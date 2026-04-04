import { LightningElement, wire, track } from "lwc";
import getAccountList from "@salesforce/apex/lwc_class.getAccList";

export default class DragandDropTable extends LightningElement {
  @track dragStart;
  @track ElementList = [];

  connectedCallback() {
    console.log("connected callback  " );

    getAccountList()
      .then((result) => {
        for (let i = 0; i < result.length; i++) {
          this.ElementList.push(result[i]);
        }
      })
      .catch((error) => {
        console.log("###Error : " + error.body.message);
      });
  }
  DragStart(event) {
    this.dragStart = event.target.title;
    event.target.classList.add("drag");
  }

  DragOver(event) {
    event.preventDefault();
    return false;
  }

  Drop(event) {
    event.stopPropagation();
    const DragValName = this.dragStart;
    const DropValName = event.target.title;
    if (DragValName === DropValName) {
      return false;
    }
    const index = DropValName;
    const currentIndex = DragValName;
    const newIndex = DropValName;
    Array.prototype.move = function (from, to) {
      this.splice(to, 0, this.splice(from, 1)[0]);
    };
    this.ElementList.move(currentIndex, newIndex);
  }
}