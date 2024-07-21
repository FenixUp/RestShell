# RestShell
Personal project to make a series of Rest Requests using Powershell. 
The idea being to make Rest Requests available to the layman while simplifying dev work.
Windows has built-in powershell features to allow users to send web requests.
The idea for this project is to allow users and developers to focus on developing API payloads, while not doing any powershell :)

Bothers me that people are turning to tools like Postman to develop their API payloads. 
The Postman app has this practice of auto-uploading every request into their cloud. 
While there are ways to encrypt your credentials in the app, they're trusting the user to know better about which credentials should be encrypted or not. 
Postman Inc. is likely sitting on a massive stack of various logins from everywhere.
Postman doesn't ask if you'd like to opt out of cloud their cloud storage.
This process seems to happen automatically. Maybe there's a way to disable it, but seems unlikely people are consciously thinking about it enough to turn it off manually. 

So,, it's relying on the idea that Postman Inc. doesn't lose your credentials to a data breach. 

What i'm trying to do here is to see if i could make a script that could also do that same job, without any additional installs. 
Allow people to develop the same kinds of API, even the layperson. 
That Devs can focus on API Development, and not worry about Powershell. 
A Layperson can leverage their App's API to scale up their work, using Window OS's built-in functionality.
And definately without a non-optional, or non-transparent, cloud storage. 

The approach here uses a JSON file as the User Interface within your own favorite text editor.
