public with sharing class OpportunityUtils 
{
    // this method appends an indicator of the opportunity size 
    // to the name. 'Small' is 50k or less, 'Medium' is greater than 
    // Small but less than or equal to 100k, 'Large' is greater than Medium. 
    // Once the names have been updated, the records are written
    // to the database
    public void addOpportunitySizeToNameAndSave(List<Opportunity> opps)
    {
        for (Opportunity opp : opps)
        {
            if (opp.Amount>100000)
            {
                opp.Name+=' Large';
            }
            else if (opp.Amount>50000)
            {
                opp.Name+=' Medium';
            }
            else 
            {
                opp.Name+=' Small';
            }
        }

        upsert opps;
    }
}