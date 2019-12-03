<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.EntityNotFoundException" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>GAE FB Tweet</title>
    <!-- Global site tag (gtag.js) - Google Analytics -->
	<script async src="https://www.googletagmanager.com/gtag/js?id=UA-153779011-1">
	</script>
	<script>
		window.dataLayer = window.dataLayer || [];
		function gtag(){dataLayer.push(arguments);}
			gtag('js', new Date());
			gtag('config', 'UA-153779011-1');
	</script>

 <script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">

<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>

         <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
    

    <link href="./css/bootstrap.min.css" media="all" type="text/css" rel="stylesheet">
    <link href="./css/bootstrap-responsive.min.css" media="all" type="text/css" rel="stylesheet">
    <link href="./css/font-awesome.css" rel="stylesheet" >
    <link href="./css/nav-fix.css" media="all" type="text/css" rel="stylesheet">
    
    <style>
      .artwork {
        margin-top:30px;
        margin-bottom: 30px;
      }

    </style>

  </head>
  <body>
  
  
      <div class="navbar navbar-fixed-top" style="background:blue">
      <div class="navbar-inner">
        <div class="container-fluid">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
          <div class="nav-collapse">
            <ul class="nav">
              <li class="active"><a href="home.jsp">Home</a></li>
              <li><a id="friends_tweet" href="./friends.jsp">Tweet of Friends</a> </li>
              <li><a id="friends_top_tweets" href="./friends_top_tweets.jsp">Top Tweets of Friends</a> </li>
            </ul>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>
  
  
<h1> Displaying the individual tweet</h1>  
 
    <div class="container">

  <%
    String tweet_key = request.getParameter("tweet_key");
    if (tweet_key == null) {
    	
    	%>
    	<script type="text/javascript">location.href="home.jsp";</script>
    <%
    } else { 
        DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
        Key tw_key = KeyFactory.stringToKey(tweet_key); 
        String tweet_text="", username="", date="";
 
        String count = "";
			Entity tweet = ds.get(tw_key);
			 tweet_text = (String) tweet.getProperty("text");
			 Long newcount = (Long) tweet.getProperty("count");
			 newcount +=1 ;
			 tweet.setProperty("count", newcount);
			 username = (String) tweet.getProperty("username");
			 date = (String) tweet.getProperty("date");
			 ds.put(tweet);
			
    %>	  
      <p>Message: <%=tweet_text %> </p>
      <p>Posted at: <%=date %> </p>
      <p>Posted by: <%=username %> </p>
      <p>Number of Views : <%=newcount %> </p>

  <%
      }
      %>
     </div>   
  
  </body>   
</html>