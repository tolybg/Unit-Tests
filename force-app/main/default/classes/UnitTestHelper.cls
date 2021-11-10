@isTest
public with sharing class UnitTestHelper 
{
    private static final String OPP_NAME_SUFFIX = '- Test Opp';
    private static final String OPP_DEFAULT_STAGE = 'Prospecting';
    private static final Integer OPP_AMOUNT_INCREMENTOR = 1000;

    public static String RANDOM_DOMAIN = UserInfo.getOrganizationId() + '.' + Integer.valueOf(math.rint(math.random()*1000000));

    //Return 
    public static List<Opportunity> createOpps_InMemory(Account testAcc, Integer nrOpps)
    {
        List<Opportunity> oppsToReturn = new List<Opportunity>();

        if(testAcc == null)
        {
            testAcc = CreateAccount_InMemory();
            insert testAcc;
        }

        for (Integer i = 1; i <= nrOpps; i++) 
        {
            Double oppAmt = i * OPP_AMOUNT_INCREMENTOR;
            oppsToReturn.add(CreateOpportunity_InMemory(testAcc, oppAmt));
        }

        return oppsToReturn;
    }

    //Retrun Account
    public static Account CreateAccount_InMemory()
    {
        return new Account(Name = 'Test Account');
    }

    //Return Opportunity
    public static Opportunity CreateOpportunity_InMemory(Account oppAcc, Double oppAmt)
    {
        return new Opportunity( Name = oppAcc.Name + OPP_NAME_SUFFIX, 
                                AccountId = oppAcc.Id,
                                Amount = oppAmt,
                                StageName = OPP_DEFAULT_STAGE,
                                CloseDate = Date.today().addDays(30));
    }

    public static User CreateUser_inMemory( String firstName, String lastName, String alias, String profileName)
    {
        List<Profile> profile = [ SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1 ];

        if( profile.isEmpty() )
        {
            System.assert( false, 'Profile name \'' + profileName + '\' does not exist' );
        }

        User testUser = new User();
        testUser.FirstName = firstName;
        testUser.LastName = lastName;
        testUser.Alias = alias;
        testUser.Email = alias + '@' + RANDOM_DOMAIN;
        testUser.Username = alias + '@' + RANDOM_DOMAIN;
        testUser.CommunityNickname = lastName;
        testUser.TimeZoneSidKey = 'Europe/London';
        testUser.LocaleSidKey = 'en_GB';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        testUser.ProfileId = profile[0].Id;
        testUser.LanguageLocaleKey = 'en_US';
        testUser.CompanyName = 'ACME';
        testUser.IsActive = true;

        return testUser;
    }
}
