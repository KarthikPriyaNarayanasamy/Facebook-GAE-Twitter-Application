<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
  <head>
	<!-- Global site tag (gtag.js) - Google Analytics -->
	<script async src="https://www.googletagmanager.com/gtag/js?id=UA-153779011-1">
	</script>
	<script>
		window.dataLayer = window.dataLayer || [];
		function gtag(){dataLayer.push(arguments);}
			gtag('js', new Date());
			gtag('config', 'UA-153779011-1');
	</script>
    <meta charset="utf-8">
    <title>FB Twitter APP</title>


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
 <div id="fb-root"></div>
<script>
    // This is called with the results from from FB.getLoginStatus().
    function statusChangeCallback(response)
    {
        console.log('statusChangeCallback');
        console.log(response);
        // The response object is returned with a status field that lets the
        // app know the current login status of the person.
        // Full docs on the response object can be found in the documentation
        // for FB.getLoginStatus().
        if (response.status === 'connected')
        {
            // Logged into your app and Facebook.
            var msg=document.getElementById('main_tweet_db');
            msg.style.display='';
            var login_div=document.getElementById('status');
            login_div.style.display='none';
            testAPI();
        } 
        else if (response.status === 'not_authorized')
        {
            // The person is logged into Facebook, but not your app.
            var msg=document.getElementById('main_tweet_db');
            msg.style.display='none';
            var profile=document.getElementById('profile_link');
			profile.style.display='none';
			document.cookie = "userid=" ;
			document.cookie = "username=";
		}
        else
        {
			// The person is not logged into Facebook, so we're not sure if
			// they are logged into this app or not.
			var msg=document.getElementById('main_tweet_db');
			msg.style.display='none';
			var profile=document.getElementById('profile_link');
			msg.style.display='none';
			document.cookie = "userid=" ;
			document.cookie = "username=";
		}
	}

	var login_event = function(response)
	{
		var msg=document.getElementById('main_tweet_db');
		msg.style.display='';
		var login_div=document.getElementById('status');
		login_div.style.display='none';
	}

	var logout_event = function(response)
	{
		var msg=document.getElementById('main_tweet_db');
		msg.style.display='none';
		var profile=document.getElementById('profile_link');
		msg.style.display='none';
		var login_div=document.getElementById('status');
		login_div.style.display='';
		document.cookie = "userid=" ;
		document.cookie = "username=";
	}
	// This function is called when someone finishes with the Login
	// Button.  See the onlogin handler attached to it in the sample
	// code below.
	function checkLoginState() {
    	FB.getLoginStatus(function(response) {
      		statusChangeCallback(response);
    	});
  	}

	window.fbAsyncInit = function() {
    	FB.init({
   			appId      : '496741084269044',
      		cookie     : true,  // enable cookies to allow the server to access 
      		xfbml      : true,
      		version    : 'v2.9',
      		status     : true
    	});  
		FB.getLoginStatus(function(response) {
	    	statusChangeCallback(response);
	  	});
		FB.Event.subscribe('auth.statusChange', function(response) {
    		if (response.status === 'connected') {
                  //the user is logged and has granted permissions
       			login_event();
    		} else if (response.status === 'not_authorized') {
          		//ask for permissions
         		logout_event();
    		} else {
    			logout_event();
          		//ask the user to login to facebook
    		}
		});
	};	  
	(function(d, s, id){
		var js, fjs = d.getElementsByTagName(s)[0];
     	if (d.getElementById(id)) {return;}
     	js = d.createElement(s); js.id = id;
     	js.src = "//connect.facebook.net/en_US/sdk.js";
     	fjs.parentNode.insertBefore(js, fjs);
   	}(document, 'script', 'facebook-jssdk'));

	var post = function() {
		var text = document.getElementById('tweet_text').value;
		console.log("value of text iddddd " + text);
		var url = "https://www.facebook.com/dialog/share?app_id=496741084269044&href=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2F"
        url = url + "&quote=" + text;
		window.open(url);
	}

	// Here we run a very simple test of the Graph API after login is
	// successful. See statusChangeCallback() for when this call is made.
	function share() {
		var tweet_text = document.getElementById('tweet_text').value;
		var userid = document.getElementById('userid').value;
		var username = document.getElementById('username').value;
		var picture = document.getElementById('picture').value;
		var msg_tweet = "true";

		var post_data = {
			  tweet_text: tweet_text,
			  userid: userid  , 
			  username: username,
			 picture: picture,
			 msg_tweet : "true"
		};
		$.post("Tweet", post_data, function(data) {
			console.log(data);
			var key = data;
			var url = window.location.href ;
			if (url.search("localhost")!==-1) {
				url = "https://facebook.com/";
			}
			var share_url = url + "view_tweet.jsp?tweet_key=" + key ;
			var url = "https://www.facebook.com/dialog/send?app_id=496741084269044";
		    url = url + "&link=" + share_url;
		    url = url + "&redirect_uri=https://apps.facebook.com/496741084269044/?fb_source=feed";
		    window.open(url);
	} );
	
	


}
var profile_url = "";
function testAPI() {

console.log('Welcome! Fetching your information.... ');
FB.api('/me', function(response) {

console.log('Successful login for: ' + response.name);
console.log('response is ' + JSON.stringify(response));
document.getElementById('profile_pic').innerHTML = '<a href="#" class="thumbnail"><img src="http://graph.facebook.com/' + response.id + '/picture?type=large" /></a>';
document.getElementById('fullname').innerText = response.name;
document.getElementById('fullname_head').innerText = response.name;
document.getElementById('profile_link').href = 'https://facebook.com/' + response.id;
profile_url = 'https://facebook.com/' + response.id;
localStorage.profile_url = profile_url;
document.getElementById('picture').value = 'http://graph.facebook.com/' + response.id + '/picture';
document.getElementById('userid').value =  response.id;
document.getElementById('username').value =  response.name.split(" ")[0];
document.cookie = "userid=" + response.id;
document.cookie = "username=" + response.name.split(" ")[0];
document.cookie = "profile=" + "https://facebook.com/" + response.id;
document.cookie = "picture=" + "http://graph.facebook.com/" + response.id + "/picture?type=large";

});
}
</script>

<div id ="status" class="well" style="width:800px; margin:0 auto;">
  <h1 class="lead"><strong></strong> </h1>
  <p>This APP will let an Facebook User to tweet and post a message into the FB timeline. It uses the GAE datastore to store the tweets </p>

  <p> Please login into your Facebook account using the login button below </p>
	<fb:login-button size="large" autologoutlink="true" scope="public_profile,email,manage_pages,publish_pages,user_friends" onlogin="checkLoginState();">
	</fb:login-button>
</div>


<% Cookie[] cookies = request.getCookies();
		String userid="", username="",picture="";
		if (cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				Cookie cookie = cookies[i];
				if (cookie.getName().equals("userid")) {
					userid = cookie.getValue();
				}

				if (cookie.getName().equals("username")) {
					username = cookie.getValue();
				}

				if (cookie.getName().equals("picture")) {
					picture = cookie.getValue();
				}
			}
		}
		
		%>
		
		<nav class="navbar navbar-fixed-top" style="background-color: #333399;"></nav>
		<div class="navbar navbar-fixed-top navbar-inverse ">
			<div class="navbar-inner">
				<div class="container-fluid">
					<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</a>
					<div class="btn-group pull-right" id="welcome">
						Welcome, <strong><a id="fullname"> </a> </strong> 
						<fb:login-button size="large" autologoutlink="true" scope="public_profile,email,manage_pages,publish_pages,user_friends" onlogin="checkLoginState();">
						</fb:login-button>                      
					</div>
					<div class="nav-collapse">
						<ul class="nav">
							<li class="active"><a href="#">Home</a></li>
							<li><a id="friends_tweet" href="./friends.jsp">Tweet of Friends</a> </li>
							<li><a id="friends_top_tweets" href="./friends_top_tweets.jsp">Top Tweets of Friends</a> </li>
						</ul>
					</div><!--/.nav-collapse -->
				</div>
			</div>
		</div>

		<div id="main_tweet_db" class="container-fluid" style="display:none;">
					<div class="row">
						<div class="span4 well">
							<div class="row">
								<div id="profile_pic" class="span1"><a href="#" class="thumbnail"><img src="./img/user.jpg" alt=""></a>
								</div>
								<div class="span3">
									<h3><a id="fullname_head"> </a></h3>
									<h4><a id="num_tweets" >current tweets 0 </a></h4>         
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-4">
							<div class="span4 well">
								<form method="post" action="Tweet" name="post_tweet" id="post_tweet" accept-charset="UTF-8">        
									<input type="hidden" name="userid" id="userid" value=""/>
									<input type="hidden" name="username" id="username" value=""/>
									<input type="hidden" name="picture" id="picture" value=""/>                  
									<textarea class="span4" id="tweet_text" name="tweet_text" rows="5" placeholder="Type in your new tweet"></textarea>
									<input type="submit" name="post_btn" value="Post New Tweet" class="btn btn-info" onclick="post()"/>
									<input type="button" name="share_btn" value="Share with friends" class="btn btn-primary" onclick="share()"/>
								</form>     
							</div>
						</div>

						<div class="col-sm-4">
							<div class="span4 well">
								<p class="lead"> Current Tweets</p>
								<hr />
		   
								<%
									DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
									// Run an ancestor query to ensure we see the most up-to-date
									// view of the Greetings belonging to the selected Guestbook.
									Query query = new Query("Tweet").addSort("date", Query.SortDirection.DESCENDING);
									query.addFilter("userid", Query.FilterOperator.EQUAL, userid);
									List<Entity> tweets = datastore.prepare(query).asList(FetchOptions.Builder.withChunkSize(2000));
									int num_tweets = tweets.size();
									if (tweets.isEmpty()) {
								%>
								<div class="alert alert-danger">
									<p> User haven't tweeted anything </p>
								</div>
								<%
								}
								else { 
								%>
									<script type="text/javascript">
										console.log(<%=num_tweets%>);
										document.getElementById("num_tweets").innerText = "current tweets <%=num_tweets%>";
									</script>
								<% 
									for (Entity tweet : tweets) { 
										String tweet_text =  (String) tweet.getProperty("text");
										String tweet_date = (String) tweet.getProperty("date");
										String key = KeyFactory.keyToString(tweet.getKey());
										String href = "'view_tweet.jsp?tweet_key=" + key + "'";
								%>
								<div>
									<a class="active" href=<%=href%> ><%=tweet_text%></a>
									<span class="pull-right">At <%=tweet_date%></span>
									<form method="post" action="Delete" name="delete_tweet" accept-charset="UTF-8">     
										<input type="hidden" name="tweet_key" id="tweet_key" value="<%=key%>"/>    
										<input type="submit" class="btn" value="Remove"/>
									</form>
									<p>&nbsp;</p>
								</div>      
								<hr />
								<% 
								} 
								%>
							</div>
						</div>
		
						<div class="col-sm-4">
							<div class="span4 well">
								<p class="lead"> Popular Tweets</p>
								<hr />
				<%   Query c_query = new Query("Tweet").addSort("count", Query.SortDirection.DESCENDING);
		c_query.addFilter("userid",
				Query.FilterOperator.EQUAL,
				userid);
		List<Entity> c_tweets = datastore.prepare(c_query).asList(FetchOptions.Builder.withChunkSize(2000)); 
		for (Entity each_tweet : c_tweets ) { 
				String c_tweet_text =  (String) each_tweet.getProperty("text");
				String c_tweet_date = (String) each_tweet.getProperty("date");
				Long c_tweet_count = (Long) each_tweet.getProperty("count");
				String c_key = KeyFactory.keyToString(each_tweet.getKey());
				String c_href = "'view_tweet.jsp?tweet_key=" + c_key + "'";%>
								<div>
									<a class="active" href=<%=c_href%> ><%=c_tweet_text%></a>
									<p>&nbsp;</p>
									<span class="pull-left">View Count <%=c_tweet_count %></span>
									<span class="pull-right"><%=c_tweet_date%></span>
									<p>&nbsp;</p>
								</div>  
								<hr />	
							<% } %>    	 
							</div>
						</div>   
						<% } %>
					</div>
		</div>
  
		<script src="./js/jquery-1.7.2.min.js"></script>
		<script src="./js/bootstrap.min.js"></script>
		<script src="./js/charcounter.js"></script>
		<script src="./js/app.js"></script>
	</body>
</html>
