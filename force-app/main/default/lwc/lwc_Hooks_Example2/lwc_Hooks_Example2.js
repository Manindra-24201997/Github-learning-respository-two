import { LightningElement } from 'lwc';

export default class Lwc_Hooks_Example2 extends LightningElement {
     hasRendered = false;

    constructor() {
        super();
        console.log('1️⃣ constructor() called');
    }

    connectedCallback() {
        console.log('2️⃣ connectedCallback() called');
    }

    renderedCallback() {
        console.log('3️⃣ renderedCallback() called');
        
        if (!this.hasRendered) {
            this.hasRendered = true;
            console.log('📌 renderedCallback logic (only once)');
        }
    }

    disconnectedCallback() {
        console.log('4️⃣ disconnectedCallback() called');
    }

    errorCallback(error, stack) {
        console.log('5️⃣ errorCallback() called');
        console.error('Error:', error);
        console.error('Stack:', stack);
    }

    // Dummy method to trigger re-render
    handleClick() {
        this.hasRendered = false; // Reset to show renderedCallback again
        console.log('🔁 Button clicked — forcing re-render');
    }
}