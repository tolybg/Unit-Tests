@isTest
private class OpportunityUtils_Test 
{
    // update this class to unit test the OpportunityUtils class. 
    // Ensure that you create positive and negative test cases
    // as appropriate, and take into account any boundaries.

    // 100% coverage can be achieved without testing all scenarios,
    // so don't stop just because you have full coverage.


    //Tests all scenarios for a variety of amounts in 200 records
    @isTest
    private static void testBulk()
    {
        User salesUser = UnitTestHelper.CreateUser_inMemory('Joe', 'Bloggs', 'jbl', 'Standard User');
        insert salesUser;

        Account testAcc = UnitTestHelper.createAccount_InMemory();
        insert testAcc;

        //Creates 200 opps with amounts 1k to 200k
        List<Opportunity> testOpps = UnitTestHelper.createOpps_InMemory(testAcc, 200);

        Test.StartTest();
        System.runAs(salesUser)
        {
            OpportunityUtils oppUtils = new OpportunityUtils();
            oppUtils.addOpportunitySizeToNameAndSave(testOpps); 
            //Why isn't this a static method?
        }
        Test.StopTest();

        List<Opportunity> resultOpps = [SELECT Id, Name, Amount 
                                        FROM Opportunity 
                                        WHERE Id IN: testOpps
                                        ORDER BY Amount];

        System.assertEquals(200, resultOpps.size(), 'Expected 200 test opps');

        Opportunity opp = new Opportunity();

        for (Integer i = 0; i < 50; i++) 
        {
            opp = resultOpps[i];
            System.assert(opp.Amount <= 50000, 'Testing should be for small amounts');
            System.assertEquals(true, opp.Name.endsWith('Small'), 'Wrong opp size in name');
            System.assertNotEquals(true, opp.Name.endsWith('Medium'), 'Wrong opp size in name');
            System.assertNotEquals(true, opp.Name.endsWith('Large'), 'Wrong opp size in name');
            System.assert(opp.Name.endsWith('Small'), 'Wrong opp size in name');
        }

        for (Integer i = 50; i < 100; i++) 
        {
            opp = resultOpps[i];
            System.assert(opp.Amount > 50000, 'Testing should be for Medium amounts');
            System.assert(opp.Amount <= 100000, 'Testing should be for Medium amounts');
            System.assertEquals(true, opp.Name.endsWith('Medium'), 'Wrong opp size in name');
            System.assertNotEquals(true, opp.Name.endsWith('Small'), 'Wrong opp size in name');
            System.assertNotEquals(true, opp.Name.endsWith('Large'), 'Wrong opp size in name');


        }

        for (Integer i = 100; i < 200; i++) 
        {
            opp = resultOpps[i];
            System.assert(opp.Amount > 100000, 'Testing should be for Large amounts');
            System.assertEquals(true, opp.Name.endsWith('Large'), 'Wrong opp size in name');
            System.assertNotEquals(true, opp.Name.endsWith('Small'), 'Wrong opp size in name');
            System.assertNotEquals(true, opp.Name.endsWith('Medium'), 'Wrong opp size in name');
        }
    }

    //test boundaries
    //0
    //50000
    //100000

    @IsTest
    private static void testBoundaryAmounts()
    {
        User salesUser = UnitTestHelper.CreateUser_inMemory('Joe', 'Bloggs', 'jbl', 'Standard User');
        insert salesUser;

        Account testAcc = UnitTestHelper.createAccount_InMemory();
        insert testAcc;

        //Creates 200 opps with amounts 1k to 200k
        Opportunity opp0k   = UnitTestHelper.CreateOpportunity_InMemory(testAcc, 0);
        Opportunity opp50k  = UnitTestHelper.CreateOpportunity_InMemory(testAcc, 50000);
        Opportunity opp100k = UnitTestHelper.CreateOpportunity_InMemory(testAcc, 100000);

        List<Opportunity> testBoundaryOpps = new List<Opportunity>{opp0k, opp50k, opp100k};

        Test.StartTest();
        System.runAs(salesUser)
        {
            OpportunityUtils oppUtils = new OpportunityUtils();
            oppUtils.addOpportunitySizeToNameAndSave(testBoundaryOpps); 
            //Why isn't this a static method?
        }
        Test.StopTest();

        List<Opportunity> resultOpps = [SELECT Id, Name, Amount 
                                        FROM Opportunity 
                                        WHERE Id IN: testBoundaryOpps
                                        ORDER BY Amount];

        System.assertEquals(3, resultOpps.size(), 'Expected 3 test opps');

        System.assertEquals(true, resultOpps[0].Name.endsWith('Small'), '0 should be small indeed!');
        System.assertEquals(true, resultOpps[1].Name.endsWith('Small'), 'Exactly 50k should be small ');
        System.assertEquals(true, resultOpps[02].Name.endsWith('Medium'), 'Exactly 100k should be medium ');
    }
}