import { LightningElement,api } from 'lwc';

export default class Lwc_conditional_check_for_loop_child_cmp extends LightningElement {
@api ismango;

render() {
    this.ismango = 'Mango'
    return this.ismango;
}
}