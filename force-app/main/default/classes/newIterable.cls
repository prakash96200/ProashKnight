global class newIterable implements Iterator<Contact>{
    List<Contact> cont {get; set;}
    Integer i {get; set;}
    public newIterable(){
        cont = [SELECT Id, Name FROM Contact];
        i = 0;
    }
    global boolean hasNext(){
        if(i >= cont.size()) {
            return false;
        } else {
            return true;
        }
    }
    global Contact next(){
        i++;
        return cont[i-1];
    }
 }