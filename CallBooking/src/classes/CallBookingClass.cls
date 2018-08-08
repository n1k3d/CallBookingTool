/* Class Name: CallBookingClass
 * Used in: CallBookingPage
 * Author: Niketa Dutta (niketa.s.dutta@gmail.com)
 * 
 * Purpose:
 * This class is the controller for CallBookingPage, which is used to book call with contacts on a calendar display.
 * 
 * Methods in this class:
 * CallBookingClass : Constructor of the class
 * eventData : Remote action method to dispaly usere's events on the VF page
 * addRelation : To add the contacts to invitee in event
 * 
 * Wrapper Class:
 * calendarEvent : To display event details in the VF page
*/
public class CallBookingClass {
    public string eventsJSON {get;set;}
    
    //The calendar plugin is expecting dates is a certain format. We can use this string to get it formated correctly
     static String dtFormat1 = 'yyyy-MM-dd HH:mm:ss';
    
    // constructor
    public CallBookingClass(){
    }

    // This is remot action methond which is called from the VF page to display the 
    // running user's existing events
    @RemoteAction 
    public static string eventdata(){
        calendarEvent[] events = new calendarEvent[]{};
        list<Event> listOfEvents = [select Id, Subject, isAllDayEvent, StartDateTime, EndDateTime from Event where ownerID =:UserInfo.getUserId() limit 10000];
        
        for(Event evnt: listOfEvents){
            DateTime startDT = evnt.StartDateTime;
            DateTime endDT = evnt.EndDateTime;
            
            calendarEvent myEvent = new calendarEvent();
            myEvent.title = evnt.Subject;
            myEvent.allDay = evnt.isAllDayEvent;
            myEvent.startString = startDT.format(dtFormat1);
            myEvent.endString = endDT.format(dtFormat1);
            myEvent.url = '/' + evnt.Id;
            events.add(myEvent);
        }
        
        string jsonEvents = JSON.serialize(events);
        jsonEvents = jsonEvents.replace('startString','start');
        jsonEvents = jsonEvents.replace('endString','end');
        
        return jsonEvents;
    }

    // This method is called from actionFunction in VF page.
    // The purpose of this method is to add the contact to invitees to send meeting request   
    public PageReference addRelation() {
        ID eventId = Apexpages.currentPage().getParameters().get('event');
        ID relConId = Apexpages.currentPage().getParameters().get('cId');
        EventRelation evenRel = new EventRelation();
        evenRel.EventId = eventId;
        evenRel.RelationId = relConId;
        evenRel.Status = 'New';
		Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.emailHeader.triggerUserEmail = true;
        dmo.assignmentRuleHeader.useDefaultRule = true;
        evenRel.setOptions(dmo);

        insert evenRel;

        // this will call the edit page of the newly created event to send the meeting request to contact 
        PageReference myEventPage = new PageReference('/'+eventId+'/e');
        return myEventPage;   
    }
    
    // This is the calendar wrapper class used to displaly the SF events in the VF page
    Public class calendarEvent{
        public String title {get;set;}
        public Boolean allDay {get;set;}
        public String startString {get;set;}
        public String endString {get;set;}
        public String url {get;set;}
        public String className {get;set;}
        
    }
}