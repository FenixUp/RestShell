# RestShell
Personal project to make a series of Rest Requests using Powershell. 
The idea being to make Rest Requests available to the layman while simplifying dev work.

Kinda bothers me that people are turning to tools like Postman to develop their API payloads. 
The Postman app has this practice of auto-uploading every request into their cloud. 
While there are ways to encrypt your credentials in the app, obv you're trusting the user to know better about which credentials should be encrypted or not. 
Postman Inc. may be sitting on a massive stack of various logins from everywhere.
Postman doesn't ask if you'd like to opt out of cloud their cloud storage. 
This process seems to happen automatically. Maybe there's a way to disable it, but seems unlikely people are consciously thinking about it enough to turn it off manually. 

So,, it's also relying on the idea that Postman Inc. doesn't lose your credentials to a data breach. 

What i'm trying to do here is to see if i could make a script that could also do that same job, without any additional installs. 
Allow people to develop the same kinds of API, even the layperson. 
And definately without a non-optional, or non-transparent, cloud storage. 
