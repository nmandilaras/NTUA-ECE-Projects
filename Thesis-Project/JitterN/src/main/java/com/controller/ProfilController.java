package com.controller;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.model.Tweet;
import com.model.User;
import com.mongo.MongoMyClient;

@Controller
public class ProfilController {

	ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
	MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");	
	
	@RequestMapping(value="/Profil",method=RequestMethod.POST)
	public String  profil(Model m, HttpServletRequest request,@ModelAttribute("usr") String usr){
		HttpSession session = request.getSession(false);
		String userName = (String) session.getAttribute("userName");
		boolean follow;
		String followText;
		m.addAttribute("userName", userName);
		new Criteria();
		Query query = new Query(Criteria.where("userName").is(userName));
		if (!usr.equals(userName)){
			User user = mongoOperation.findOne(query, User.class);
			if(user != null){
				List<String> followers = user.getFollowers();
				if (followers!=null && followers.contains(usr)){
					follow = true;
					followText = "Unfollow";
				}
				else{
					follow = false;
					followText = "Follow";
				}
				m.addAttribute("follow", follow);
				m.addAttribute("followText", followText);
				m.addAttribute("visible","none");
			}
		}
		else{
			m.addAttribute("visibleF","none");
		}
		query = new Query(Criteria.where("userName").is(usr));
		List<Tweet> jits = mongoOperation.find(query, Tweet.class);
	    Collections.sort(jits, new Comparator<Tweet>() {
	        @Override
	        public int compare(Tweet a, Tweet b) {
	            // -1 - less than, 1 - greater than, 0 - equal, all inversed for descending
	            if (a.getDate().after(b.getDate()))
	            	return -1;
	            else
	            	return 1;
	        }
	    });
		m.addAttribute("results", jits);
		return "profil";
	}
	
	@RequestMapping(value="/Follow",method=RequestMethod.GET)
	@ResponseBody
	public String  welcome(Model m,  HttpServletRequest request,  @RequestParam("fol") boolean follow,  @RequestParam("usr") String usr){
		HttpSession session = request.getSession(false);
		String userName = (String) session.getAttribute("userName");
		System.out.println("User = " + usr + " Follow = " + follow );
		new Criteria();
		Query query = new Query(Criteria.where("userName").is(userName));
		User user = mongoOperation.findOne(query, User.class);
		// if just search for the id of usr and then process the list of followers with it instead of usr
		// by this way we could save the use of a secondary index
		if (!follow){
			user.addFollower(usr);
		}
		else{
			user.deleteFollower(usr);
		}
		mongoOperation.save(user);
		return "ok";
	}
	
	@RequestMapping(value="/Delete",method=RequestMethod.GET)
	@ResponseBody
	public String  delete(Model m, HttpServletRequest request,  @RequestParam(value = "reId", required = false) ObjectId id){
		HttpSession session = request.getSession(false);
		String userName = (String) session.getAttribute("userName"); 
		Query query = new Query(Criteria.where("id").is(id));
		mongoOperation.remove(query, Tweet.class);	
		return "ok";
	}	
}
