public class Controller {
    public String season {get;set;}
    
    public Controller()
    {
        season = 'Summer';    
    }
    
    public pageReference setToWinter()
    {
        season = 'Winter';
        return null;
    }
}