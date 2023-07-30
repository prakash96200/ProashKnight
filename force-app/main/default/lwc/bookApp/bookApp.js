import { LightningElement } from 'lwc';
const BOOK_URL = 'https://www.googleapis.com/books/v1/volumes?q='
export default class BookApp extends LightningElement {
    query;
    books;
    timer;
    connectedCallback(){
        //this.fetchBookData()
    }
    fetchBookData(){
        fetch(BOOK_URL+this.query).then(response=>response.json())
        .then(data=>{
            if(data.items.length>0){
                this.books = data.items;
            }else{
                this.books = '';
            }
        }).catch(error=>console.error(error))
    }
    fetchBookHandler(event){
        this.query = event.target.value
        window.clearTimeout(this.timer)
        this.timer = setTimeout(()=>{
            this.fetchBookData()
        },1000)
    }
}





