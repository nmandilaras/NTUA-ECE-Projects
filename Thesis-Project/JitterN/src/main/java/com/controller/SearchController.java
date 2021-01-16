package com.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.bson.types.ObjectId;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.model.Hashtag;
import com.model.Tweet;
import com.model.User;
import com.mongo.MongoMyClient;

@Controller
public class SearchController {

	@RequestMapping(value="/Search",method=RequestMethod.POST)
	public String  search(Model m, HttpServletRequest request, @ModelAttribute("search") String searchString ){
		HttpSession session = request.getSession(false);
		String userName = (String) session.getAttribute("userName");
		m.addAttribute("userName", userName);
		ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
		MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");		
		if (searchString.startsWith("#")){
			m.addAttribute("title", searchString);
			new Criteria();
			Query query = new Query(Criteria.where("text").is(searchString.substring(1)));	
			Hashtag hashtag = mongoOperation.findOne(query, Hashtag.class);
			List<Tweet> jits = new ArrayList<Tweet>();
			if (hashtag != null){
				List<ObjectId> jitsToRemove = new ArrayList<ObjectId>();
				for (ObjectId jitId : hashtag.getJits()){
					 new Criteria();
					query = new Query(Criteria.where("id").is(jitId));	
					 Tweet tweet = mongoOperation.findOne(query, Tweet.class);
					 if (tweet != null)
						 jits.add(tweet);
					 else
						 jitsToRemove.add(jitId);
				}
				for (ObjectId jitId : jitsToRemove)
					hashtag.removeJit(jitId);
				mongoOperation.save(hashtag);
			}
			m.addAttribute("jits", jits);
		}else{
			m.addAttribute("title", "Persons");
			Pattern pattern = Pattern.compile("^" + searchString);
			new Criteria();
			Query query = new Query(Criteria.where("userName").regex(pattern));	
			List<User> users = mongoOperation.find(query, User.class);
			m.addAttribute("results", users);
		}
		ctx.close();
		return "search";
	}
}
