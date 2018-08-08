/* Class Name: TestCallBookingClass
 * Used for: CallBookingClass
 * Author: Niketa Dutta (niketa.s.dutta@gmail.com)
 * 
 * Purpose:
 * This test class is for CallBookingClass.
*/
@isTest(SeeAllData=false)
public class TestCallBookingClass {
    static testmethod void testRec1(){
        Test.startTest();
        Account testAccount = new Account();
		testAccount.Name='Test Account' ;
		insert testAccount;
		
		Contact cont = new Contact ();
		cont.LastName ='Test';
		cont.FirstName ='Test';
		cont.accountid = testAccount.id;
		insert cont;
        
        Event eve = new Event();
        eve.WhoId = cont.id;
        eve.EndDateTime = datetime.now();
        eve.StartDateTime = datetime.now();
        eve.Subject = 'test';
        eve.OwnerId = UserInfo.getUserId();
        insert eve;
        
        PageReference pageRef = Page.CallBookingPage;
		Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id', String.valueOf(cont.Id));
        ApexPages.currentPage().getParameters().put('name', String.valueOf(cont.name));
        ApexPages.currentPage().getParameters().put('timezone', String.valueOf('local'));
		CallBookingClass  cBookingCtrl = new CallBookingClass();
        
        CallBookingClass.eventdata();
        
        ApexPages.currentPage().getParameters().put('event', String.valueOf(eve.id));
        ApexPages.currentPage().getParameters().put('cId', String.valueOf(cont.Id));
        
        PageReference pgRef = cBookingCtrl.addRelation();
        
        System.assertNotEquals(null,pageRef);
        
        Test.stopTest();
    }

    
}