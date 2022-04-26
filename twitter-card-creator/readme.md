## Twitter Card Creator
Every week on Tuesday @ 10 am, there is a new Agile in Action podcast. This Twitter module will automatically tweet the latest podcast.

## Steps for initial creation
1. Create a Twitter Developer account with elevated access
2. Among other things, that will give you an API Key and API Secret
3. Go to https://developer.twitter.com, go to your project (app name) and then select Keys and Tokens (at the top of the page)
4. Locate the Access Token and Secret area and click Generate. You will now have a Access Token and Access Token Secret
5. Go to the GitHub repo containing this code and click Setttings
6. Location Secrets->Actions and create four new repository secrets:
* TWITTER_CONSUMER_KEY (Twitter API Key)
* TWITTER_CONSUMER_SECRET_KEY (Twitter API Secret)
* TWITTER_ACCESS_TOKEN (Twitter Access Token)
* TWITTER_ACCESS_TOKEN_SECRET (Twitter Token Secret)

## Files
Tweet.yml gets placed into .github/workflows
tweet.py gets placed into the root folder of the repo `./`
tweet.json should contain the list of tweets

## Note
Use the sample_tweet.json file for examples of how to configure the tweet
