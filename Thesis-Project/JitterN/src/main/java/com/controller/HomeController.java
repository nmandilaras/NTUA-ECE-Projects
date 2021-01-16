package com.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.bson.types.ObjectId;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.GetTweets;
import com.google.gson.Gson;
import com.model.Hashtag;
import com.model.Tweet;
import com.model.User;
import com.mongo.MongoMyClient;

@Controller
public class HomeController {

	private static final Logger logger = Logger.getLogger(HomeController.class.getName());
	private static Query myQuery = null;
	ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
	MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");	
	
	@RequestMapping(value="/Home",method=RequestMethod.GET)
	public String  home(Model m, HttpServletRequest request, HttpServletRequest response){
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("userName") == null) return "restrict";
		String userName = (String) session.getAttribute("userName"); // handle unauthorised atempts for login
        session.setAttribute( "scroll", 1);
		m.addAttribute("userName", userName);
		List<Tweet> jits = new ArrayList<Tweet>();
		new Criteria();
		Query query = new Query(Criteria.where("userName").is(userName));
		logger.info("Start getting user and followers");
		User user = mongoOperation.findOne(query, User.class);
		List<String> followers = user.getFollowers();
		logger.info("Start getting jits for all followers");
		myQuery = new Query(Criteria.where("userName").in(followers));
		myQuery.with(new Sort(Sort.Direction.DESC, "date"));
		jits = tweetsPage(myQuery, 0, mongoOperation);
		logger.info("Finished collecting jits and sorting");
		m.addAttribute("results", jits);
		return "home";
	}
	
	@RequestMapping(value="/Njit",method=RequestMethod.GET)
	@ResponseBody
	public String  jit(Model m, HttpServletRequest request,  @RequestParam("jit") String jitText, @RequestParam(value = "reJit", required = false) String reJit, @RequestParam(value = "reId", required = false) ObjectId id){
		HttpSession session = request.getSession(false);
		String userName = (String) session.getAttribute("userName"); // handle unauthorised atempts for login
		logger.info("Jit receiving:" + jitText);
		Date date = new Date();
		Tweet tweetOld = null;
		Tweet jit = new Tweet();
		if (reJit!= null){
			jitText = "<b>Retweeted " + reJit + "'s Jit:</b><br>" + jitText;
			Query query = new Query(Criteria.where("id").is(id));
			tweetOld = mongoOperation.findOne(query, Tweet.class);
			jit.setRt(tweetOld.getId());
		}
		jit.setUserName(userName);
		jit.setDate(date);
		jit.setText(jitText);
		mongoOperation.insert(jit);
		if (tweetOld!=null) {
			tweetOld.addRetweet(jit.getId());
			mongoOperation.save(tweetOld);
		}
		Pattern MY_PATTERN = Pattern.compile("#(\\w+)");
		Matcher mat = MY_PATTERN.matcher(jitText);
		List<String> hashtags = new ArrayList<String>();
		while (mat.find()) 
		  hashtags.add(mat.group(1));
		for(String hashtagName : hashtags){
			new Criteria();
			Query query = new Query(Criteria.where("text").is(hashtagName));
			Hashtag hashtag = mongoOperation.findOne(query, Hashtag.class);
			if (hashtag == null){
				hashtag = new Hashtag();
				hashtag.setText(hashtagName);
				hashtag.addJit(jit.getId());
				mongoOperation.insert(hashtag);
			}else{
				hashtag.addJit(jit.getId());
				mongoOperation.save(hashtag);
			}
		}		
		return "ok";
	}

	@RequestMapping(value="/Reply",method=RequestMethod.GET)
	@ResponseBody
	public List<String[]>  reply(Model m, HttpServletRequest request,  @RequestParam(value = "reply", required = false) String reply , @RequestParam(value = "reId", required = false) ObjectId id){
		HttpSession session = request.getSession(false);
		String userName = (String) session.getAttribute("userName"); 
		logger.info("Reply receiving:" + reply);
		Date date = new Date();
		Query query = new Query(Criteria.where("id").is(id));
		Tweet tweet = mongoOperation.findOne(query, Tweet.class);		
		List<String[]> valReturn  = tweet.getReplies();
		if(reply!=""){
			tweet.addReply(userName, reply, date);
			mongoOperation.save(tweet);
			valReturn = new ArrayList<String[]>();
			valReturn.add(new String[]{userName, reply, date.toString()});
		}
		return valReturn;
	}
	
	@RequestMapping(value="/Fetch",method=RequestMethod.GET)
	@ResponseBody
	public String  fetch(Model m, HttpServletRequest request,  @RequestParam(value = "reply", required = false) String reply , @RequestParam(value = "reId", required = false) ObjectId id){
		HttpSession session = request.getSession(false);
		String userName = (String) session.getAttribute("userName"); 
		int z = (Integer)session.getAttribute(  "scroll" );
		List<Tweet> jits = new ArrayList<Tweet>();
		jits = tweetsPage(myQuery, z, mongoOperation);
		//for (Tweet myTweet: jits )
		//	System.out.println(myTweet.getDate());
		session.setAttribute( "scroll", ++z);
		return new Gson().toJson(jits);
	}	
	
	private static List<Tweet> tweetsPage(Query query, int i, MongoOperations mongoOperation) {
		// TODO Auto-generated method stub
		//logger.info("Get all jits for every follower with paging");
		//Query query = new Query(Criteria.where("userName").in(followers));
		Pageable pageable = new PageRequest(i,20);
		query.with(pageable);
		return mongoOperation.find(query, Tweet.class);
		//for (Tweet myTweet: jits )
		//	System.out.println(myTweet.getText());
		//logger.info("next page");	
		}
}
