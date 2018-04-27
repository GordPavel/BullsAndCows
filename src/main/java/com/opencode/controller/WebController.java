package com.opencode.controller;

import com.opencode.repository.PlayersRepository;
import com.opencode.service.PlayersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import java.time.format.DateTimeFormatter;


@Controller
public class WebController{

    @Autowired PasswordEncoder   passwordEncoder;
    @Autowired PlayersRepository playersRepository;
    @Autowired PlayersService    playersService;

    @Bean
    Validator getRegistrationValidator(){
        return new Validator(){
            @Override
            public boolean supports( Class<?> aClass ){
                return RegistrationForm.class.equals( aClass );
            }

            @Override
            public void validate( Object o , Errors errors ){
                ValidationUtils.rejectIfEmptyOrWhitespace( errors , "login" , "" , "Couldn't be empty" );
                ValidationUtils.rejectIfEmptyOrWhitespace( errors , "password" , "" , "Couldn't be empty" );
                ValidationUtils.rejectIfEmptyOrWhitespace( errors , "passwordConfirm" , "" , "Couldn't be empty" );

                if( playersRepository.getByLogin( ( ( RegistrationForm ) o ).getLogin() ).isPresent() )
                    errors.rejectValue( "login" , "" , "Nickname already exists" );
            }
        };
    }

    @ModelAttribute( "registrationForm" )
    RegistrationForm registrationForm(){
        return new RegistrationForm();
    }

    @GetMapping( value = "/" )
    String login(){
        return "login";
    }

    @GetMapping( value = "/person" )
    String personPage( Model model ){
//        Получает данные о пользователе из аттрибутов сессии
        model.addAttribute( "user" ,
                            playersService.loadEntity( ( ( User ) SecurityContextHolder.getContext()
                                                                                       .getAuthentication()
                                                                                       .getPrincipal() ).getUsername() ,
                                                       true ) );
        model.addAttribute( "formatter" , DateTimeFormatter.ofPattern( "dd.MM.yyyy HH:mm" ) );
        return "playerPage";
    }

    @PostMapping( value = "/registration" )
    String registration(
            @ModelAttribute( "registrationForm" )
                    RegistrationForm form , BindingResult bindingResult , Model model ){
        getRegistrationValidator().validate( form , bindingResult );
        if( bindingResult.hasErrors() ) return "login";
        playersService.save( form );
        model.addAttribute( "registrationSuccess" , "Registration success" );
        return "login";
    }
}
