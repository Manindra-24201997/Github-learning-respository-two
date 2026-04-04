import { LightningElement } from 'lwc';

export default class Lwc_for_loop_component extends LightningElement {
fruits = ['apple','mango','bananna','orange'];

arraydatacustom = [
{id:524,name:'Manindra',age:25,developer:true},
{id:527,name:'chennamsetty',age:25,developer:true}
]

obj = {name: "John", age: 30, city: "New York"};

objjson = {"name": "John", "age": "30", "city": "New York"};

objjsonstring = '{"name": "John", "age": "30", "city": "New York"}';

arrayofobj = [
  {"name": "John", "age": "25", "city": "New York"},
  {"name": "John cena", "age": "27", "city": "New York"},
  {"name": "John cenation", "age": "30", "city": "New York"}
]

contacts = [
    { 
     Id : '1001',
     Name : 'Ajinkya Dhas',
     Website : 'www.salesforcekid.com'
    },
    {
     Id : '1002',
     Name : 'Steve Jobs',
     Website : 'www.apple.com'
    },
    {
     Id : '1003',
     Name : 'Marc Benioff',
     Website : 'www.salesforce.com'
    },

    {
    Id : '1004',
    Name : 'Bill Gates',
    Website : 'www.microsoft.com'
    }
   ];

}