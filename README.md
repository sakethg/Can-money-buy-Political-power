# Can-money-buy-Political-power

Using data from 2010 Congressional elections, we intend to build a classifier that would predict the election’s outcome. The data set includes information
about the campaign funds, social media (Twitter, Facebook, and YouTube) campaigns, and demographics (age, gender) of 941 candidates who were in race in the general elections for The 112th House of Representatives seats in The U.S. Congress.1

Used Random Forest Classifier to predict effect of money on polictical campaigns.
Done validation with help of confusion matrix and AUC curve.

I would use Random Forest classifier to predict the election’s outcome rather than ANN classifier as the Accuracy is higher and this model do not over fit. Random Forest classifier is best suitable for the predictive modelling with categorical target variable. Hence
I would prefer Random Forest in this scenario.

Random Forest Accuracy - 98.67%

ANN
Accuracy – 84.94% (5 Hidden nodes)
Accuracy – 94.18% (24 Hidden nodes)

Recommendations

 If I am an advisor to the candidate who is running for a congressional seat, I would support the concept of investing in social media campaigns as social media has high influence in the deciding the output of the elections.

> ftable(xtabs(~twitter+gen_election, data=data)) gen_election L W
twitter
0	480 250
1	14 185
> ftable(xtabs(~facebook+gen_election, data=data)) gen_election L W
facebook
0	481 206
1	13 229
> ftable(xtabs(~youtube+gen_election, data=data)) gen_election L W
youtube
0	482 209
1	12 226


From considering ftables results above I would recommend the candidate to invest in Facebook and YouTube as there is high chances of word spread for winning in Facebook and YouTube when compared to twitter.
From important variable selection from random forest classifier below are the mainly impacted in the output of the elections. I would recommend my candidate to concentrate on these areas.
1- opp_fund: Maintain more funds when compared to the opposition candidate.
2	- coh_cop: Have huge amount of cash in the end keeping in mind the funds
of the opposition party.
3	- other_pol_cmte_contri: maintains good terms with other political committees as their contributions will impact the result.
4	– Facebook: Invest and held polls and ads through social media especially into Facebook.
5	- cand_ici: Maintain Incumbent challenger status


Conclusion

I would strongly agree with the statement “Money Buys Political Power”. Political campaigns need to be well funded. Usually unpaid
 
volunteers are not reliable, so hiring individual campaign managers need huge amount of money. To run the campaign successfully they recruit consultants to conduct the polls and develop campaign ads either practically or in social media requires huge investments. The candidates in the congressional election cannot use the funds from the public, hence they back their campaigns from their personal funds. Hence the candidate with more money have high chances of investing in campaign and social media ads has high probability to win the election.
