global class newIterableTwo implements iterable<Contact>{
    global Iterator<Contact> iterator(){
       return new newIterable();
    }
 }