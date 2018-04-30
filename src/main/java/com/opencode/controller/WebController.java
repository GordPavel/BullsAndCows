package com.opencode.controller;

import com.opencode.repository.PlayersRepository;
import com.opencode.service.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;
import org.springframework.web.bind.annotation.*;

import java.time.format.DateTimeFormatter;
import java.util.Optional;


@Controller
public class WebController{

    @Autowired PasswordEncoder   passwordEncoder;
    @Autowired PlayersRepository playersRepository;
    @Autowired Service           service;

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

    @GetMapping( value = { "/" , "/login" } )
    String login(
            @RequestParam( required = false )
                    String logout , Model model ){
        final Optional<?> game = playersRepository.getNotEndedGameByPlayerLogin( "login" );
        if( logout != null ){
            model.addAttribute( "logout" , "You have been logged out successfully." );
            return "login";
        }
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if( authentication.getPrincipal() instanceof User ){
            final String login = ( ( User ) authentication.getPrincipal() ).getUsername();
            return "redirect:/person/" + login;
        }
        return "login";
    }

    @GetMapping( value = "/person/{login}" )
    String personPage(
            @PathVariable
                    String login , Model model ){
//        todo Если пользователь не найден
        model.addAttribute( "user" , service.loadEntity( login , true ).get() );
        model.addAttribute( "formatter" , DateTimeFormatter.ofPattern( "dd.MM.yyyy HH:mm" ) );
        return "playerPage";
    }

    @PostMapping( value = "/registration" )
    String registration(
            @ModelAttribute( "registrationForm" )
                    RegistrationForm form , BindingResult bindingResult , Model model ){
        getRegistrationValidator().validate( form , bindingResult );
        if( bindingResult.hasErrors() ) return "login";
        form.setPassword( passwordEncoder.encode( form.getPassword() ) );
        service.save( form );
        model.addAttribute( "registrationSuccess" , "Registration success" );
        return "login";
    }
}
