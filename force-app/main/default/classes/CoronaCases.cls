public class CoronaCases {
    @AuraEnabled
    public static List<Covid19CountrySummary> getCases(){
        List<Covid19CountrySummary> COVID19Summary = new List<Covid19CountrySummary>();
        
        string endPoint = 'https://api.covid19api.com/summary';
        Http h1 = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setHeader('Content-type', 'application/json');
        req.setMethod('GET');
        HttpResponse res = h1.send(req);
        system.debug(res.getBody());
        JSONParser parser = JSON.createParser(res.getBody());
        while(parser.nextToken() != null){
            if(parser.getCurrentToken() == JSONToken.START_ARRAY){
                while(parser.nextToken() != null){
                    if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                        Covid19CountrySummary covid = (Covid19CountrySummary)parser.readValueAs(Covid19CountrySummary.class);
                        if(string.isNotBlank(covid.country)){
                            COVID19Summary.add(covid);
                        }
                    }
                }
            }
        }
        System.debug(COVID19Summary);
        if(COVID19Summary.size() > 0){
            string CountryName = 'Grand Total';
            
            integer NewConfirmedTotal= 0;

             integer TotalConfirmedTotal= 0;

             integer NewDeathsTotal= 0;

             integer TotalDeathsTotal= 0;

             integer NewRecoveredTotal= 0;

             integer TotalRecoveredTotal= 0;
            for(Covid19CountrySummary eachCountry : COVID19Summary){
                NewConfirmedTotal = NewConfirmedTotal + integer.valueOf(eachCountry.newConfirmed);
                
                TotalConfirmedTotal = TotalConfirmedTotal+Integer.valueof(eachCountry.TotalConfirmed);

                NewDeathsTotal = NewDeathsTotal+Integer.valueof(eachCountry.NewDeaths);

                TotalDeathsTotal = TotalDeathsTotal+Integer.valueof(eachCountry.TotalDeaths);

                NewRecoveredTotal = NewRecoveredTotal+Integer.valueof(eachCountry.NewRecovered);

                TotalRecoveredTotal = TotalRecoveredTotal+Integer.valueof(eachCountry.TotalRecovered);
                
            }
            COVID19CountrySummary totalSummary = new COVID19CountrySummary();
            totalSummary.Country = countryName;

            totalSummary.CountrySlug = countryName;

            totalSummary.NewConfirmed = string.valueOf(NewConfirmedTotal);

            totalSummary.TotalConfirmed = TotalConfirmedTotal;

            totalSummary.NewDeaths = string.valueOf(NewDeathsTotal);

            totalSummary.TotalDeaths = string.valueOf(TotalDeathsTotal);

            totalSummary.NewRecovered = string.valueOf(NewRecoveredTotal);

            totalSummary.TotalRecovered = string.valueOf(TotalRecoveredTotal);

            system.debug('***totalSummary'+totalSummary);

            COVID19Summary.add(totalSummary );

         }

        system.debug('***COVID19Summary'+COVID19Summary);

        return COVID19Summary;
        }
    }