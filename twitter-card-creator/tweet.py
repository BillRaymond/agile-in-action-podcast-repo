#import all dependencies
import os
import json
import tweepy

#set API credentials
consumer_key=os.environ.get("TWITTER_CONSUMER_KEY")
consumer_secret_key=os.environ.get("TWITTER_CONSUMER_SECRET_KEY")
access_token=os.environ.get("TWITTER_ACCESS_TOKEN")
access_token_secret=os.environ.get("TWITTER_ACCESS_TOKEN_SECRET")

#authenticate to access the twitter API
auth=tweepy.OAuthHandler(consumer_key,consumer_secret_key)
auth.set_access_token(access_token,access_token_secret)
api=tweepy.API(auth)

#open JSON file 
f = open("tweet.json",)

#store JSON string as a dictionary 
tweets = json.load(f) 

#parse dictionary and tweet to API
for tweet in tweets.values():
	for tweet_text, image_path in tweet.items():
		
		#if both tweet text and featured image are available
		if (tweet_text and image_path):
			image = api.media_upload(image_path)
			api.update_status(status=tweet_text, media_ids=[image.media_id])
		
		#if only tweet text is available
		elif (tweet_text):
			api.update_status(status=tweet_text)
		
		#if only featured image is available
		elif (image_path):
			image = api.media_upload(image_path)
			api.update_status(status="", media_ids=[image.media_id])
		
		#if no tweet data is available
		else:
			print('Nothing to tweet.')
	
	#end of one tweet
	n=1
	print(str(n) + " tweets posted.")
	n+=1

#end of program
print("tweet.py has finished running.")