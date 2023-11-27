Trigger AccountTrigger on Account(before update){
    for(Account acc: trigger.new){
        acc.phone = '1234567890';
    }
}