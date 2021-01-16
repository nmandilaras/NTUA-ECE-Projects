package com.controller;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.model.User;
import com.mongo.MongoMyClient;

@Controller
public class CredController {
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String redirect(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("userName") == null) return "redirect:/pages/log.html";
		else return "redirect:/Home";
	}

	@RequestMapping(value="/Login",method=RequestMethod.GET)
	@ResponseBody
	public String  login(HttpServletRequest request, @RequestParam(value = "userName", required = false) String userName, @RequestParam(value = "password", required = false) String password){
		String response;
		Date date = new Date();
		ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
		MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");		
		new Criteria();
		Query query = new Query(Criteria.where("userName").is(userName));
		System.out.println("Start processing...");
		User user = mongoOperation.findOne(query, User.class);
		if(user != null){
			if (user.getPassword() != password.hashCode() && false) //hack
				response = "password";
			else{
				HttpSession session = request.getSession(true);
				session.setAttribute( "userName", userName);
				user.setLastLoginDate(date);
				mongoOperation.save(user);
				response = "ok";
				System.out.println("Log in succesful");
			}
		}else{
			response = "userName";
		}
		ctx.close();	
		return response;
	}
	
	@RequestMapping(value="/Sign",method=RequestMethod.GET)
	@ResponseBody
	public String  signup(HttpServletRequest request, @RequestParam(value = "userName") String userName, @RequestParam(value = "password") String password, @RequestParam(value = "email") String email, @RequestParam(value = "realName") String realName){
		System.out.println("Username = " + userName + " Password = " + password );
		String response;
		Date date = new Date();
		ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
		MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");		
		new Criteria();
		Query query = new Query(Criteria.where("userName").is(userName));
		User user = mongoOperation.findOne(query, User.class);
		if(user != null){
				response = "userName";
		}else{
			User userNew = new User();
			userNew.setUserName(userName);
			userNew.setRealName(realName);
			userNew.setPassword(password.hashCode());
			userNew.setEmail(email);
			userNew.setFirstLoginDate(date);
			userNew.setLastLoginDate(date);
			userNew.addFollower(userName);
			mongoOperation.insert(userNew);
			HttpSession session = request.getSession(true);
			session.setAttribute( "userName", userName);
			response = "ok";
		}
		ctx.close();	
		return response;
	}	
	
	@RequestMapping(value="/Logout",method=RequestMethod.GET)
	public String  logout(HttpServletRequest request){
		request.getSession().invalidate();
		return "redirect:/pages/log.html";
	}
	
	@RequestMapping(value="/welcome",method=RequestMethod.GET)
	public String  welcome(Model m){
		m.addAttribute("test","A kai ...");
		return "welcome";
	}
}